#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""资产管理报告：读取个人持仓、获取实时行情、计算盈亏与配置偏离。"""

import argparse
import datetime as dt
import json
import math
import os
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed


HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)

PORTFOLIO_FILE = os.path.join(REPO, "dashboards", "asset-management", "portfolio.json")
ALLOCATION_FILE = os.path.join(REPO, "dashboards", "asset-management", "allocation.json")
TRADES_FILE = os.path.join(REPO, "dashboards", "asset-management", "trades.json")
OUTPUT_FILE = os.path.join(REPO, "dashboards", "asset-management", "portfolio_latest.json")

# 增量信号文件路径（用于信号-持仓关联）
INDEX_DECISION_SNAPSHOT = os.path.join(REPO, "dashboards", "index-decision", "dashboard_latest.json")
SHORT_FLOW_SNAPSHOT = os.path.join(REPO, "dashboards", "short-flow", "dashboard_latest.json")

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) PortfolioReport/1.0"
TIMEOUT = 12
MAX_WORKERS = 4
# 默认 USD/CNY 汇率，用户可在 portfolio.json 中通过 fx_rate 覆盖
DEFAULT_FX_RATE = 7.20


# ── 工具函数 ──────────────────────────────────────────────

def to_float(value):
    if value in (None, "", "-"):
        return None
    try:
        return float(str(value).replace(",", "").replace("%", ""))
    except (TypeError, ValueError):
        return None


def mean(values):
    nums = [v for v in values if v is not None]
    return sum(nums) / len(nums) if nums else None


def pct_change(now, old):
    if now is None or old in (None, 0):
        return None
    return (now / old - 1.0) * 100.0


def signed_pct(value, digits=1):
    return "N/A" if value is None else f"{value:+.{digits}f}%"


def pct(value, digits=1):
    return "N/A" if value is None else f"{value:.{digits}f}%"


def num(value, digits=2):
    return "N/A" if value is None else f"{value:.{digits}f}"


def headers_for(url):
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/json,text/plain,*/*",
        "Connection": "close",
    }
    if "eastmoney.com" in url:
        headers["Referer"] = "https://quote.eastmoney.com/"
    elif "web.ifzq.gtimg.cn" in url:
        headers["Referer"] = "https://gu.qq.com/"
    elif "yahoo.com" in url or "stooq.com" in url:
        headers["Accept-Language"] = "en-US,en;q=0.9"
    return headers


def get_json(url):
    last_error = None
    for attempt in range(3):
        req = urllib.request.Request(url, headers=headers_for(url))
        try:
            with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except Exception as exc:
            last_error = exc
            time.sleep(0.4 + attempt * 0.8)
    raise last_error


def get_text(url):
    req = urllib.request.Request(url, headers=headers_for(url))
    with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
        return resp.read().decode("utf-8", errors="replace")


def safe_div(a, b):
    if b in (None, 0) or a is None:
        return None
    return a / b


def secid_for(code):
    code = str(code).strip()
    if code.startswith(("5", "6", "9")):
        return f"1.{code}"
    return f"0.{code}"


def tencent_symbol_for(code):
    code = str(code).strip()
    prefix = "sh" if code.startswith(("5", "6", "9")) else "sz"
    return f"{prefix}{code}"


def yahoo_symbol(ticker):
    """Convert ticker to Yahoo Finance symbol."""
    if ticker == "BRK.B":
        return "BRK-B"
    if ticker.endswith(".SH"):
        return ticker[:-3] + ".SS"
    if ticker.endswith(".SZ"):
        return ticker[:-3] + ".SZ"
    return ticker


def sample_std(values):
    clean = [v for v in values if v is not None]
    if len(clean) < 2:
        return None
    avg = sum(clean) / len(clean)
    var = sum((v - avg) ** 2 for v in clean) / (len(clean) - 1)
    return math.sqrt(var)


# ── 行情获取 ──────────────────────────────────────────────

def fetch_yahoo_price(ticker):
    """从 Yahoo Finance 获取最新收盘价和基础指标。"""
    sym = yahoo_symbol(ticker)
    encoded = urllib.parse.quote(sym)
    payload = get_json(f"https://query1.finance.yahoo.com/v8/finance/chart/{encoded}?range=5d&interval=1d")
    result = payload["chart"]["result"][0]
    meta = result.get("meta", {})
    current = to_float(meta.get("regularMarketPrice"))
    prev_close = to_float(meta.get("chartPreviousClose"))
    timestamps = result.get("timestamp") or []
    quote = result["indicators"]["quote"][0]
    closes = quote.get("close") or []
    highs = quote.get("high") or []
    volumes = quote.get("volume") or []
    rows = []
    for idx, _stamp in enumerate(timestamps):
        c = closes[idx] if idx < len(closes) else None
        h = highs[idx] if idx < len(highs) else None
        v = volumes[idx] if idx < len(volumes) else None
        if c is not None:
            rows.append((float(c), float(h) if h is not None else float(c), to_float(v)))
    change_1d = pct_change(current, prev_close) if current is not None else None
    return {
        "current_price": current,
        "change_1d_pct": change_1d,
        "prev_close": prev_close,
        "trade_date": dt.date.today().isoformat(),
        "source": "Yahoo:finance/chart",
    }


def fetch_a_share_quote(code):
    """从腾讯行情获取A股最新收盘价。"""
    symbol = tencent_symbol_for(code)
    query = urllib.parse.urlencode({"param": f"{symbol},day,,,3,qfq"})
    payload = get_json(f"https://web.ifzq.gtimg.cn/appstock/app/fqkline/get?{query}")
    data = (payload.get("data") or {}).get(symbol) or {}
    raw_rows = data.get("qfqday") or data.get("day") or []
    if not raw_rows:
        raise RuntimeError(f"腾讯日线为空: {code}")
    closes = []
    for item in raw_rows:
        c = to_float(item[2])
        if c is not None:
            closes.append(c)
    if len(closes) < 1:
        raise RuntimeError(f"无法解析收盘价: {code}")
    current = closes[-1]
    change_1d = pct_change(closes[-1], closes[-2]) if len(closes) >= 2 else None
    return {
        "current_price": current,
        "change_1d_pct": change_1d,
        "trade_date": raw_rows[-1][0],
        "source": "Tencent:appstock/fqkline",
    }


def fetch_price(item):
    """根据市场获取行情价格。"""
    market = str(item.get("market") or "").strip().upper()
    ticker = str(item.get("ticker") or item.get("code") or "").strip()
    if market == "US":
        return fetch_yahoo_price(ticker)
    elif market == "CN":
        return fetch_a_share_quote(ticker)
    else:
        raise ValueError(f"不支持的市场: {market} 代码: {ticker}")


# ── 数据加载 ──────────────────────────────────────────────

def read_json(path, default=None):
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return default if default is not None else {}


def load_portfolio(path):
    payload = read_json(path, {})
    items = payload.get("items") if isinstance(payload, dict) else payload
    if not items:
        return [], payload.get("capital_base", 0), payload.get("currency", "CNY"), payload.get("fx_rate", DEFAULT_FX_RATE)
    capital_base = payload.get("capital_base", 0)
    currency = payload.get("currency", "CNY")
    fx_rate = payload.get("fx_rate", DEFAULT_FX_RATE)
    return items, capital_base, currency, fx_rate


def load_allocation(path):
    payload = read_json(path, {})
    return payload.get("targets", []), payload.get("base_currency", "CNY")


def load_trades(path):
    payload = read_json(path, {})
    trades = payload.get("trades") if isinstance(payload, dict) else payload
    return trades if isinstance(trades, list) else []


def load_signals(index_path, short_path):
    """加载现有看板信号，用于信号-持仓关联。"""
    idx = read_json(index_path)
    short = read_json(short_path)
    signals = []
    for row in idx.get("indices", []):
        signals.append({"source": "index-decision", "ticker": row.get("code"), "name": row.get("name"), "signal": row.get("signal")})
    for row in idx.get("watchlist", []):
        signals.append({"source": "index-decision", "ticker": row.get("ticker"), "name": row.get("name"), "signal": row.get("signal")})
    for row in short.get("watch_signals", []):
        signals.append({"source": "short-flow", "ticker": row.get("code"), "name": row.get("display_name") or row.get("name"), "signal": row.get("status")})
    return signals


# ── 资产配置逻辑 ──────────────────────────────────────────

def match_bucket(item, targets):
    """将持仓匹配到配置桶。"""
    asset_class = item.get("asset_class", "")
    strategy = item.get("strategy", "")
    for t in targets:
        if strategy in t.get("strategies", []):
            return t
        if asset_class in t.get("asset_classes", []):
            return t
    return {"bucket": "其他", "target_pct": 0, "tolerance_pct": 5}


def compute_allocation(positions, targets, total_value):
    """计算各配置桶的实际占比和偏离度。"""
    bucket_values = {}
    for pos in positions:
        bucket = pos.get("allocation_bucket", "其他")
        value_cny = pos.get("value_cny") or 0
        bucket_values[bucket] = bucket_values.get(bucket, 0) + value_cny

    results = []
    for t in targets:
        name = t["bucket"]
        target_pct = t.get("target_pct", 0)
        tolerance = t.get("tolerance_pct", 5)
        actual_pct = safe_div(bucket_values.get(name, 0), total_value) * 100 if total_value else 0
        deviation = (actual_pct or 0) - target_pct
        threshold = t.get("rebalance_threshold_pct", tolerance * 2)
        results.append({
            "name": name,
            "value": bucket_values.get(name, 0),
            "actual_pct": round(actual_pct, 1) if actual_pct is not None else 0,
            "target_pct": target_pct,
            "deviation_pct": round(deviation, 1),
            "tolerance_pct": tolerance,
            "rebalance_needed": abs(deviation) > threshold,
            "suggested_action": suggest_action(deviation, target_pct, tolerance, t.get("action")),
        })
    return results


def suggest_action(deviation, target_pct, tolerance, override_rule):
    if override_rule:
        return override_rule
    if target_pct == 0:
        return "仅观察，不进入核心配置"
    if abs(deviation) <= tolerance:
        return "达标，维持"
    if deviation > 0:
        return f"超配 {abs(deviation):.0f}%，考虑暂缓新增"
    return f"低配 {abs(deviation):.0f}%，关注机会分批建仓"


# ── 信号关联逻辑 ──────────────────────────────────────────

def find_signal_for_position(pos, all_signals):
    ticker = str(pos.get("ticker") or "").strip().upper()
    code = str(pos.get("code") or "").strip()
    matching = []
    for sig in all_signals:
        sig_ticker = str(sig.get("ticker") or "").strip().upper()
        if sig_ticker == ticker or sig_ticker == code or (code and sig_ticker == code):
            matching.append(sig)
    return matching


def build_signal_implications(positions, all_signals):
    """为每个信号生成与持仓关联的结论。"""
    implications = []
    held_tickers = {str(p.get("ticker") or "").strip().upper() for p in positions}
    held_codes = {str(p.get("code") or "").strip() for p in positions}

    for sig in all_signals:
        sig_t = str(sig.get("ticker") or "").strip().upper()
        matched = sig_t in held_tickers or sig_t in held_codes
        pos = next((p for p in positions if str(p.get("ticker") or "").strip().upper() == sig_t or str(p.get("code") or "").strip() == sig_t), None)

        if matched and pos:
            pnl = pos.get("unrealized_pnl_pct")
            pnl_text = f"浮盈 {signed_pct(pnl)}" if pnl is not None else "持有中"
            implications.append({
                "source": sig.get("source"),
                "ticker": sig_t,
                "name": sig.get("name"),
                "signal": sig.get("signal"),
                "held": True,
                "allocation_bucket": pos.get("allocation_bucket", ""),
                "pnl_pct": pnl,
                "implication": f"你持有 {pos.get('shares', '?')} 股 ({pnl_text})，配置桶「{pos.get('allocation_bucket', '')}」",
            })
        elif matched:
            implications.append({
                "source": sig.get("source"),
                "ticker": sig_t,
                "name": sig.get("name"),
                "signal": sig.get("signal"),
                "held": True,
                "implication": "你持有该标的",
            })
        else:
            implications.append({
                "source": sig.get("source"),
                "ticker": sig_t,
                "name": sig.get("name"),
                "signal": sig.get("signal"),
                "held": False,
                "implication": "你不持有该标的，持续观察",
            })
    return implications


# ── 主报告生成 ──────────────────────────────────────────

def collect_report(portfolio_path, allocation_path, trades_path, index_snapshot, short_snapshot, fx_rate_override=None):
    items, capital_base, currency, fx_rate = load_portfolio(portfolio_path)
    if fx_rate_override:
        fx_rate = fx_rate_override
    targets, _base_cur = load_allocation(allocation_path)
    trades = load_trades(trades_path)
    all_signals = load_signals(index_snapshot, short_snapshot)

    if not items:
        return {"asof": dt.datetime.now().strftime("%Y-%m-%d %H:%M"), "positions": [], "total_value_cny": 0, "total_cost_cny": 0}

    # 并行获取行情
    positions = []
    gaps = []
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
        futures = {pool.submit(fetch_price, item): item for item in items}
        for future in as_completed(futures):
            item = futures[future]
            try:
                quote = future.result()
            except Exception as exc:
                quote = {"current_price": None, "error": str(exc), "source": "unavailable"}
                gaps.append(f"{item.get('ticker')}/{item.get('name')}: {exc}")

            ticker = str(item.get("ticker") or item.get("code") or "").strip()
            market = str(item.get("market") or "").strip().upper()
            shares = item.get("shares") or 0
            avg_cost = item.get("avg_cost")
            cost_currency = item.get("cost_currency", "CNY")
            current_price = quote.get("current_price")

            # 计算持仓市值 (CNY)
            if current_price is not None and shares and avg_cost:
                if cost_currency == "USD":
                    value_cny = current_price * shares * fx_rate
                    cost_cny = avg_cost * shares * fx_rate
                else:
                    value_cny = current_price * shares
                    cost_cny = avg_cost * shares
                unrealized_pnl = value_cny - cost_cny
                unrealized_pnl_pct = pct_change(value_cny, cost_cny)
            else:
                value_cny = None
                cost_cny = avg_cost * shares if avg_cost and shares else 0
                unrealized_pnl = None
                unrealized_pnl_pct = None

            # 匹配配置桶
            bucket = match_bucket(item, targets)

            pos = {
                "ticker": ticker,
                "name": item.get("name") or ticker,
                "market": market,
                "asset_class": item.get("asset_class", ""),
                "strategy": item.get("strategy", ""),
                "direction": item.get("direction", "long"),
                "shares": shares,
                "avg_cost": avg_cost,
                "cost_currency": cost_currency,
                "entry_date": item.get("entry_date", ""),
                "current_price": current_price,
                "change_1d_pct": quote.get("change_1d_pct"),
                "value_cny": round(value_cny, 2) if value_cny is not None else None,
                "cost_cny": round(cost_cny, 2) if cost_cny is not None else None,
                "unrealized_pnl_cny": round(unrealized_pnl, 2) if unrealized_pnl is not None else None,
                "unrealized_pnl_pct": round(unrealized_pnl_pct, 2) if unrealized_pnl_pct is not None else None,
                "allocation_bucket": bucket.get("bucket", "其他"),
                "data_status": "live" if current_price is not None else "unavailable",
                "source": quote.get("source", "unavailable"),
                "notes": item.get("notes", ""),
            }

            # 查找该持仓对应的信号
            matched_signals = find_signal_for_position(item, all_signals)
            if matched_signals:
                pos["linked_signals"] = matched_signals

            positions.append(pos)

    # 计算总资产
    valid_values = [p.get("value_cny") for p in positions if p.get("value_cny") is not None]
    total_value = sum(valid_values) if valid_values else 0
    total_cost = sum(p.get("cost_cny") or 0 for p in positions)

    # 算占比
    for pos in positions:
        if pos.get("value_cny") is not None and total_value > 0:
            pos["pct_of_portfolio"] = round(pos["value_cny"] / total_value * 100, 1)
        else:
            pos["pct_of_portfolio"] = 0

    # 计算配置
    allocation = compute_allocation(positions, targets, total_value)

    # 信号关联
    sign_to_act = build_signal_implications(positions, all_signals)

    # 汇总
    total_pnl = total_value - total_cost
    total_pnl_pct = pct_change(total_value, total_cost) if total_cost > 0 else None
    realized_pnl = sum(t.get("value_cny", 0) - (t.get("shares", 0) * t.get("price", 0)) for t in trades if t.get("action") == "sell")

    valid_pnl = [p for p in positions if p.get("unrealized_pnl_pct") is not None]
    best = max(valid_pnl, key=lambda p: p["unrealized_pnl_pct"]) if valid_pnl else None
    worst = min(valid_pnl, key=lambda p: p["unrealized_pnl_pct"]) if valid_pnl else None

    # 收益汇总（按策略分组）
    strategy_summary = {}
    for pos in positions:
        s = pos.get("strategy", "其他")
        if s not in strategy_summary:
            strategy_summary[s] = {"strategy": s, "value_cny": 0, "cost_cny": 0, "count": 0}
        if pos.get("value_cny"):
            strategy_summary[s]["value_cny"] += pos.get("value_cny", 0)
        if pos.get("cost_cny"):
            strategy_summary[s]["cost_cny"] += pos.get("cost_cny", 0)
        strategy_summary[s]["count"] += 1
    for s in strategy_summary.values():
        s["return_pct"] = round(pct_change(s["value_cny"], s["cost_cny"]), 2) if s["cost_cny"] > 0 else 0

    return {
        "asof": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "generated_by": "scripts/portfolio_report.py v1.0",
        "fx_rate_usdcny": fx_rate,
        "summary": {
            "total_value_cny": round(total_value, 2),
            "total_cost_cny": round(total_cost, 2),
            "total_pnl_cny": round(total_pnl, 2),
            "total_pnl_pct": round(total_pnl_pct, 2) if total_pnl_pct is not None else 0,
            "unrealized_pnl_cny": round(sum(p.get("unrealized_pnl_cny") or 0 for p in positions), 2),
            "realized_pnl_cny": round(realized_pnl, 2),
            "position_count": len(positions),
            "live_positions": sum(1 for p in positions if p.get("data_status") == "live"),
            "stale_positions": sum(1 for p in positions if p.get("data_status") != "live"),
            "best_performer": {"ticker": best["ticker"], "return_pct": best["unrealized_pnl_pct"]} if best else None,
            "worst_performer": {"ticker": worst["ticker"], "return_pct": worst["unrealized_pnl_pct"]} if worst else None,
        },
        "positions": sorted(positions, key=lambda p: -(p.get("value_cny") or 0)),
        "allocation": sorted(allocation, key=lambda a: -(a.get("actual_pct") or 0)),
        "strategy_summary": sorted(strategy_summary.values(), key=lambda s: -(s.get("value_cny") or 0)),
        "signals_to_actions": [s for s in sign_to_act if s.get("held")][:20],
        "trades_recent": sorted(trades, key=lambda t: t.get("date", ""), reverse=True)[:20],
        "data_gaps": gaps,
    }


# ── CLI / 测试 ──────────────────────────────────────────

def selftest():
    """离线自测：验证核心计算逻辑。"""
    checks = [
        ("secid sh", secid_for("601138") == "1.601138"),
        ("secid sz", secid_for("000636") == "0.000636"),
        ("tencent sh", tencent_symbol_for("512890") == "sh512890"),
        ("tencent sz", tencent_symbol_for("159915") == "sz159915"),
        ("yahoo .SH→.SS", yahoo_symbol("512890.SH") == "512890.SS"),
        ("pct_change 100→110", abs(pct_change(110, 100) - 10) < 0.01),
        ("safe_div 10/5", safe_div(10, 5) == 2.0),
        ("safe_div 10/0", safe_div(10, 0) is None),
        ("match_bucket 核心", match_bucket({"strategy": "core_allocation"}, [{"strategies": ["core_allocation"], "bucket": "美股核心"}]).get("bucket") == "美股核心"),
        ("suggest_action 达标", "达标" in suggest_action(2, 50, 5, None)),
        ("suggest_action 超配", "超配" in suggest_action(8, 50, 5, None)),
    ]
    ok = True
    for name, passed in checks:
        print(f"[{'PASS' if passed else 'FAIL'}] {name}")
        ok = ok and passed
    return ok


def main():
    parser = argparse.ArgumentParser(description="生成个人资产管理报告")
    parser.add_argument("--portfolio", default=PORTFOLIO_FILE, help="持仓JSON路径")
    parser.add_argument("--allocation", default=ALLOCATION_FILE, help="目标配置JSON路径")
    parser.add_argument("--trades", default=TRADES_FILE, help="交易日志JSON路径")
    parser.add_argument("--index-snapshot", default=INDEX_DECISION_SNAPSHOT, help="index-decision 快照路径")
    parser.add_argument("--short-snapshot", default=SHORT_FLOW_SNAPSHOT, help="short-flow 快照路径")
    parser.add_argument("--output", default=OUTPUT_FILE, help="输出JSON路径")
    parser.add_argument("--fx-rate", type=float, default=None, help="USD/CNY汇率（覆盖portfolio.json中的值）")
    parser.add_argument("--json", action="store_true", help="打印JSON到stdout")
    parser.add_argument("--selftest", action="store_true", help="运行离线自测")
    args = parser.parse_args()

    if args.selftest:
        return 0 if selftest() else 1

    data = collect_report(
        args.portfolio, args.allocation, args.trades,
        args.index_snapshot, args.short_snapshot,
        fx_rate_override=args.fx_rate,
    )

    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    if args.json or not args.output:
        print(json.dumps(data, ensure_ascii=False, indent=2))
    else:
        print(f"Wrote portfolio report: {args.output}")
        summary = data.get("summary", {})
        print(f"  总市值: ¥{summary.get('total_value_cny', 0):,.0f}  |  总盈亏: {signed_pct(summary.get('total_pnl_pct', 0))}  |  持仓: {summary.get('live_positions', 0)}/{summary.get('position_count', 0)} 个有效")
    return 0


if __name__ == "__main__":
    sys.exit(main())
