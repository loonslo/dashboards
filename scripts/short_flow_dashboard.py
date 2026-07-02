#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""A股短线资金跟随看板：资金流和观察池信号，不执行交易。"""

import argparse
import datetime as dt
import json
import os
import statistics
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed


HERE = os.path.dirname(os.path.abspath(__file__))
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ShortFlowDashboard/0.1"
TIMEOUT = 12
MAX_WORKERS = int(os.environ.get("SHORT_FLOW_MAX_WORKERS", "1"))
DEFAULT_WATCHLIST = os.path.join(os.path.dirname(HERE), "dashboards", "short-flow", "watchlist_v1.json")
DEFAULT_OUTPUT = os.path.join(os.path.dirname(HERE), "dashboards", "short-flow", "dashboard_latest.json")


def to_float(value):
    if value in (None, "", "-"):
        return None
    try:
        return float(str(value).replace(",", "").replace("%", ""))
    except (TypeError, ValueError):
        return None


def mean(values):
    nums = [value for value in values if value is not None]
    return statistics.fmean(nums) if nums else None


def pct_change(now, old):
    if now is None or old in (None, 0):
        return None
    return (now / old - 1.0) * 100.0


def ratio(now, old):
    if now is None or old in (None, 0):
        return None
    return now / old


def signed(value, digits=1, suffix="%"):
    if value is None:
        return "N/A"
    return f"{value:+.{digits}f}{suffix}"


def get_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT, "Referer": "https://quote.eastmoney.com/"})
    last_error = None
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
                return json.loads(response.read().decode("utf-8"))
        except Exception as exc:
            last_error = exc
            time.sleep(0.4 + attempt * 0.8)
    raise last_error


def secid_for(code):
    code = str(code).strip()
    if code.startswith(("5", "6", "9")):
        return f"1.{code}"
    return f"0.{code}"


def load_watchlist(path):
    with open(path, encoding="utf-8") as handle:
        payload = json.load(handle)
    items = payload.get("items", payload) if isinstance(payload, dict) else payload
    seen = set()
    rows = []
    for item in items:
        code = str(item.get("code") or "").strip()
        if not code or code in seen:
            continue
        seen.add(code)
        rows.append(item)
    return rows


def parse_kline(row):
    parts = row.split(",")
    if len(parts) < 11:
        return None
    return {
        "date": parts[0],
        "open": to_float(parts[1]),
        "close": to_float(parts[2]),
        "high": to_float(parts[3]),
        "low": to_float(parts[4]),
        "volume": to_float(parts[5]),
        "amount": to_float(parts[6]),
        "amplitude_pct": to_float(parts[7]),
        "pct": to_float(parts[8]),
        "change": to_float(parts[9]),
        "turnover_pct": to_float(parts[10]),
    }


def parse_flow(row):
    parts = row.split(",")
    if len(parts) < 13:
        return {}
    return {
        "flow_date": parts[0],
        "main_net": to_float(parts[1]),
        "small_net": to_float(parts[2]),
        "medium_net": to_float(parts[3]),
        "large_net": to_float(parts[4]),
        "super_large_net": to_float(parts[5]),
        "main_net_pct": to_float(parts[6]),
        "small_net_pct": to_float(parts[7]),
        "medium_net_pct": to_float(parts[8]),
        "large_net_pct": to_float(parts[9]),
        "super_large_net_pct": to_float(parts[10]),
        "flow_close": to_float(parts[11]),
        "flow_pct": to_float(parts[12]),
    }


def fetch_klines(code, limit=90):
    fields1 = "f1,f2,f3,f4,f5,f6"
    fields2 = "f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61"
    query = urllib.parse.urlencode({
        "secid": secid_for(code),
        "klt": "101",
        "fqt": "1",
        "lmt": str(limit),
        "end": "20500101",
        "fields1": fields1,
        "fields2": fields2,
    })
    payload = get_json(f"https://push2his.eastmoney.com/api/qt/stock/kline/get?{query}")
    data = payload.get("data") or {}
    rows = [parse_kline(row) for row in data.get("klines") or []]
    rows = [row for row in rows if row and row.get("close") is not None]
    if not rows:
        raise RuntimeError("日线为空")
    return data, rows


def fetch_flow(code):
    fields1 = "f1,f2,f3,f7"
    fields2 = "f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61,f62,f63"
    query = urllib.parse.urlencode({
        "lmt": "1",
        "klt": "101",
        "secid": secid_for(code),
        "fields1": fields1,
        "fields2": fields2,
    })
    payload = get_json(f"https://push2.eastmoney.com/api/qt/stock/fflow/daykline/get?{query}")
    data = payload.get("data") or {}
    rows = data.get("klines") or []
    return parse_flow(rows[-1]) if rows else {}


def moving_average(values, window):
    if len(values) < window:
        return None
    return mean(values[-window:])


def amount_average(rows, window):
    sample = rows[-window - 1:-1]
    if len(sample) < window:
        return None
    return mean([row.get("amount") for row in sample])


def upper_shadow_ratio(row):
    high = row.get("high")
    low = row.get("low")
    open_ = row.get("open")
    close = row.get("close")
    if None in (high, low, open_, close) or high <= low:
        return None
    return (high - max(open_, close)) / (high - low)


def intraday_drawdown_from_high(row):
    high = row.get("high")
    close = row.get("close")
    if high in (None, 0) or close is None:
        return None
    return (close / high - 1.0) * 100.0


def classify(row):
    close = row.get("close")
    ma5 = row.get("ma5")
    ma10 = row.get("ma10")
    ma20 = row.get("ma20")
    main = row.get("main_net")
    main_pct = row.get("main_net_pct")
    amount_ratio_20 = row.get("amount_ratio_20")
    shadow = row.get("upper_shadow_ratio")
    high_fade = row.get("intraday_drawdown_pct")
    ret20 = row.get("return_20d_pct")

    above_ma5 = close is not None and ma5 is not None and close >= ma5
    above_ma10 = close is not None and ma10 is not None and close >= ma10
    above_ma20 = close is not None and ma20 is not None and close >= ma20
    positive_flow = main is not None and main > 0 and (main_pct is None or main_pct > 0)
    weak_flow = main is not None and main < 0
    heavy_upper = (shadow is not None and shadow >= 0.45 and high_fade is not None and high_fade <= -2.0)
    exhausted = ret20 is not None and ret20 >= 30
    active_amount = amount_ratio_20 is None or amount_ratio_20 >= 0.75

    reasons = []
    if positive_flow:
        reasons.append(f"主力净流入{signed(main_pct)}")
    elif weak_flow:
        reasons.append(f"主力净流出{signed(main_pct)}")
    else:
        reasons.append("资金流数据不足")

    if above_ma5 and above_ma10 and above_ma20:
        reasons.append("站上MA5/10/20")
    elif above_ma20:
        reasons.append("仍在MA20上方但短线待修复")
    else:
        reasons.append("短均线结构偏弱")

    if heavy_upper:
        reasons.append("长上影/冲高回落")
    if exhausted:
        reasons.append("20日涨幅偏高")
    if amount_ratio_20 is not None:
        reasons.append(f"成交额为20日均额{amount_ratio_20:.2f}倍")

    if above_ma5 and above_ma10 and above_ma20 and positive_flow and active_amount and not heavy_upper and not exhausted:
        status = "Focus watch"
    elif (not above_ma20 and weak_flow) or (not above_ma10 and weak_flow and main_pct is not None and main_pct <= -5):
        status = "Exclude for now"
    else:
        status = "Wait for strength"

    return status, "；".join(reasons)


def trigger_text(row):
    key_level = row.get("key_level")
    ma5 = row.get("ma5")
    parts = []
    if key_level is not None:
        parts.append(f"先收复/站稳关键位{key_level:.2f}")
    if ma5 is not None:
        parts.append(f"09:40后站稳MA5({ma5:.2f})")
    parts.append("主力资金转正且成交额不明显萎缩")
    parts.append("不追明显长上影后的冲高")
    return "；".join(parts)


def failure_text(row):
    key_level = row.get("key_level")
    ma5 = row.get("ma5")
    ma20 = row.get("ma20")
    parts = []
    if key_level is not None:
        parts.append(f"跌破关键位{key_level:.2f}且资金继续流出")
    if ma5 is not None:
        parts.append(f"跌破MA5({ma5:.2f})且主力净流出")
    if row.get("status") == "Exclude for now" and ma20 is not None:
        parts.append(f"未收回MA20({ma20:.2f})前不纳入买入观察")
    return "；".join(parts)


def collect_one(item):
    code = str(item["code"])
    meta, klines = fetch_klines(code)
    flow = fetch_flow(code)
    latest = klines[-1]
    closes = [row["close"] for row in klines]
    amounts = [row.get("amount") for row in klines]
    row = {
        "code": code,
        "secid": secid_for(code),
        "name": meta.get("name") or item.get("name") or code,
        "display_name": item.get("name") or meta.get("name") or code,
        "group": item.get("group") or "未分组",
        "role": item.get("role") or "watch",
        "priority": item.get("priority") or "normal",
        "plan_note": item.get("plan_note"),
        "key_level": item.get("key_level"),
        "trade_date": latest["date"],
        "open": latest.get("open"),
        "close": latest.get("close"),
        "high": latest.get("high"),
        "low": latest.get("low"),
        "pct": latest.get("pct"),
        "amount": latest.get("amount"),
        "turnover_pct": latest.get("turnover_pct"),
        "ma5": moving_average(closes, 5),
        "ma10": moving_average(closes, 10),
        "ma20": moving_average(closes, 20),
        "ma60": moving_average(closes, 60),
        "return_5d_pct": pct_change(closes[-1], closes[-6] if len(closes) >= 6 else None),
        "return_10d_pct": pct_change(closes[-1], closes[-11] if len(closes) >= 11 else None),
        "return_20d_pct": pct_change(closes[-1], closes[-21] if len(closes) >= 21 else None),
        "amount_ratio_5": ratio(latest.get("amount"), amount_average(klines, 5)),
        "amount_ratio_20": ratio(latest.get("amount"), amount_average(klines, 20)),
        "upper_shadow_ratio": upper_shadow_ratio(latest),
        "intraday_drawdown_pct": intraday_drawdown_from_high(latest),
        "source_price": "Eastmoney:stock/kline",
        "source_flow": "Eastmoney:stock/fflow/daykline",
    }
    row.update(flow)
    status, reason = classify(row)
    row["status"] = status
    row["reason"] = reason
    row["next_trigger"] = trigger_text(row)
    row["failure"] = failure_text(row)
    return row


def fallback_row(item, error):
    role = item.get("role") or "watch"
    status = "Wait for strength" if role != "market" else "Data unavailable"
    return {
        "code": str(item.get("code") or ""),
        "secid": secid_for(item.get("code") or ""),
        "name": item.get("name") or item.get("code"),
        "display_name": item.get("name") or item.get("code"),
        "group": item.get("group") or "未分组",
        "role": role,
        "priority": item.get("priority") or "normal",
        "plan_note": item.get("plan_note"),
        "key_level": item.get("key_level"),
        "trade_date": "N/A",
        "open": None,
        "close": None,
        "high": None,
        "low": None,
        "pct": None,
        "amount": None,
        "turnover_pct": None,
        "ma5": None,
        "ma10": None,
        "ma20": None,
        "ma60": None,
        "return_5d_pct": None,
        "return_10d_pct": None,
        "return_20d_pct": None,
        "amount_ratio_5": None,
        "amount_ratio_20": None,
        "upper_shadow_ratio": None,
        "intraday_drawdown_pct": None,
        "main_net": None,
        "main_net_pct": None,
        "super_large_net": None,
        "large_net": None,
        "small_net": None,
        "status": status,
        "reason": f"行情/资金流暂不可用：{error}",
        "next_trigger": "等待行情和主力资金数据恢复后再确认，不用缺口数据追涨。",
        "failure": "数据不可用时不生成买入结论；重新刷新后再评估。",
        "source_price": "unavailable",
        "source_flow": "unavailable",
    }

def row_is_live(row):
    return row.get("close") is not None and row.get("source_price") != "unavailable"


def rows_by_code(data):
    result = {}
    for section in ("market_flow", "watch_signals"):
        for row in data.get(section, []):
            code = row.get("code")
            if code:
                result[str(code)] = row
    return result


def load_previous_snapshot(path):
    try:
        with open(path, encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return {}


def apply_previous_snapshot(data, previous):
    previous_rows = rows_by_code(previous)
    live_count = 0
    stale_count = 0
    unavailable_count = 0

    for section in ("market_flow", "watch_signals"):
        merged = []
        for row in data.get(section, []):
            if row_is_live(row):
                row["data_status"] = "live"
                live_count += 1
                merged.append(row)
                continue

            old = previous_rows.get(str(row.get("code")))
            if old and row_is_live(old):
                kept = dict(old)
                kept["data_status"] = "stale"
                kept["stale_from_asof"] = previous.get("asof")
                kept["current_fetch_error"] = row.get("reason")
                kept["reason"] = "本次接口失败，沿用上次有效数据；" + str(old.get("reason") or "")
                merged.append(kept)
                stale_count += 1
                continue

            row["data_status"] = "unavailable"
            merged.append(row)
            unavailable_count += 1
        data[section] = merged

    all_rows = data.get("market_flow", []) + data.get("watch_signals", [])
    data["ranked_inflow"] = sorted(
        all_rows,
        key=lambda row: row.get("main_net") if row.get("main_net") is not None else -10**30,
        reverse=True,
    )[:8]
    data["ranked_outflow"] = sorted(
        all_rows,
        key=lambda row: row.get("main_net") if row.get("main_net") is not None else 10**30,
    )[:8]
    watch_rows = data.get("watch_signals", [])
    data["status_counts"] = {
        name: sum(1 for row in watch_rows if row.get("status") == name)
        for name in ("Focus watch", "Wait for strength", "Exclude for now")
    }
    dates = sorted({
        row.get("trade_date")
        for row in all_rows
        if row.get("trade_date") and row.get("trade_date") != "N/A"
    })
    data["trade_date"] = dates[-1] if dates else data.get("trade_date", "N/A")
    data["source_status"] = {
        "live_rows": live_count,
        "stale_rows": stale_count,
        "unavailable_rows": unavailable_count,
        "previous_asof": previous.get("asof"),
        "policy": "live优先；接口失败时沿用上次有效行；无历史有效行才显示N/A。",
    }
    return data

def collect_dashboard(watchlist_path):
    items = load_watchlist(watchlist_path)
    rows = []
    gaps = []
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
        futures = {pool.submit(collect_one, item): item for item in items}
        for future in as_completed(futures):
            item = futures[future]
            try:
                rows.append(future.result())
            except Exception as exc:
                gaps.append(f"{item.get('code')}/{item.get('name')}: {exc}")
                rows.append(fallback_row(item, exc))

    priority_order = {"core": 0, "high": 1, "normal": 2}
    rows.sort(key=lambda row: (priority_order.get(row.get("priority"), 9), row.get("group") or "", row.get("code") or ""))
    market_rows = [row for row in rows if row.get("role") == "market"]
    watch_rows = [row for row in rows if row.get("role") != "market"]
    ranked_inflow = sorted(rows, key=lambda row: row.get("main_net") if row.get("main_net") is not None else -10**30, reverse=True)[:8]
    ranked_outflow = sorted(rows, key=lambda row: row.get("main_net") if row.get("main_net") is not None else 10**30)[:8]
    status_counts = {name: sum(1 for row in watch_rows if row.get("status") == name) for name in ("Focus watch", "Wait for strength", "Exclude for now")}
    dates = sorted({row.get("trade_date") for row in rows if row.get("trade_date")})
    return {
        "asof": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "trade_date": dates[-1] if dates else "N/A",
        "purpose": "A股短线资金跟随：只做资金流和观察池信号，不预测、不自动交易。",
        "layers": ["市场/板块资金流", "观察池信号"],
        "market_flow": market_rows,
        "watch_signals": watch_rows,
        "ranked_inflow": ranked_inflow,
        "ranked_outflow": ranked_outflow,
        "status_counts": status_counts,
        "data_gaps": gaps,
    }


def write_json(data, path):
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2)


def selftest():
    sample = {
        "open": 10.0,
        "close": 10.8,
        "high": 11.0,
        "low": 9.8,
        "ma5": 10.3,
        "ma10": 10.1,
        "ma20": 9.7,
        "main_net": 1000000,
        "main_net_pct": 5.2,
        "amount_ratio_20": 1.1,
        "return_20d_pct": 8.0,
        "intraday_drawdown_pct": -1.8,
        "upper_shadow_ratio": 0.16,
    }
    weak = dict(sample, close=9.2, main_net=-2000000, main_net_pct=-8.0, ma5=10.0, ma10=9.8, ma20=9.6)
    stale_test = apply_previous_snapshot(
        {
            "market_flow": [fallback_row({"code": "510300", "name": "沪深300ETF", "role": "market"}, "boom")],
            "watch_signals": [],
            "data_gaps": ["boom"],
        },
        {
            "asof": "2026-07-01 15:30",
            "market_flow": [{"code": "510300", "close": 4.0, "source_price": "Eastmoney:stock/kline", "main_net": 1}],
            "watch_signals": [],
        },
    )
    checks = [
        ("secid上海", secid_for("601138") == "1.601138"),
        ("secid深圳", secid_for("000636") == "0.000636"),
        ("主力流入强趋势=Focus", classify(sample)[0] == "Focus watch"),
        ("跌破均线且流出=Exclude", classify(weak)[0] == "Exclude for now"),
        ("触发条件包含MA5", "MA5" in trigger_text({"ma5": 10.2, "key_level": None})),
        ("接口失败沿用旧有效数据", stale_test["market_flow"][0].get("data_status") == "stale" and stale_test["source_status"]["stale_rows"] == 1),
    ]
    ok = True
    for name, passed in checks:
        print(f"[{'PASS' if passed else 'FAIL'}] {name}")
        ok = ok and passed
    return ok


def main():
    parser = argparse.ArgumentParser(description="生成short-flow A股短线资金跟随看板数据")
    parser.add_argument("--watchlist", default=DEFAULT_WATCHLIST, help="观察池JSON")
    parser.add_argument("--dashboard-json", default=DEFAULT_OUTPUT, help="输出看板JSON")
    parser.add_argument("--previous-json", default=None, help="读取上一版有效快照，用于接口失败时沿用旧数据")
    parser.add_argument("--json", action="store_true", help="同时打印JSON")
    parser.add_argument("--selftest", action="store_true", help="运行离线自测")
    args = parser.parse_args()
    if args.selftest:
        return 0 if selftest() else 1
    data = collect_dashboard(args.watchlist)
    previous_path = args.previous_json or args.dashboard_json
    data = apply_previous_snapshot(data, load_previous_snapshot(previous_path))
    write_json(data, args.dashboard_json)
    if args.json:
        print(json.dumps(data, ensure_ascii=False, indent=2))
    else:
        print(f"Wrote short-flow dashboard JSON: {args.dashboard_json}")
    return 0


if __name__ == "__main__":
    sys.exit(main())









