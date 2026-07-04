#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Build a static instrument universe for dashboard search/select inputs."""

import argparse
import datetime as dt
import json
import urllib.parse
import urllib.request


USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) DashboardsUniverse/1.0"
TIMEOUT = 15
EASTMONEY_HOSTS = ["push2.eastmoney.com", "push2delay.eastmoney.com"]


CURATED_ITEMS = [
    {"market": "A", "code": "510050", "name": "上证50ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "510300", "name": "沪深300ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "159919", "name": "沪深300ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "510500", "name": "中证500ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "512100", "name": "中证1000ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "159845", "name": "中证1000ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "159915", "name": "创业板ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "159949", "name": "创业板50ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "588000", "name": "科创50ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "588080", "name": "科创板50ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "588220", "name": "科创100ETF", "asset_type": "ETF", "bucket": "A股宽基ETF"},
    {"market": "A", "code": "512760", "name": "半导体ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "159995", "name": "芯片ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "515880", "name": "通信ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "515070", "name": "人工智能AI ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "159819", "name": "人工智能ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "562500", "name": "机器人ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "516160", "name": "新能源ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "515790", "name": "光伏ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "515030", "name": "新能源车ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512480", "name": "半导体ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512660", "name": "军工ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512690", "name": "酒ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512010", "name": "医药ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512170", "name": "医疗ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512000", "name": "券商ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512800", "name": "银行ETF", "asset_type": "ETF", "bucket": "A股主题ETF"},
    {"market": "A", "code": "512890", "name": "红利低波ETF", "asset_type": "ETF", "bucket": "A股红利ETF"},
    {"market": "A", "code": "515180", "name": "红利ETF", "asset_type": "ETF", "bucket": "A股红利ETF"},
    {"market": "A", "code": "563020", "name": "红利低波100ETF", "asset_type": "ETF", "bucket": "A股红利ETF"},
    {"market": "US", "code": "SPY", "name": "SPDR标普500ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "VOO", "name": "Vanguard标普500ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "IVV", "name": "iShares标普500ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "QQQ", "name": "纳斯达克100ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "QQQM", "name": "纳斯达克100ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "DIA", "name": "道琼斯ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "IWM", "name": "罗素2000ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "VTI", "name": "美国全市场ETF", "asset_type": "ETF", "bucket": "美股宽基ETF"},
    {"market": "US", "code": "ARKK", "name": "ARK创新ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "SMH", "name": "半导体ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "SOXX", "name": "半导体ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLK", "name": "科技行业ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLF", "name": "金融行业ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLV", "name": "医疗行业ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLE", "name": "能源行业ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLY", "name": "可选消费ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "XLP", "name": "必需消费ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "BOTZ", "name": "机器人与人工智能ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
    {"market": "US", "code": "AIQ", "name": "人工智能ETF", "asset_type": "ETF", "bucket": "美股主题ETF"},
]


def get_json(url):
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": USER_AGENT,
            "Accept": "application/json,*/*",
            "Accept-Encoding": "identity",
            "Connection": "close",
            "Referer": "https://quote.eastmoney.com/",
        },
    )
    with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
        return json.loads(response.read().decode("utf-8"))


def eastmoney_rows(fs, limit):
    rows = []
    page_size = min(200, limit)
    page = 1
    while len(rows) < limit:
        query = urllib.parse.urlencode({
            "pn": page,
            "pz": page_size,
            "po": 1,
            "np": 1,
            "fltt": 2,
            "invt": 2,
            "fid": "f20",
            "fs": fs,
            "fields": "f12,f14,f20,f2,f3,f13",
        })
        last_error = None
        page_rows = []
        for host in EASTMONEY_HOSTS:
            try:
                payload = get_json(f"https://{host}/api/qt/clist/get?{query}")
                page_rows = (payload.get("data") or {}).get("diff") or []
                break
            except Exception as exc:
                last_error = exc
        if not page_rows:
            if last_error and not rows:
                raise RuntimeError(last_error)
            break
        rows.extend(page_rows)
        page += 1
    return rows[:limit]


def build_a_mainboard_top(limit):
    rows = eastmoney_rows("m:1+t:2,m:0+t:6", limit)
    items = []
    for rank, row in enumerate(rows, 1):
        code = str(row.get("f12") or "").strip()
        name = str(row.get("f14") or "").strip()
        if not code or not name:
            continue
        items.append({
            "market": "A",
            "code": code,
            "name": name,
            "asset_type": "stock",
            "bucket": "A股主板TOP1000",
            "rank": rank,
            "market_cap": row.get("f20"),
            "source": "Eastmoney:mainboard_market_cap",
        })
    return items


def build_us_top(limit):
    rows = eastmoney_rows("m:105,m:106,m:107", limit)
    items = []
    for rank, row in enumerate(rows, 1):
        code = str(row.get("f12") or "").strip()
        name = str(row.get("f14") or "").strip()
        if not code or not name:
            continue
        items.append({
            "market": "US",
            "code": code,
            "name": name,
            "asset_type": "stock",
            "bucket": "US TOP100",
            "rank": rank,
            "market_cap": row.get("f20"),
            "source": "Eastmoney:us_market_cap",
        })
    return items


def merge_items(*groups):
    merged = {}
    for group in groups:
        for item in group:
            key = f"{item.get('market')}:{item.get('code')}"
            if not item.get("code") or key in merged:
                continue
            merged[key] = item
    return sorted(
        merged.values(),
        key=lambda item: (
            item.get("market") or "",
            item.get("bucket") or "",
            item.get("rank") or 999999,
            item.get("code") or "",
        ),
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="dashboards/instrument_universe.json")
    parser.add_argument("--a-limit", type=int, default=1000)
    parser.add_argument("--us-limit", type=int, default=100)
    args = parser.parse_args()

    errors = []
    a_items = []
    us_items = []
    try:
        a_items = build_a_mainboard_top(args.a_limit)
    except Exception as exc:
        errors.append(f"A股主板TOP1000刷新失败：{exc}")
    try:
        us_items = build_us_top(args.us_limit)
    except Exception as exc:
        errors.append(f"US TOP100刷新失败：{exc}")

    data = {
        "updated_at": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "sources": [
            "curated:mainstream_etf",
            "Eastmoney:A_mainboard_market_cap",
            "Eastmoney:US_market_cap",
        ],
        "errors": errors,
        "items": merge_items(CURATED_ITEMS, us_items, a_items),
    }
    with open(args.output, "w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    print(f"wrote {args.output}: {len(data['items'])} instruments")
    if errors:
        for error in errors:
            print(error)


if __name__ == "__main__":
    main()
