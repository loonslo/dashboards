#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""加密币看板：从 CoinGecko 获取实时行情与基础指标。"""

import argparse
import datetime as dt
import json
import os
import sys
import time
import urllib.parse
import urllib.request


HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
DEFAULT_OUTPUT = os.path.join(REPO, "dashboards", "asset-management", "crypto_latest.json")

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) CryptoDashboard/1.0"
TIMEOUT = 12

# CoinGecko 公开 API，无需 API Key
CG_API = "https://api.coingecko.com/api/v3"

# 支持的币种（用户可在此扩展或通过配置文件）
CRYPTO_WATCHLIST = [
    {"id": "bitcoin", "ticker": "BTC", "name": "Bitcoin"},
    {"id": "ethereum", "ticker": "ETH", "name": "Ethereum"},
    {"id": "solana", "ticker": "SOL", "name": "Solana"},
]


def to_float(value):
    if value in (None, "", "-"):
        return None
    try:
        return float(str(value).replace(",", ""))
    except (TypeError, ValueError):
        return None


def get_json(url):
    req = urllib.request.Request(
        url,
        headers={"User-Agent": USER_AGENT, "Accept": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
        return json.loads(resp.read().decode("utf-8"))


def fetch_simple_prices(coin_ids):
    """批量获取当前价格和24小时变化。"""
    ids = ",".join(coin_ids)
    params = urllib.parse.urlencode({
        "ids": ids,
        "vs_currencies": "usd",
        "include_24hr_change": "true",
        "include_market_cap": "true",
    })
    return get_json(f"{CG_API}/simple/price?{params}")


def fetch_coin_detail(coin_id):
    """获取单币详细数据（用于持仓的额外信息）。"""
    params = urllib.parse.urlencode({
        "localization": "false",
        "tickers": "false",
        "market_data": "true",
        "community_data": "false",
        "developer_data": "false",
    })
    return get_json(f"{CG_API}/coins/{urllib.parse.quote(coin_id)}?{params}")


def collect_crypto(watchlist=None, max_workers=2):
    """获取加密币行情。"""
    if watchlist is None:
        watchlist = CRYPTO_WATCHLIST
    coin_ids = [c["id"] for c in watchlist]

    # 批量获取简单价格
    simple = {}
    try:
        simple = fetch_simple_prices(coin_ids)
        time.sleep(1.0)  # 遵守限流
    except Exception as exc:
        pass  # simple 为空时回退到逐个获取

    prices = []
    gaps = []
    for coin in watchlist:
        cid = coin["id"]
        price_usd = None
        change_24h = None
        market_cap = None

        # 优先用批量数据
        data = simple.get(cid, {})
        if data:
            price_usd = to_float(data.get("usd"))
            change_24h = to_float(data.get("usd_24h_change"))
            market_cap = to_float(data.get("usd_market_cap"))

        # 批量失败时逐个获取
        if price_usd is None:
            try:
                detail = fetch_coin_detail(cid)
                md = detail.get("market_data") or {}
                price_usd = to_float(md.get("current_price", {}).get("usd"))
                change_24h = to_float(md.get("price_change_percentage_24h"))
                market_cap = to_float(md.get("market_cap", {}).get("usd"))
                time.sleep(1.2)
            except Exception as exc:
                gaps.append(f"{coin['ticker']}: {exc}")

        prices.append({
            "id": cid,
            "ticker": coin["ticker"],
            "name": coin["name"],
            "price_usd": price_usd,
            "change_24h_pct": change_24h,
            "market_cap_usd": market_cap,
            "source": "CoinGecko" if price_usd is not None else "unavailable",
        })

    return {
        "asof": dt.datetime.now(dt.UTC).strftime("%Y-%m-%d %H:%M UTC") if hasattr(dt, 'UTC') else dt.datetime.utcnow().strftime("%Y-%m-%d %H:%M") + " UTC",
        "prices": prices,
        "data_gaps": gaps,
    }


def main():
    parser = argparse.ArgumentParser(description="获取加密币行情数据")
    parser.add_argument("--output", default=DEFAULT_OUTPUT, help="输出JSON路径")
    parser.add_argument("--json", action="store_true", help="打印JSON到stdout")
    args = parser.parse_args()

    data = collect_crypto()
    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    if args.json:
        print(json.dumps(data, ensure_ascii=False, indent=2))
    else:
        print(f"Wrote crypto dashboard: {args.output}")
        for p in data["prices"]:
            status = "✅" if p["price_usd"] is not None else "❌"
            print(f"  {status} {p['ticker']}: ${p['price_usd'] or 'N/A'} ({p.get('change_24h_pct', 'N/A')})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
