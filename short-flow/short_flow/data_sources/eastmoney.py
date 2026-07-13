import json
import shutil
import subprocess
import time
import urllib.parse
import urllib.request


USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
ETF_LIST_HOSTS = ("push2.eastmoney.com", "push2delay.eastmoney.com")


def secid_for(code):
    code = str(code).strip()
    return f"1.{code}" if code.startswith(("5", "6", "9")) else f"0.{code}"


def tencent_symbol_for(code):
    code = str(code).strip()
    return ("sh" if code.startswith(("5", "6", "9")) else "sz") + code


def get_json(url, timeout=14):
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/json,text/plain,*/*",
        "Connection": "close",
    }
    if "eastmoney.com" in url:
        headers["Referer"] = "https://quote.eastmoney.com/"
    elif "gtimg.cn" in url:
        headers["Referer"] = "https://gu.qq.com/"
    last_error = None
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=timeout) as response:
                return json.loads(response.read().decode("utf-8"))
        except Exception as exc:
            last_error = exc
            time.sleep(0.4 + attempt * 0.8)
    curl = shutil.which("curl") or shutil.which("curl.exe")
    if curl:
        command = [curl, "-L", "--http1.1", "-A", USER_AGENT]
        if headers.get("Referer"):
            command.extend(["-e", headers["Referer"]])
        command.append(url)
        try:
            completed = subprocess.run(command, capture_output=True, timeout=timeout + 10, check=True)
            return json.loads(completed.stdout.decode("utf-8"))
        except Exception as exc:
            last_error = exc
    raise last_error


def to_float(value):
    if value in (None, "", "-"):
        return None
    try:
        return float(str(value).replace(",", "").replace("%", ""))
    except (TypeError, ValueError):
        return None


def classify_etf(code, name):
    name = name or ""
    if any(token in name for token in ("货币", "现金", "添利", "快线")):
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
    if any(token in name for token in ("证券", "医药", "通信", "军工", "新能源", "传媒")):
        return "SECTOR"
    if any(token in name for token in ("创业板", "科创", "双创")):
        return "GROWTH"
    if any(token in name for token in ("上证50", "沪深300", "中证500", "中证1000", "A500", "宽基")):
        return "CORE"
    return "SECTOR"


def _fetch_etf_page(query, require_rows):
    last_error = None
    for host in ETF_LIST_HOSTS:
        try:
            payload = get_json(f"https://{host}/api/qt/clist/get?{query}")
            data = payload.get("data") if isinstance(payload, dict) else None
            if not isinstance(data, dict):
                raise ValueError(f"invalid ETF list response from {host}")
            diff = data.get("diff") or []
            if require_rows and not diff:
                raise ValueError(f"empty ETF list response from {host}")
            return data
        except Exception as exc:
            last_error = exc
    raise RuntimeError("all ETF list endpoints failed") from last_error


def fetch_etf_list(max_pages=30, page_size=100):
    # Eastmoney caps clist pages in practice, so fetch page-by-page instead of
    # relying on a large pz. Callers still fall back to the local seed list if
    # this public endpoint is unavailable.
    items = []
    seen = set()
    total = None
    fields = "f12,f14,f2,f3,f6,f20"
    fs = "b:MK0021,b:MK0022,b:MK0023,b:MK0024"
    for page in range(1, max_pages + 1):
        query = urllib.parse.urlencode({
            "pn": page,
            "pz": page_size,
            "po": 1,
            "np": 1,
            "fltt": 2,
            "invt": 2,
            "fid": "f3",
            "fs": fs,
            "fields": fields,
        }, safe=",:")
        expect_rows = page == 1 or (total is not None and len(items) < int(total))
        data = _fetch_etf_page(query, require_rows=expect_rows)
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
                "sub_category": "",
                "is_broad": 1 if category in ("CORE", "GROWTH") else 0,
                "is_theme": 1 if category == "THEME" else 0,
                "is_qdii": 1 if category == "CROSS" else 0,
                "is_bond": 1 if category == "BOND" else 0,
                "is_money": 1 if category == "MONEY" else 0,
            })
        if total and len(items) >= int(total):
            break
        time.sleep(0.2)
    if not items:
        raise RuntimeError("ETF list endpoints returned no rows")
    if total is not None and len(items) < int(total):
        raise RuntimeError(f"incomplete ETF list: received {len(items)} of {int(total)} rows")
    return items

def fetch_quotes(codes):
    result = {}
    fields = "f12,f14,f2,f3,f5,f6,f20,f21,f62,f184,f66,f72,f78,f84"
    secids = [secid_for(code) for code in codes]
    for index in range(0, len(secids), 4):
        chunk = ",".join(secids[index:index + 4])
        query = urllib.parse.urlencode({
            "fltt": "2",
            "invt": "2",
            "fields": fields,
            "secids": chunk,
        }, safe=",")
        try:
            payload = get_json(f"https://push2delay.eastmoney.com/api/qt/ulist.np/get?{query}")
        except Exception:
            continue
        for row in ((payload.get("data") or {}).get("diff") or []):
            code = str(row.get("f12") or "").strip()
            if not code:
                continue
            result[code] = {
                "code": code,
                "name": row.get("f14"),
                "price": to_float(row.get("f2")),
                "pct": to_float(row.get("f3")),
                "volume": to_float(row.get("f5")),
                "amount": to_float(row.get("f6")),
                "market_cap": to_float(row.get("f20")),
                "float_market_cap": to_float(row.get("f21")),
                "main_inflow": to_float(row.get("f62")),
                "main_inflow_pct": to_float(row.get("f184")),
                "super_large_net": to_float(row.get("f66")),
                "large_net": to_float(row.get("f72")),
                "medium_net": to_float(row.get("f78")),
                "small_net": to_float(row.get("f84")),
            }
        time.sleep(0.2)
    return result


def fetch_daily_klines(code, limit=90):
    symbol = tencent_symbol_for(code)
    query = urllib.parse.urlencode({"param": f"{symbol},day,,,{limit},qfq"})
    payload = get_json(f"https://web.ifzq.gtimg.cn/appstock/app/fqkline/get?{query}")
    data = (payload.get("data") or {}).get(symbol) or {}
    raw = data.get("qfqday") or data.get("day") or []
    rows = []
    previous_close = None
    for item in raw:
        if len(item) < 6:
            continue
        close = to_float(item[2])
        volume = to_float(item[5])
        amount = close * volume * 100 if close is not None and volume is not None else None
        rows.append({
            "date": item[0],
            "open": to_float(item[1]),
            "close": close,
            "high": to_float(item[3]),
            "low": to_float(item[4]),
            "volume": volume,
            "amount": amount,
            "pct": (close / previous_close - 1) * 100 if close is not None and previous_close else None,
        })
        if close:
            previous_close = close
    return rows


def fetch_historical_flow(code, limit=500):
    """Fetch historical daily money flow from Eastmoney push2his endpoint.

    Returns list of dicts with keys: date, main_net, small_net, medium_net,
    large_net, super_large_net. main_net = super_large + large (主力).
    Unlike the real-time snapshot endpoint which may have different
    classification, this is the historical daily-aggregated flow.
    """
    sid = secid_for(code)
    query = urllib.parse.urlencode({
        "secid": sid,
        "fields1": "f1,f2,f3,f7",
        "fields2": "f51,f52,f53,f54,f55,f56",
        "lmt": str(limit),
        "klt": "101",
    })
    payload = get_json(
        f"https://push2his.eastmoney.com/api/qt/stock/fflow/daykline/get?{query}"
    )
    data = (payload.get("data") or {}).get("klines") or []
    rows = []
    for item in data:
        parts = item.split(",")
        if len(parts) < 6:
            continue
        rows.append({
            "date": parts[0],
            "main_net": to_float(parts[1]),
            "small_net": to_float(parts[2]),
            "medium_net": to_float(parts[3]),
            "large_net": to_float(parts[4]),
            "super_large_net": to_float(parts[5]),
        })
    return rows


def fetch_historical_klines(code, limit=500):
    """Fetch historical daily klines from Eastmoney push2his endpoint.

    Fallback when Tencent gtimg is rate-limited. Returns same format as
    fetch_daily_klines: list of dicts with date/open/close/high/low/volume/amount/pct.
    """
    sid = secid_for(code)
    query = urllib.parse.urlencode({
        "secid": sid,
        "fields1": "f1,f2,f3,f4,f5,f6",
        "fields2": "f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61",
        "klt": "101",
        "fqt": "1",
        "end": "20500101",
        "lmt": str(limit),
    })
    payload = get_json(
        f"https://push2his.eastmoney.com/api/qt/stock/kline/get?{query}"
    )
    data = (payload.get("data") or {}).get("klines") or []
    rows = []
    previous_close = None
    for item in data:
        parts = item.split(",")
        if len(parts) < 6:
            continue
        close = to_float(parts[2])
        volume = to_float(parts[5])
        amount = to_float(parts[6]) if len(parts) > 6 else None
        rows.append({
            "date": parts[0],
            "open": to_float(parts[1]),
            "close": close,
            "high": to_float(parts[3]),
            "low": to_float(parts[4]),
            "volume": volume,
            "amount": amount,
            "pct": (close / previous_close - 1) * 100 if close is not None and previous_close else None,
        })
        if close:
            previous_close = close
    return rows
