import argparse
import datetime as dt

from _bootstrap import default_db_path
from short_flow.data_sources.eastmoney import fetch_quotes
from short_flow.db import connect, init_db, rows


def active_codes(conn):
    return rows(
        conn,
        """
        SELECT code, name FROM etf_master
        WHERE status='active' AND is_money=0 AND is_bond=0
        ORDER BY category, code
        """,
    )


def main():
    parser = argparse.ArgumentParser(description="Fetch ETF quote and money-flow snapshot")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--ts", default=None)
    args = parser.parse_args()
    init_db(args.db)
    ts = args.ts or dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    trade_date = ts[:10]
    with connect(args.db) as conn:
        masters = active_codes(conn)
        quotes = fetch_quotes([row["code"] for row in masters])
        for master in masters:
            quote = quotes.get(master["code"]) or {}
            conn.execute(
                """
                INSERT INTO etf_snapshot (
                  ts, trade_date, code, name, price, pct, amount, volume,
                  main_inflow, main_inflow_pct, market_cap, float_market_cap
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    ts, trade_date, master["code"], quote.get("name") or master["name"],
                    quote.get("price"), quote.get("pct"), quote.get("amount"), quote.get("volume"),
                    quote.get("main_inflow"), quote.get("main_inflow_pct"),
                    quote.get("market_cap"), quote.get("float_market_cap"),
                ),
            )
        conn.commit()
    print(f"inserted snapshot rows: {len(masters)} @ {ts}")


if __name__ == "__main__":
    main()

