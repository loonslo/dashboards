import argparse
import datetime as dt
import json

from _bootstrap import REPO_ROOT, default_db_path
from short_flow.data_sources.eastmoney import classify_etf, fetch_etf_list
from short_flow.db import connect, init_db


def seed_from_watchlist():
    path = REPO_ROOT / "dashboards" / "short-flow" / "watchlist_v1.json"
    payload = json.loads(path.read_text(encoding="utf-8"))
    items = []
    for item in payload.get("items", []):
        code = str(item.get("code") or "").strip()
        name = item.get("name") or code
        category = classify_etf(code, name)
        if not code:
            continue
        items.append({
            "code": code,
            "name": name,
            "market": "SH" if code.startswith(("5", "6")) else "SZ",
            "category": category,
            "sub_category": item.get("group") or "",
            "is_broad": 1 if category in ("CORE", "GROWTH") else 0,
            "is_theme": 1 if category == "THEME" else 0,
            "is_qdii": 1 if category == "CROSS" else 0,
            "is_bond": 1 if category == "BOND" else 0,
            "is_money": 1 if category == "MONEY" else 0,
        })
    return items


def upsert_master(db_path, items):
    now = dt.datetime.now().isoformat(timespec="seconds")
    with connect(db_path) as conn:
        conn.execute("UPDATE etf_master SET status='inactive'")
        for item in items:
            conn.execute(
                """
                INSERT INTO etf_master (
                  code, name, market, category, sub_category, is_broad, is_theme,
                  is_qdii, is_bond, is_money, status, updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active', ?)
                ON CONFLICT(code) DO UPDATE SET
                  name=excluded.name,
                  market=excluded.market,
                  category=excluded.category,
                  sub_category=excluded.sub_category,
                  is_broad=excluded.is_broad,
                  is_theme=excluded.is_theme,
                  is_qdii=excluded.is_qdii,
                  is_bond=excluded.is_bond,
                  is_money=excluded.is_money,
                  status='active',
                  updated_at=excluded.updated_at
                """,
                (
                    item["code"], item["name"], item["market"], item["category"], item.get("sub_category", ""),
                    item["is_broad"], item["is_theme"], item["is_qdii"], item["is_bond"], item["is_money"], now,
                ),
            )
        conn.commit()


def main():
    parser = argparse.ArgumentParser(description="Fetch or seed ETF master table")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--seed-only", action="store_true")
    args = parser.parse_args()
    init_db(args.db)
    items = []
    if not args.seed_only:
        try:
            items = fetch_etf_list()
        except Exception as exc:
            print(f"ETF master API failed, using seed watchlist: {exc}")
    if not items:
        items = seed_from_watchlist()
    upsert_master(args.db, items)
    print(f"upserted etf_master rows: {len(items)}")


if __name__ == "__main__":
    main()


