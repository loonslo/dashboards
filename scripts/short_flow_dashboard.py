#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""A股短线资金跟随看板：资金流和观察池信号，不执行交易。"""

import argparse
import datetime as dt
import json
import os
import statistics
import subprocess
import sys
import time
import urllib.parse
import urllib.request
import shutil
from concurrent.futures import ThreadPoolExecutor, as_completed


HERE = os.path.dirname(os.path.abspath(__file__))
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
TIMEOUT = 12
MAX_WORKERS = int(os.environ.get("SHORT_FLOW_MAX_WORKERS", "8"))
DEFAULT_WATCHLIST = os.path.join(os.path.dirname(HERE), "dashboards", "short-flow", "watchlist_v1.json")
DEFAULT_OUTPUT = os.path.join(os.path.dirname(HERE), "dashboards", "short-flow", "dashboard_latest.json")
DEFAULT_ETF_UNIVERSE = os.path.join(os.path.dirname(HERE), "dashboards", "short-flow", "a_share_etf_universe.json")
DEFAULT_SCAN_LIMIT = int(os.environ.get("SHORT_FLOW_SCAN_LIMIT", "0"))
DEFAULT_OUTPUT_LIMIT = int(os.environ.get("SHORT_FLOW_OUTPUT_LIMIT", "120"))
ETF_CATEGORIES = {
    "CORE": "宽基ETF",
    "GROWTH": "成长宽基",
    "THEME": "主题ETF",
    "SECTOR": "行业ETF",
    "DEFENSE": "防守/红利",
    "CROSS": "跨境ETF",
    "COMMODITY": "商品ETF",
    "BOND": "债券ETF",
    "MONEY": "货币ETF",
}


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


def headers_for(url):
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/json,text/plain,*/*",
        "Connection": "close",
    }
    if "web.ifzq.gtimg.cn" in url:
        headers["Referer"] = "https://gu.qq.com/"
    elif "eastmoney.com" in url:
        headers["Referer"] = "https://quote.eastmoney.com/"
    return headers


def get_json(url):
    last_error = None
    for attempt in range(3):
        req = urllib.request.Request(url, headers=headers_for(url))
        try:
            with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
                return json.loads(response.read().decode("utf-8"))
        except Exception as exc:
            last_error = exc
            time.sleep(0.4 + attempt * 0.8)

    curl = shutil.which("curl") or shutil.which("curl.exe")
    if curl:
        headers = headers_for(url)
        command = [curl, "-L", "--http1.1", "-A", headers.get("User-Agent", USER_AGENT)]
        if headers.get("Referer"):
            command.extend(["-e", headers["Referer"]])
        command.append(url)
        try:
            completed = subprocess.run(command, capture_output=True, text=True, timeout=TIMEOUT + 10, check=True)
            return json.loads(completed.stdout)
        except Exception as exc:
            last_error = exc
    raise last_error


def secid_for(code):
    code = str(code).strip()
    if code.startswith(("5", "6", "9")):
        return f"1.{code}"
    return f"0.{code}"

def tencent_symbol_for(code):
    code = str(code).strip()
    prefix = "sh" if code.startswith(("5", "6", "9")) else "sz"
    return f"{prefix}{code}"


def classify_etf(code, name):
    name = name or ""
    if any(token in name for token in ("货币", "现金", "添利", "快线", "日利", "保证金")):
        return "MONEY"
    if any(token in name for token in ("债", "国开", "可转债")):
        return "BOND"
    if any(token in name for token in ("黄金", "有色", "豆粕", "能源化工")):
        return "COMMODITY"
    if any(token in name for token in ("纳指", "标普", "恒生", "港股", "日经")):
        return "CROSS"
    if any(token in name for token in ("红利", "低波")):
        return "DEFENSE"
    if any(token in name for token in ("半导体", "芯片", "AI", "人工智能", "机器人")):
        return "THEME"
    if any(token in name for token in ("证券", "医药", "通信", "军工", "新能源", "传媒", "银行", "券商", "消费", "酒")):
        return "SECTOR"
    if any(token in name for token in ("创业板", "科创", "双创")):
        return "GROWTH"
    if any(token in name for token in ("上证50", "沪深300", "中证500", "中证1000", "A500", "宽基")):
        return "CORE"
    return "SECTOR"


def fetch_all_a_share_etfs(max_pages=40, page_size=100):
    items = []
    seen = set()
    total = None
    fields = "f12,f14,f2,f3,f5,f6,f20"
    fs = "b:MK0021,b:MK0022,b:MK0023,b:MK0024"
    for page in range(1, max_pages + 1):
        query = urllib.parse.urlencode({
            "pn": page,
            "pz": page_size,
            "po": 1,
            "np": 1,
            "fltt": 2,
            "invt": 2,
            "fid": "f6",
            "fs": fs,
            "fields": fields,
        }, safe=",:")
        payload = None
        last_error = None
        for host in ("push2.eastmoney.com", "push2delay.eastmoney.com"):
            try:
                payload = get_json(f"https://{host}/api/qt/clist/get?{query}")
                break
            except Exception as exc:
                last_error = exc
        if payload is None:
            if items:
                break
            raise last_error
        data = payload.get("data") or {}
        if total is None:
            total = data.get("total")
        diff = data.get("diff") or []
        if not diff:
            break
        for row in diff:
            code = str(row.get("f12") or "").strip()
            name = str(row.get("f14") or "").strip()
            if not code or not name or code in seen:
                continue
            seen.add(code)
            category = classify_etf(code, name)
            items.append({
                "code": code,
                "name": name,
                "market": "SH" if code.startswith(("5", "6")) else "SZ",
                "category": category,
                "group": ETF_CATEGORIES.get(category, "ETF"),
                "role": "scan",
                "priority": "normal",
                "source_pool": "Eastmoney:all_a_share_etf",
                "last_price": to_float(row.get("f2")),
                "pct": to_float(row.get("f3")),
                "volume": to_float(row.get("f5")),
                "amount": to_float(row.get("f6")),
                "market_cap": to_float(row.get("f20")),
            })
        if total and len(items) >= int(total):
            break
        time.sleep(0.2)
    return items


def read_json(path, default):
    try:
        with open(path, encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return default


def write_etf_universe(path, items, errors=None):
    data = {
        "updated_at": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "source": "Eastmoney:all_a_share_etf",
        "errors": errors or [],
        "items": items,
    }
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2)
        handle.write("\n")


def load_etf_universe(path, refresh=True):
    errors = []
    if refresh:
        try:
            items = fetch_all_a_share_etfs()
            if items:
                write_etf_universe(path, items)
                return items, errors
        except Exception as exc:
            errors.append(f"全量ETF池刷新失败，尝试使用本地缓存: {exc}")
    payload = read_json(path, {})
    items = payload.get("items") if isinstance(payload, dict) else None
    if items:
        return items, errors
    errors.append("全量ETF池为空，回退到手工观察池")
    return [], errors


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


def merge_scan_items(universe_items, watch_items, scan_limit=0):
    watch_by_code = {str(item.get("code") or "").strip(): item for item in watch_items if item.get("code")}
    merged = {}
    for item in universe_items:
        code = str(item.get("code") or "").strip()
        if not code:
            continue
        category = item.get("category") or classify_etf(code, item.get("name"))
        row = {
            "code": code,
            "name": item.get("name") or code,
            "group": item.get("group") or ETF_CATEGORIES.get(category, "ETF"),
            "role": "scan",
            "priority": "normal",
            "category": category,
            "source_pool": item.get("source_pool") or "all_a_share_etf",
        }
        override = watch_by_code.get(code)
        if override:
            row.update({key: value for key, value in override.items() if value is not None})
            row["source_pool"] = "watchlist+all_a_share_etf"
        merged[code] = row
    for code, item in watch_by_code.items():
        if code not in merged:
            category = classify_etf(code, item.get("name"))
            row = {
                "code": code,
                "name": item.get("name") or code,
                "group": item.get("group") or ETF_CATEGORIES.get(category, "ETF"),
                "role": item.get("role") or "watch",
                "priority": item.get("priority") or "normal",
                "category": category,
                "source_pool": "watchlist_only",
            }
            row.update(item)
            merged[code] = row
    priority_order = {"core": 0, "high": 1, "normal": 2}
    rows = sorted(
        merged.values(),
        key=lambda row: (
            priority_order.get(row.get("priority"), 9),
            0 if row.get("role") in ("market", "watch") else 1,
            row.get("group") or "",
            row.get("code") or "",
        ),
    )
    if scan_limit and scan_limit > 0:
        pinned = [row for row in rows if row.get("role") in ("market", "watch")]
        pinned_codes = {row.get("code") for row in pinned}
        rest = [row for row in rows if row.get("code") not in pinned_codes]
        rows = pinned + rest[:max(0, scan_limit - len(pinned))]
    return rows


def candidate_score(row):
    score = 0.0
    status = row.get("status")
    if status == "Focus watch":
        score += 100
    elif status == "Wait for strength":
        score += 25
    score += max(-20, min(20, row.get("main_net_pct") or 0)) * 1.5
    score += max(-20, min(20, row.get("return_5d_pct") or 0)) * 0.4
    score += max(-30, min(30, row.get("return_20d_pct") or 0)) * 0.15
    amount_ratio = row.get("amount_ratio_20")
    if amount_ratio is not None:
        score += min(amount_ratio, 3) * 8
    if row.get("role") in ("market", "watch"):
        score += 12
    if row.get("priority") == "core":
        score += 8
    elif row.get("priority") == "high":
        score += 4
    if row.get("category") in ("MONEY", "BOND"):
        score -= 35
    if row.get("source_price") == "unavailable":
        score -= 80
    return score


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
    if len(parts) < 6:
        return {}
    result = {
        "flow_date": parts[0],
        "main_net": to_float(parts[1]),
        "small_net": to_float(parts[2]),
        "medium_net": to_float(parts[3]),
        "large_net": to_float(parts[4]),
        "super_large_net": to_float(parts[5]),
    }
    if len(parts) >= 13:
        result.update({
            "main_net_pct": to_float(parts[6]),
            "small_net_pct": to_float(parts[7]),
            "medium_net_pct": to_float(parts[8]),
            "large_net_pct": to_float(parts[9]),
            "super_large_net_pct": to_float(parts[10]),
            "flow_close": to_float(parts[11]),
            "flow_pct": to_float(parts[12]),
        })
    return result


def fetch_klines(code, limit=90):
    symbol = tencent_symbol_for(code)
    query = urllib.parse.urlencode({"param": f"{symbol},day,,,{limit},qfq"})
    payload = get_json(f"https://web.ifzq.gtimg.cn/appstock/app/fqkline/get?{query}")
    data = (payload.get("data") or {}).get(symbol) or {}
    raw_rows = data.get("qfqday") or data.get("day") or []
    rows = []
    prev_close = None
    for item in raw_rows:
        if len(item) < 6:
            continue
        close = to_float(item[2])
        volume = to_float(item[5])
        amount = close * volume * 100 if close is not None and volume is not None else None
        row = {
            "date": item[0],
            "open": to_float(item[1]),
            "close": close,
            "high": to_float(item[3]),
            "low": to_float(item[4]),
            "volume": volume,
            "amount": amount,
            "amplitude_pct": None,
            "pct": pct_change(close, prev_close),
            "change": close - prev_close if close is not None and prev_close is not None else None,
            "turnover_pct": None,
        }
        rows.append(row)
        if close is not None:
            prev_close = close
    if not rows:
        raise RuntimeError("腾讯日线为空")
    qt = data.get("qt") or {}
    qt_row = qt.get(symbol) or []
    meta = {"name": qt_row[1] if len(qt_row) > 1 else None}
    return meta, rows


def fetch_flow(code):
    fields1 = "f1,f2,f3,f7"
    fields2 = "f51,f52,f53,f54,f55,f56"
    query = urllib.parse.urlencode({
        "lmt": "1",
        "klt": "101",
        "secid": secid_for(code),
        "fields1": fields1,
        "fields2": fields2,
    })
    payload = get_json(f"https://push2delay.eastmoney.com/api/qt/stock/fflow/kline/get?{query}")
    data = payload.get("data") or {}
    rows = data.get("klines") or []
    return parse_flow(rows[-1]) if rows else {}


def fetch_flow_batch(items):
    secids = [secid_for(item.get("code")) for item in items if item.get("code")]
    if not secids:
        return {}
    result = {}
    fields = "f12,f14,f2,f3,f6,f62,f184,f66,f72,f78,f84"
    for index in range(0, len(secids), 4):
        chunk = ",".join(secids[index:index + 4])
        query = urllib.parse.urlencode({
            "fltt": "2",
            "invt": "2",
            "secids": chunk,
            "fields": fields,
        }, safe=",")
        try:
            payload = get_json(f"https://push2delay.eastmoney.com/api/qt/ulist.np/get?{query}")
        except Exception:
            time.sleep(0.3)
            continue
        diff = ((payload.get("data") or {}).get("diff") or [])
        for row in diff:
            code = str(row.get("f12") or "").strip()
            if not code:
                continue
            result[code] = {
                "main_net": to_float(row.get("f62")),
                "main_net_pct": to_float(row.get("f184")),
                "super_large_net": to_float(row.get("f66")),
                "large_net": to_float(row.get("f72")),
                "medium_net": to_float(row.get("f78")),
                "small_net": to_float(row.get("f84")),
                "flow_date": None,
            }
        time.sleep(0.2)
    return result

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


def collect_one(item, flow_map=None):
    code = str(item["code"])
    meta, klines = fetch_klines(code)
    flow_error = None
    flow_source = "Eastmoney:stock/fflow"
    if flow_map is not None:
        flow = flow_map.get(code) or {}
        if not flow:
            try:
                flow = fetch_flow(code)
                if not flow:
                    flow_error = "批量资金流未返回；单只资金流为空"
            except Exception as exc:
                flow = {}
                flow_error = f"批量资金流未返回；单只资金流失败: {exc}"
        else:
            flow_source = "Eastmoney:qt/ulist.np"
    else:
        try:
            flow = fetch_flow(code)
        except Exception as exc:
            flow = {}
            flow_error = str(exc)
    latest = klines[-1]
    closes = [row["close"] for row in klines]
    row = {
        "code": code,
        "secid": secid_for(code),
        "name": meta.get("name") or item.get("name") or code,
        "display_name": item.get("name") or meta.get("name") or code,
        "group": item.get("group") or "未分组",
        "role": item.get("role") or "watch",
        "priority": item.get("priority") or "normal",
        "category": item.get("category"),
        "source_pool": item.get("source_pool"),
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
        "main_net": None,
        "main_net_pct": None,
        "super_large_net": None,
        "large_net": None,
        "small_net": None,
        "source_price": "Tencent:appstock/fqkline",
        "source_flow": "unavailable" if flow_error else flow_source,
        "flow_error": flow_error,
    }
    row.update(flow)
    amount = row.get("amount")
    for key, pct_key in (
        ("main_net", "main_net_pct"),
        ("small_net", "small_net_pct"),
        ("large_net", "large_net_pct"),
        ("super_large_net", "super_large_net_pct"),
    ):
        if row.get(pct_key) is None and row.get(key) is not None and amount not in (None, 0):
            row[pct_key] = row.get(key) / amount * 100
    status, reason = classify(row)
    if flow_error:
        reason = f"资金流暂不可用，价格/均线已更新：{flow_error}；{reason}"
    row["status"] = status
    row["reason"] = reason
    row["next_trigger"] = trigger_text(row)
    row["failure"] = failure_text(row)
    row["score"] = candidate_score(row)
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
        "category": item.get("category"),
        "source_pool": item.get("source_pool"),
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
        "score": -80,
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
            old = previous_rows.get(str(row.get("code")))
            if row_is_live(row):
                if row.get("main_net") is None and old and old.get("main_net") is not None:
                    for key in (
                        "main_net",
                        "main_net_pct",
                        "super_large_net",
                        "large_net",
                        "medium_net",
                        "small_net",
                        "small_net_pct",
                        "large_net_pct",
                        "super_large_net_pct",
                        "flow_date",
                    ):
                        if row.get(key) is None and old.get(key) is not None:
                            row[key] = old.get(key)
                    row["source_flow"] = old.get("source_flow") or "stale"
                    row["flow_data_status"] = "stale"
                    row["stale_flow_from_asof"] = previous.get("asof")
                    row["reason"] = "本次资金流接口失败，沿用上次资金流；" + str(row.get("reason") or "")
                elif row.get("main_net") is not None:
                    row["flow_data_status"] = "live"
                row["data_status"] = "live"
                live_count += 1
                merged.append(row)
                continue

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
    if not data.get("ranked_inflow"):
        data["ranked_inflow"] = sorted(
            all_rows,
            key=lambda row: row.get("main_net") if row.get("main_net") is not None else -10**30,
            reverse=True,
        )[:8]
    if not data.get("ranked_outflow"):
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
        "policy": "价格live优先；价格接口失败沿用上次有效行；资金流接口失败时可沿用上次资金流。",
    }
    return data
def select_watch_rows(rows, output_limit):
    pinned = [row for row in rows if row.get("role") == "watch"]
    focus = [row for row in rows if row.get("status") == "Focus watch" and row.get("role") != "market"]
    wait = [
        row for row in rows
        if row.get("status") == "Wait for strength"
        and row.get("role") not in ("market", "watch")
        and (
            (row.get("main_net") is not None and row.get("main_net") > 0)
            or (row.get("main_net_pct") is not None and row.get("main_net_pct") > 0)
            or (row.get("score") or 0) >= 30
        )
    ]
    selected = {}
    for group in (pinned, focus, sorted(wait, key=lambda row: row.get("score") or -10**9, reverse=True)):
        for row in group:
            code = row.get("code")
            if code and code not in selected:
                selected[code] = row
            if len(selected) >= output_limit:
                return list(selected.values())
    return list(selected.values())


def collect_dashboard(watchlist_path, universe_path=DEFAULT_ETF_UNIVERSE, scan_limit=DEFAULT_SCAN_LIMIT, output_limit=DEFAULT_OUTPUT_LIMIT, refresh_universe=True):
    watch_items = load_watchlist(watchlist_path)
    universe_items, universe_gaps = load_etf_universe(universe_path, refresh=refresh_universe)
    items = merge_scan_items(universe_items, watch_items, scan_limit=scan_limit) if universe_items else merge_scan_items([], watch_items, scan_limit=scan_limit)
    flow_map = {}
    flow_batch_error = None
    try:
        flow_map = fetch_flow_batch(items)
    except Exception as exc:
        flow_batch_error = str(exc)
    rows = []
    gaps = []
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
        futures = {pool.submit(collect_one, item, flow_map): item for item in items}
        for future in as_completed(futures):
            item = futures[future]
            try:
                rows.append(future.result())
            except Exception as exc:
                gaps.append(f"{item.get('code')}/{item.get('name')}: {exc}")
                rows.append(fallback_row(item, exc))

    if flow_batch_error:
        gaps.append(f"资金流批量接口: {flow_batch_error}")
    gaps.extend(universe_gaps)
    priority_order = {"core": 0, "high": 1, "normal": 2}
    rows.sort(key=lambda row: (
        0 if row.get("role") == "market" else 1,
        priority_order.get(row.get("priority"), 9),
        -(row.get("score") or -10**9),
        row.get("group") or "",
        row.get("code") or "",
    ))
    market_rows = [row for row in rows if row.get("role") == "market"]
    watch_rows = select_watch_rows(rows, output_limit)
    ranked_inflow = sorted(rows, key=lambda row: row.get("main_net") if row.get("main_net") is not None else -10**30, reverse=True)[:12]
    ranked_outflow = sorted(rows, key=lambda row: row.get("main_net") if row.get("main_net") is not None else 10**30)[:12]
    status_counts = {name: sum(1 for row in watch_rows if row.get("status") == name) for name in ("Focus watch", "Wait for strength", "Exclude for now")}
    dates = sorted({row.get("trade_date") for row in rows if row.get("trade_date")})
    return {
        "asof": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "trade_date": dates[-1] if dates else "N/A",
        "purpose": "A股短线资金跟随：盘后从全量A股ETF池筛下一交易日观察候选，不预测、不自动交易。",
        "layers": ["全量A股ETF扫描", "手工置顶观察", "资金流排名"],
        "scan_scope": {
            "mode": "all_a_share_etf",
            "universe_path": os.path.relpath(universe_path, os.path.dirname(HERE)),
            "universe_count": len(universe_items),
            "watchlist_count": len(watch_items),
            "scanned_count": len(items),
            "result_count": len(watch_rows),
            "output_limit": output_limit,
            "scan_limit": scan_limit,
        },
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
            "market_flow": [{"code": "510300", "close": 4.0, "source_price": "Tencent:appstock/fqkline", "main_net": 1}],
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
    parser.add_argument("--etf-universe", default=DEFAULT_ETF_UNIVERSE, help="全量A股ETF池JSON")
    parser.add_argument("--scan-limit", type=int, default=DEFAULT_SCAN_LIMIT, help="扫描ETF数量上限，0表示扫描全量")
    parser.add_argument("--output-limit", type=int, default=DEFAULT_OUTPUT_LIMIT, help="输出候选数量上限")
    parser.add_argument("--no-refresh-universe", action="store_true", help="不刷新全量ETF池，只使用本地缓存")
    parser.add_argument("--dashboard-json", default=DEFAULT_OUTPUT, help="输出看板JSON")
    parser.add_argument("--previous-json", default=None, help="读取上一版有效快照，用于接口失败时沿用旧数据")
    parser.add_argument("--json", action="store_true", help="同时打印JSON")
    parser.add_argument("--selftest", action="store_true", help="运行离线自测")
    args = parser.parse_args()
    if args.selftest:
        return 0 if selftest() else 1
    data = collect_dashboard(
        args.watchlist,
        universe_path=args.etf_universe,
        scan_limit=args.scan_limit,
        output_limit=args.output_limit,
        refresh_universe=not args.no_refresh_universe,
    )
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
























