#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""五指数决策看板：只抓数据、计算信号，不执行交易。"""

import argparse
import datetime as dt
import html
import json
import os
import re
import sys
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed


CSI_BASE = "https://www.csindex.com.cn/csindex-home"
HERE = os.path.dirname(os.path.abspath(__file__))
CACHE_FILE = os.path.join(HERE, "index_decision_dashboard_cache.json")
HISTORY_FILE = os.path.join(HERE, "index_decision_dashboard_history.json")
WATCHLIST_V1_FILE = os.path.join(HERE, "watchlist_v1.json")
DASHBOARD_LATEST_FILE = os.path.join(HERE, "dashboard_latest.json")
CSI_INDICES = {
    "000300": {"name": "沪深300", "kind": "cn_broad", "product": "-"},
    "000905": {"name": "中证500", "kind": "cn_broad", "product": "-"},
    "H30269": {"name": "中证红利低波动", "kind": "dividend", "product": "512890/563020"},
}
US_INDICES = {
    "^GSPC": {"name": "标普500", "kind": "us_broad", "cnbc": ".SPX", "wsj": "S&P 500 Index", "product": "标普QDII/VOO"},
    "^NDX": {"name": "纳斯达克100", "kind": "nasdaq", "cnbc": ".NDX", "wsj": "NASDAQ 100 Index", "product": "纳指QDII/QQQ"},
}
STOOQ_SYMBOLS = {
    "^GSPC": ("^spx", "spy.us"),
    "^NDX": ("^ndq", "qqq.us"),
}
CNBC_PAGE_SYMBOLS = {
    ".SPX": "SPX",
    ".NDX": "NDX",
}
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) IndexDecisionDashboard/1.0"
TIMEOUT = 12


def get_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT, "Accept": "application/json,*/*"})
    with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
        return json.loads(response.read().decode("utf-8"))


def get_text(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT, "Accept": "text/html,*/*"})
    with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
        return response.read().decode("utf-8", errors="replace")


def to_float(value):
    try:
        return float(str(value).replace(",", "").replace("%", ""))
    except (TypeError, ValueError):
        return None


def pct(value, digits=1):
    return "N/A" if value is None else f"{value:.{digits}f}%"


def num(value, digits=2):
    return "N/A" if value is None else f"{value:.{digits}f}"


def signed_num(value, digits=2):
    return "N/A" if value is None else f"{value:+.{digits}f}"


def signed_pct(value, digits=1):
    return "N/A" if value is None else f"{value:+.{digits}f}%"


def signed_pp(value, digits=2):
    return "N/A" if value is None else f"{value:+.{digits}f}pct"


def with_delta(text, delta_text):
    return text if delta_text == "N/A" else f"{text} ({delta_text})"


def drawdown(current, high):
    if current is None or high in (None, 0):
        return None
    return (current / high - 1.0) * 100.0


def normalize_date(value):
    text = str(value or "N/A")
    if re.fullmatch(r"\d{8}", text):
        return f"{text[:4]}-{text[4:6]}-{text[6:8]}"
    return text


def period_return(closes, periods):
    if not closes or len(closes) <= periods or closes[-periods - 1] == 0:
        return None
    return (closes[-1] / closes[-periods - 1] - 1.0) * 100.0


def one_day_change(rows):
    if len(rows) < 2 or rows[-2][1] in (None, 0):
        return None
    return (rows[-1][1] / rows[-2][1] - 1.0) * 100.0


def previous_drawdown(rows, window=260):
    if len(rows) < 2:
        return None
    prev_rows = rows[:-1]
    sample = prev_rows[-window:]
    high = max(row[2] for row in sample)
    return drawdown(prev_rows[-1][1], high)


def build_history_result(rows, source):
    if not rows:
        raise RuntimeError(f"{source}日线为空")
    rows.sort(key=lambda row: row[0])
    current = rows[-1][1]
    closes = [row[1] for row in rows]
    high_52w = max(row[2] for row in rows[-260:])
    latest_date = rows[-1][0]
    current_year = latest_date.year
    ytd_base = next((row[1] for row in rows if row[0].year == current_year), None)
    return {
        "current": current,
        "high_52w": high_52w,
        "drawdown_52w": drawdown(current, high_52w),
        "change_1d_pct": one_day_change(rows),
        "drawdown_1d_delta": None if previous_drawdown(rows) is None else drawdown(current, high_52w) - previous_drawdown(rows),
        "return_1m": period_return(closes, 21),
        "return_3m": period_return(closes, 63),
        "return_ytd": None if ytd_base in (None, 0) else (current / ytd_base - 1.0) * 100.0,
        "return_1y": period_return(closes, 252),
        "date": latest_date.isoformat(),
        "source_price": source,
    }


def drawdown_band(dd):
    if dd is None:
        return None
    for level in (-25, -20, -15, -10, -5):
        if dd <= level:
            return level
    return 0


def percentile_label(value):
    if value is None:
        return "未知"
    if value <= 0.2:
        return "低位"
    if value <= 0.5:
        return "中低"
    if value <= 0.8:
        return "中高"
    return "高位"


def fetch_csi_history(code, start_date, end_date):
    query = urllib.parse.urlencode({
        "indexCode": code,
        "startDate": start_date.strftime("%Y%m%d"),
        "endDate": end_date.strftime("%Y%m%d"),
    })
    payload = get_json(f"{CSI_BASE}/perf/index-perf?{query}")
    rows = payload.get("data") or []
    rows = [row for row in rows if to_float(row.get("close")) is not None]
    rows.sort(key=lambda row: str(row.get("tradeDate", "")))
    if not rows:
        raise RuntimeError(f"中证日线为空: {code}")
    latest = rows[-1]
    high_52w = max(to_float(row.get("high")) or to_float(row.get("close")) for row in rows[-260:])
    parsed_rows = []
    for row in rows:
        close = to_float(row.get("close"))
        high = to_float(row.get("high")) or close
        date_text = normalize_date(row.get("tradeDate"))
        if close is not None:
            parsed_rows.append((dt.date.fromisoformat(date_text), close, high))
    return {
        "current": to_float(latest.get("close")),
        "high_52w": high_52w,
        "drawdown_52w": drawdown(to_float(latest.get("close")), high_52w),
        "change_1d_pct": one_day_change(parsed_rows),
        "drawdown_1d_delta": None if previous_drawdown(parsed_rows) is None else drawdown(to_float(latest.get("close")), high_52w) - previous_drawdown(parsed_rows),
        "pe_ttm": to_float(latest.get("peg")),
        "date": normalize_date(latest.get("tradeDate")),
        "source_price": "CSI:index-perf",
    }


def fetch_csi_performance(code):
    payload = get_json(f"{CSI_BASE}/perf/get-index-yield-item/{code}")
    data = payload.get("data") or {}
    return {
        "return_1m": to_float(data.get("oneMonth")),
        "return_3m": to_float(data.get("threeMonth")),
        "return_ytd": to_float(data.get("thisYear")),
        "return_1y": to_float(data.get("oneYear")),
        "performance_date": data.get("endDate"),
        "source_performance": "CSI:get-index-yield-item",
    }


def fetch_csi_dashboard_valuations():
    payload = get_json(f"{CSI_BASE}/data-service/indexValuation")
    data = payload.get("data") or {}
    rows = data.get("indexValuations") or []
    result = {}
    for row in rows:
        result[row.get("indexName")] = {
            "pe_static": to_float(row.get("pe")),
            "pe_ttm": to_float(row.get("peg")),
            "pb": to_float(row.get("pb")),
            "dividend_yield": to_float(row.get("dp")),
            "valuation_date": str(row.get("tradeDate") or data.get("tradeDate") or "N/A"),
            "source_valuation": "CSI:indexValuation",
        }
    return result


def fetch_danjuan_valuations():
    payload = get_json("https://danjuanfunds.com/djapi/index_eva/dj")
    wanted = {"SH000300": "000300", "SH000905": "000905", "CSIH30269": "H30269"}
    result = {}
    for row in (payload.get("data") or {}).get("items", []):
        code = wanted.get(row.get("index_code"))
        if not code:
            continue
        result[code] = {
            "pe_ttm": to_float(row.get("pe")),
            "pb": to_float(row.get("pb")),
            "dividend_yield": None if to_float(row.get("yeild")) is None else to_float(row.get("yeild")) * 100,
            "roe": None if to_float(row.get("roe")) is None else to_float(row.get("roe")) * 100,
            "pe_percentile": to_float(row.get("pe_percentile")),
            "pb_percentile": to_float(row.get("pb_percentile")),
            "valuation_date": str(row.get("date") or "N/A"),
            "source_valuation_extra": "Danjuan:index_eva",
        }
    return result


def fetch_yahoo_history(ticker):
    encoded = urllib.parse.quote(ticker)
    last_error = None
    for host in ("query1.finance.yahoo.com", "query2.finance.yahoo.com"):
        try:
            payload = get_json(f"https://{host}/v8/finance/chart/{encoded}?range=400d&interval=1d")
            result = payload["chart"]["result"][0]
            timestamps = result.get("timestamp") or []
            quote = result["indicators"]["quote"][0]
            rows = []
            for stamp, close, high in zip(timestamps, quote.get("close") or [], quote.get("high") or []):
                if close is not None:
                    day = dt.datetime.fromtimestamp(stamp, dt.UTC).date()
                    rows.append((day, float(close), float(high) if high is not None else float(close)))
            return build_history_result(rows, f"Yahoo:{host}")
        except Exception as exc:
            last_error = exc
    return fetch_stooq_history(ticker, last_error)


def yahoo_symbol(ticker):
    """Convert local watchlist tickers to Yahoo symbols."""
    if ticker == "BRK.B":
        return "BRK-B"
    if ticker.endswith(".SH"):
        return ticker[:-3] + ".SS"
    return ticker


def fetch_stooq_history(ticker, yahoo_error=None):
    symbols = STOOQ_SYMBOLS.get(ticker, ())
    last_error = yahoo_error
    for symbol in symbols:
        try:
            url = f"https://stooq.com/q/d/l/?s={urllib.parse.quote(symbol)}&i=d"
            text = get_text(url)
            rows = []
            for line in text.splitlines()[1:]:
                parts = line.split(",")
                if len(parts) < 5:
                    continue
                day = dt.date.fromisoformat(parts[0])
                high = to_float(parts[2])
                close = to_float(parts[4])
                if close is not None:
                    rows.append((day, close, high if high is not None else close))
            label = f"Stooq:{symbol}"
            if symbol.endswith(".us"):
                label += "代理"
            return build_history_result(rows, label)
        except Exception as exc:
            last_error = exc
    raise RuntimeError(f"Yahoo/Stooq历史均失败: {last_error}")


def friendly_fetch_error(exc):
    text = str(exc)
    if "429" in text or "Too Many Requests" in text:
        return "行情源临时限流，等待下次刷新"
    if "Invalid isoformat" in text or "(async()" in text:
        return "行情源返回内容异常，等待下次刷新"
    if "timed out" in text.lower() or "timeout" in text.lower():
        return "行情源响应超时，等待下次刷新"
    return "行情数据暂时不可用，等待下次刷新"


def fetch_cnbc_quote(symbol):
    encoded = urllib.parse.quote(symbol, safe="")
    url = (
        "https://quote.cnbc.com/quote-html-webservice/quote.htm"
        f"?symbols={encoded}&requestMethod=quick&noform=1&partnerId=2&fund=1&exthrs=1&output=json"
    )
    payload = get_json(url)
    row = payload["QuickQuoteResult"]["QuickQuote"][0]
    fundamentals = row.get("FundamentalData") or {}
    current = to_float(row.get("last"))
    high_52w = to_float(fundamentals.get("yrhiprice"))
    return {
        "current": current,
        "high_52w": high_52w,
        "drawdown_52w": drawdown(current, high_52w),
        "date": row.get("last_time") or "N/A",
        "source_price": "CNBC",
    }


def parse_cnbc_page_quote(page, code):
    text = re.sub(r"<[^>]+>", " ", html.unescape(page))
    result = {"current": None, "high_52w": None}

    for match in re.finditer(r"<script[^>]+type=[\"']application/ld\+json[\"'][^>]*>(.*?)</script>", page, flags=re.S):
        block = html.unescape(match.group(1))
        ticker_variants = {code, f".{code}"}
        ticker_pattern = "|".join(re.escape(x) for x in ticker_variants)
        if not re.search(rf'"tickerSymbol"\s*:\s*"({ticker_pattern})"', block):
            continue
        price_match = re.search(r'"price"\s*:\s*"?([0-9][0-9,.]*)"?', block)
        if price_match:
            result["current"] = to_float(price_match.group(1))
            break

    if result["current"] is None:
        for pattern in (
            r'class="QuoteStrip-lastPrice"[^>]*>\s*([0-9][0-9,.]*)',
            r'Last\s*\|\s*[^0-9]*([0-9][0-9,.]*)',
        ):
            match = re.search(pattern, page)
            if match:
                result["current"] = to_float(match.group(1))
                break

    range_match = re.search(r"52\s*week\s*range\s*([0-9][0-9,.]*)\s*[-–]\s*([0-9][0-9,.]*)", text, flags=re.I)
    if range_match:
        result["high_52w"] = to_float(range_match.group(2))

    return result


def fetch_cnbc_page_quote(symbol):
    page_symbol = CNBC_PAGE_SYMBOLS.get(symbol, symbol.lstrip("."))
    url = f"https://www.cnbc.com/quotes/{urllib.parse.quote(page_symbol, safe='')}"
    parsed = parse_cnbc_page_quote(get_text(url), page_symbol)
    current = parsed.get("current")
    high_52w = parsed.get("high_52w")
    if current is None:
        raise RuntimeError("CNBC页面未解析到当前价")
    return {
        "current": current,
        "high_52w": high_52w,
        "drawdown_52w": drawdown(current, high_52w),
        "date": dt.date.today().isoformat(),
        "source_price": "CNBC:page-crawler",
    }


def fetch_cnbc_quote_with_crawler(symbol):
    try:
        return fetch_cnbc_quote(symbol)
    except Exception as api_exc:
        try:
            return fetch_cnbc_page_quote(symbol)
        except Exception as page_exc:
            raise RuntimeError(f"CNBC API失败: {api_exc}; 页面爬虫失败: {page_exc}")


def parse_wsj_valuations(page):
    page = html.unescape(page)
    result = {}
    for ticker, cfg in US_INDICES.items():
        marker = f'"name":"{cfg["wsj"]}"'
        start = page.find(marker)
        if start < 0:
            marker = cfg["wsj"]
            start = page.find(marker)
        if start < 0:
            continue
        segment = page[start:start + 5000]
        def field(name):
            match = re.search(rf'"{re.escape(name)}"\s*:\s*"?([0-9][0-9,.]*)"?', segment)
            return to_float(match.group(1)) if match else None
        date_match = re.search(r'"formattedTradeDate"\s*:\s*"([0-9/]+)"', segment)
        result[ticker] = {
            "pe_ttm": field("priceEarningsRatio"),
            "pe_forward": field("priceEarningsRatioEstimate"),
            "pe_52w_ago": field("priceEarningsRatio52WeekAgo"),
            "dividend_yield": field("yield"),
            "valuation_date": date_match.group(1) if date_match else dt.date.today().isoformat(),
            "source_valuation": "WSJ:P/E & Yields",
        }
    return result


def fetch_wsj_valuations():
    return parse_wsj_valuations(get_text("https://www.wsj.com/market-data/stocks/peyields"))


def merge_non_null(target, source, overwrite=True):
    for key, value in source.items():
        if value is not None and (overwrite or target.get(key) is None):
            target[key] = value


def load_cache():
    try:
        with open(CACHE_FILE, encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return {}


def load_history():
    try:
        with open(HISTORY_FILE, encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return {}


def load_watchlist(path):
    try:
        with open(path, encoding="utf-8") as handle:
            data = json.load(handle)
        if isinstance(data, list):
            return data
        return data.get("items", [])
    except Exception:
        return []


def snapshot_rows(data):
    keep = ("current", "drawdown_52w", "pe_ttm", "pe_forward", "pb", "dividend_yield", "signal")
    return {
        row["code"]: {key: row.get(key) for key in keep if row.get(key) is not None}
        for row in data.get("indices", [])
    }


def find_previous_snapshot(history, today_key):
    prior_dates = sorted(key for key in history if key < today_key)
    if not prior_dates:
        return None, {}
    key = prior_dates[-1]
    return key, history.get(key, {})


def annotate_snapshot_changes(data):
    today_key = dt.date.today().isoformat()
    history = load_history()
    prev_key, prev = find_previous_snapshot(history, today_key)
    for row in data.get("indices", []):
        old = prev.get(row["code"], {})
        row["snapshot_compare_date"] = prev_key
        for key in ("pe_ttm", "pe_forward", "pb", "dividend_yield"):
            cur = row.get(key)
            old_value = old.get(key)
            row[f"{key}_snapshot_delta"] = None if cur is None or old_value is None else cur - old_value
        old_signal = old.get("signal")
        row["signal_snapshot_delta"] = None if old_signal is None else ("无变化" if old_signal == row.get("signal") else f"由「{old_signal}」变为当前")
    history[today_key] = snapshot_rows(data)
    try:
        with open(HISTORY_FILE, "w", encoding="utf-8") as handle:
            json.dump(history, handle, ensure_ascii=False, indent=2)
    except Exception:
        pass


def save_cache(rows):
    cached = {}
    keys = ("pe_ttm", "pe_forward", "pe_52w_ago", "dividend_yield", "valuation_date", "source_valuation")
    for code, row in rows.items():
        source = str(row.get("source_valuation") or "")
        if source.startswith("Cache:"):
            continue
        values = {key: row.get(key) for key in keys if row.get(key) is not None}
        if values:
            values["cached_at"] = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
            cached[code] = values
    if not cached:
        return
    try:
        old = load_cache()
        old.update(cached)
        with open(CACHE_FILE, "w", encoding="utf-8") as handle:
            json.dump(old, handle, ensure_ascii=False, indent=2)
    except Exception:
        pass


def fill_cached_us_valuations(rows, gaps):
    cache = load_cache()
    for ticker in US_INDICES:
        row = rows.setdefault(ticker, {})
        if row.get("pe_ttm") is not None or row.get("dividend_yield") is not None:
            continue
        cached = cache.get(ticker) or {}
        usable = {key: cached.get(key) for key in ("pe_ttm", "pe_forward", "pe_52w_ago", "dividend_yield", "valuation_date") if cached.get(key) is not None}
        if not usable:
            continue
        merge_non_null(row, usable, overwrite=False)
        row["source_valuation"] = f"Cache:{cached.get('source_valuation', 'valuation')}@{cached.get('cached_at', 'N/A')}"
        gaps.append(f"{ticker}/valuation: WSJ不可用，使用缓存估值({cached.get('valuation_date', 'N/A')})")


def dividend_signal(row):
    pe = row.get("pe_ttm")
    dy = row.get("dividend_yield")
    pe_pct = row.get("pe_percentile")
    if pe is None or dy is None:
        return "数据不足：至少需要PE和股息率"
    if dy < 4.5 or pe > 13:
        return "暂停新增：股息率<4.5%或PE>13"
    if dy > 6 or pe < 11:
        if dy < 6 and pe_pct is not None and pe_pct > 0.7:
            return "可买但不加速：PE低，股息率/历史分位未到极便宜"
        return "允许买入/加速：股息率>6%或PE<11"
    return "正常小额：股息率4.5%-6%、PE 11-13"


def broad_signal(row, kind):
    dd = row.get("drawdown_52w")
    band = drawdown_band(dd)
    pe_pct = row.get("pe_percentile")
    fwd = row.get("pe_forward")
    notes = []
    if kind == "nasdaq" and fwd is not None and fwd > 35:
        notes.append("前瞻PE>35，暂停纳指新增")
    if band in (None, 0):
        notes.append("未到-5%回撤档，维持基础节奏")
    elif band == -5:
        notes.append("进入-5%观察档，可检查定投×1.5")
    else:
        notes.append(f"进入{band}%回撤档，按宽基金字塔复核")
    if pe_pct is not None:
        if pe_pct > 0.8:
            notes.append("PE历史分位高，不因回撤自动加速")
        elif pe_pct <= 0.3:
            notes.append("PE历史分位较低，估值与回撤更匹配")
    pe_now = row.get("pe_ttm")
    pe_old = row.get("pe_52w_ago")
    if pe_now is not None and pe_old not in (None, 0) and pe_now / pe_old > 1.1:
        notes.append("PE较一年前扩张>10%")
    return "；".join(notes)


def watchlist_signal(row):
    dd = row.get("drawdown_52w")
    change = row.get("change_1d_pct")
    notes = []
    if dd is None:
        notes.append("数据不足")
    elif dd <= -20:
        notes.append("深回撤观察")
    elif dd <= -10:
        notes.append("回撤观察")
    elif dd >= -3:
        notes.append("接近52周高位")
    else:
        notes.append("正常观察")
    if change is not None and abs(change) >= 5:
        notes.append(f"单日波动{signed_pct(change, 1)}")
    return "；".join(notes)


def build_watchlist_alerts(row):
    alerts = []
    ticker = row.get("ticker")
    name = row.get("name") or ticker
    dd = row.get("drawdown_52w")
    change = row.get("change_1d_pct")
    ret_1m = row.get("return_1m")
    priority = row.get("priority")
    dd_limit = row.get("alert_drawdown_pct")
    change_limit = row.get("alert_1d_abs_pct")
    ret_1m_limit = row.get("alert_1m_pct")

    if row.get("current") is None:
        alerts.append({
            "ticker": ticker,
            "name": name,
            "level": "data",
            "notify": False,
            "message": "行情数据缺失，今天不能据此判断",
        })
    if dd is not None and dd_limit is not None and dd <= dd_limit:
        deep = dd <= dd_limit * 1.5
        alerts.append({
            "ticker": ticker,
            "name": name,
            "level": "deep" if deep else "watch",
            "notify": deep and priority == "core",
            "message": f"52周回撤 {dd:.1f}% 触发阈值 {dd_limit:.1f}%",
        })
    if change is not None and change_limit is not None and abs(change) >= change_limit:
        alerts.append({
            "ticker": ticker,
            "name": name,
            "level": "move",
            "notify": priority in ("core", "high"),
            "message": f"单日波动 {change:+.1f}% 超过阈值 {change_limit:.1f}%",
        })
    if ret_1m is not None and ret_1m_limit is not None and ret_1m <= ret_1m_limit:
        alerts.append({
            "ticker": ticker,
            "name": name,
            "level": "trend",
            "notify": False,
            "message": f"近1月表现 {ret_1m:.1f}% 低于阈值 {ret_1m_limit:.1f}%",
        })
    return alerts


def collect_watchlist(path):
    items = load_watchlist(path)
    rows = []
    gaps = []
    if not items:
        return rows, ["watchlist: 未读取到观察池"]

    with ThreadPoolExecutor(max_workers=8) as pool:
        futures = {}
        for item in items:
            ticker = item.get("ticker")
            if not ticker:
                continue
            futures[pool.submit(fetch_yahoo_history, yahoo_symbol(ticker))] = item
        for future in as_completed(futures):
            item = futures[future]
            ticker = item.get("ticker")
            row = {key: item.get(key) for key in ("market", "ticker", "name", "group", "reason", "priority")}
            try:
                for key in ("alert_drawdown_pct", "alert_1d_abs_pct", "alert_1m_pct"):
                    row[key] = item.get(key)
                merge_non_null(row, future.result())
                row["signal"] = watchlist_signal(row)
                row["alerts"] = build_watchlist_alerts(row)
                row["has_alert"] = any(alert.get("level") != "data" for alert in row["alerts"])
            except Exception as exc:
                row["signal"] = "数据不足"
                row["alerts"] = [{
                    "ticker": ticker,
                    "name": row.get("name") or ticker,
                    "level": "data",
                    "notify": False,
                    "message": friendly_fetch_error(exc),
                }]
                row["has_alert"] = False
                gaps.append(f"{ticker}/watchlist: {exc}")
            rows.append(row)

    priority_order = {"core": 0, "high": 1, "normal": 2}
    rows.sort(key=lambda row: (priority_order.get(row.get("priority"), 9), row.get("group") or "", row.get("ticker") or ""))
    return rows, gaps


def collect_dashboard(watchlist_path=None):
    today = dt.date.today()
    start = today - dt.timedelta(days=370)
    rows = {}
    gaps = []

    with ThreadPoolExecutor(max_workers=5) as pool:
        futures = {}
        for code, cfg in CSI_INDICES.items():
            futures[pool.submit(fetch_csi_history, code, start, today)] = (code, "history")
            futures[pool.submit(fetch_csi_performance, code)] = (code, "performance")
        for ticker, cfg in US_INDICES.items():
            futures[pool.submit(fetch_yahoo_history, ticker)] = (ticker, "history")
        for future in as_completed(futures):
            code, part = futures[future]
            rows.setdefault(code, {})
            try:
                merge_non_null(rows[code], future.result())
            except Exception as exc:
                gaps.append(f"{code}/{part}: {exc}")

    for ticker, cfg in US_INDICES.items():
        if rows.get(ticker, {}).get("current") is None:
            try:
                merge_non_null(rows.setdefault(ticker, {}), fetch_cnbc_quote_with_crawler(cfg["cnbc"]))
            except Exception as exc:
                gaps.append(f"{ticker}/CNBC crawler: {exc}")

    try:
        official = fetch_csi_dashboard_valuations()
        name_to_code = {cfg["name"]: code for code, cfg in CSI_INDICES.items()}
        for name, values in official.items():
            code = name_to_code.get(name)
            if code:
                merge_non_null(rows.setdefault(code, {}), values)
    except Exception as exc:
        gaps.append(f"CSI/valuation: {exc}")

    try:
        extras = fetch_danjuan_valuations()
        for code, values in extras.items():
            merge_non_null(rows.setdefault(code, {}), values, overwrite=False)
            for key in ("pe_percentile", "pb_percentile", "roe", "source_valuation_extra"):
                if values.get(key) is not None:
                    rows[code][key] = values[key]
            if code == "H30269":
                for key in ("pb", "dividend_yield", "valuation_date", "source_valuation_extra"):
                    if values.get(key) is not None:
                        rows[code][key] = values[key]
    except Exception as exc:
        gaps.append(f"Danjuan/valuation: {exc}")

    try:
        us_values = fetch_wsj_valuations()
        for ticker, values in us_values.items():
            merge_non_null(rows.setdefault(ticker, {}), values)
        for ticker in US_INDICES:
            if ticker not in us_values:
                gaps.append(f"{ticker}/valuation: WSJ未返回指数PE/股息率字段")
    except Exception as exc:
        gaps.append(f"US/valuation: WSJ不可用，将尝试缓存估值: {exc}")

    fill_cached_us_valuations(rows, gaps)
    save_cache(rows)

    output = []
    for code, cfg in {**CSI_INDICES, **US_INDICES}.items():
        row = rows.setdefault(code, {})
        row.update({"code": code, "name": cfg["name"], "kind": cfg["kind"], "product": cfg.get("product", "-")})
        row["pe_percentile_label"] = percentile_label(row.get("pe_percentile"))
        row["signal"] = dividend_signal(row) if cfg["kind"] == "dividend" else broad_signal(row, cfg["kind"])
        output.append(row)
    data = {"asof": dt.datetime.now().strftime("%Y-%m-%d %H:%M"), "indices": output, "data_gaps": gaps}
    annotate_snapshot_changes(data)
    if watchlist_path:
        watchlist_rows, watchlist_gaps = collect_watchlist(watchlist_path)
        data["watchlist"] = watchlist_rows
        data["data_gaps"].extend(watchlist_gaps)
        all_alerts = [
            alert
            for row in watchlist_rows
            for alert in row.get("alerts", [])
        ]
        data["alerts"] = [alert for alert in all_alerts if alert.get("level") != "data"]
        data["data_alerts"] = [alert for alert in all_alerts if alert.get("level") == "data"]
        data["notifications"] = [
            alert
            for alert in data["alerts"]
            if alert.get("notify")
        ]
    return data


def write_json(data, path):
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2)


def print_dashboard(data):
    dates = sorted({str(row.get("date")) for row in data["indices"] if row.get("date")})
    print("# 五指数决策看板")
    print()
    print(f"> 生成时间：{data['asof']}  ")
    print(f"> 行情日期：{' / '.join(dates) if dates else 'N/A'}  ")
    print("> 用途：估值与回撤辅助判断，不执行交易。")
    print()
    print("## 核心指标")
    print()
    print("| 指数 | 代码 | 对应产品 | 当前 | 52周高点 | 距高点 | PE(TTM) | PE(FWD) | PB | 股息率 | PE分位 |")
    print("|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|")
    for row in data["indices"]:
        dd_text = with_delta(pct(row.get("drawdown_52w"), 1), signed_pp(row.get("drawdown_1d_delta"), 2))
        pe_text = with_delta(num(row.get("pe_ttm"), 2), signed_num(row.get("pe_ttm_snapshot_delta"), 2))
        fwd_text = with_delta(num(row.get("pe_forward"), 2), signed_num(row.get("pe_forward_snapshot_delta"), 2))
        dy_text = with_delta(pct(row.get("dividend_yield"), 2), signed_pp(row.get("dividend_yield_snapshot_delta"), 2))
        print(
            f"| {row['name']} | `{row['code']}` | {row['product']} | "
            f"{num(row.get('current'), 2)} | {num(row.get('high_52w'), 2)} | "
            f"{dd_text} | {pe_text} | "
            f"{fwd_text} | {num(row.get('pb'), 2)} | "
            f"{dy_text} | {row.get('pe_percentile_label', '未知')} |"
        )

    print()
    print("## 阶段表现")
    print()
    print("| 指数 | 近1月 | 近3月 | 年内 | 近1年 |")
    print("|---|---:|---:|---:|---:|")
    for row in data["indices"]:
        print(
            f"| {row['name']} | {pct(row.get('return_1m'))} | {pct(row.get('return_3m'))} | "
            f"{pct(row.get('return_ytd'))} | {pct(row.get('return_1y'))} |"
        )

    print()
    print("## 决策提示")
    print()
    for row in data["indices"]:
        signal_delta = row.get("signal_snapshot_delta")
        suffix = f"（较前日：{signal_delta or 'N/A'}）"
        print(f"- **{row['name']}**：{row['signal']}{suffix}")

    print()
    print("## 数据口径")
    print()
    for row in data["indices"]:
        sources = [row.get("source_price"), row.get("source_performance"), row.get("source_valuation"), row.get("source_valuation_extra")]
        print(f"- **{row['name']}**（{row.get('date', 'N/A')}）：" + " + ".join(x for x in sources if x))
    if data["data_gaps"]:
        print()
        print("### 数据缺口")
        print()
        for gap in data["data_gaps"]:
            print("- " + gap)
    print()
    print("> PE分位来自公开估值源，仅作交叉验证；`N/A` 表示未取到，不用旧值填充。")


def selftest():
    wsj_sample = (
        '{"name":"NASDAQ 100 Index","priceEarningsRatio":"34.65",'
        '"priceEarningsRatioEstimate":"26.59","priceEarningsRatio52WeekAgo":"31.1",'
        '"yield":"0.58","formattedTradeDate":"6/12/26"}'
        '{"name":"S&P 500 Index","priceEarningsRatio":"25.1",'
        '"priceEarningsRatioEstimate":"21.54","priceEarningsRatio52WeekAgo":"23.72",'
        '"yield":"1.09","formattedTradeDate":"6/12/26"}'
    )
    cnbc_sample = (
        '<script type="application/ld+json">{"tickerSymbol":"SPX","price":"7,472.79",'
        '"priceChangePercent":"+0.1"}</script>'
        '<div>52 week range 5,432.10 - 7,620.90</div>'
    )
    wsj_test = parse_wsj_valuations(wsj_sample)
    cnbc_test = parse_cnbc_page_quote(cnbc_sample, "SPX")
    checks = [
        ("回撤120到90=-25%", abs(drawdown(90, 120) + 25) < 1e-9),
        ("-16%进入-15档", drawdown_band(-16) == -15),
        ("PE分位10%=低位", percentile_label(0.1) == "低位"),
        ("红利PE8/股息5/分位72%=不加速", "不加速" in dividend_signal({"pe_ttm": 8, "dividend_yield": 5, "pe_percentile": 0.72})),
        ("红利股息4%=暂停", "暂停" in dividend_signal({"pe_ttm": 8, "dividend_yield": 4, "pe_percentile": 0.2})),
        ("纳指前瞻PE36=暂停", "暂停" in broad_signal({"drawdown_52w": -2, "pe_forward": 36}, "nasdaq")),
        ("WSJ纳指PE解析", wsj_test.get("^NDX", {}).get("pe_forward") == 26.59),
        ("WSJ标普PE解析", wsj_test.get("^GSPC", {}).get("pe_ttm") == 25.1),
        ("CNBC页面爬虫解析", cnbc_test.get("current") == 7472.79 and cnbc_test.get("high_52w") == 7620.9),
    ]
    ok = True
    for name, passed in checks:
        print(f"[{'PASS' if passed else 'FAIL'}] {name}")
        ok = ok and passed
    return ok


def main():
    parser = argparse.ArgumentParser(description="获取五个核心指数的估值、52周回撤与决策提示")
    parser.add_argument("--json", action="store_true", help="输出JSON")
    parser.add_argument("--watchlist", default=None, help="读取观察池JSON并加入输出")
    parser.add_argument("--dashboard-json", nargs="?", const=DASHBOARD_LATEST_FILE, help="写出网页使用的JSON快照")
    parser.add_argument("--selftest", action="store_true", help="运行离线自测")
    args = parser.parse_args()
    if args.selftest:
        return 0 if selftest() else 1
    watchlist_path = args.watchlist
    if args.dashboard_json and watchlist_path is None and os.path.exists(WATCHLIST_V1_FILE):
        watchlist_path = WATCHLIST_V1_FILE
    data = collect_dashboard(watchlist_path=watchlist_path)
    if args.dashboard_json:
        write_json(data, args.dashboard_json)
    if args.json:
        print(json.dumps(data, ensure_ascii=False, indent=2))
    elif args.dashboard_json:
        print(f"Wrote dashboard JSON: {args.dashboard_json}")
    else:
        print_dashboard(data)
    return 0


if __name__ == "__main__":
    sys.exit(main())
