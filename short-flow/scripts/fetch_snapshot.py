import argparse
import datetime as dt
from collections import Counter

from _bootstrap import default_config_path, default_db_path
from short_flow.config import load_config
from short_flow.data_sources.eastmoney import fetch_daily_klines, fetch_quotes
from short_flow.db import connect, init_db, rows
from short_flow.shortlist import is_intraday, monitor_codes


def active_codes(conn):
    return rows(
        conn,
        """
        SELECT code, name FROM etf_master
        WHERE status='active' AND is_money=0 AND is_bond=0
        ORDER BY category, code
        """,
    )


def resolve_trade_date(codes, sample_size=3):
    """Resolve the exchange trade date from recent k-lines, not wall-clock time."""
    dates = []
    errors = []
    for code in codes[:sample_size]:
        try:
            klines = fetch_daily_klines(code, 5)
            if klines and klines[-1].get("date"):
                dates.append(klines[-1]["date"])
        except Exception as exc:
            errors.append(f"{code}: {exc}")
    if not dates:
        detail = errors[0] if errors else "no active ETF codes"
        raise RuntimeError(f"unable to resolve market trade date: {detail}")
    return Counter(dates).most_common(1)[0][0]


def main():
    parser = argparse.ArgumentParser(description="Fetch ETF quote and money-flow snapshot")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--config", default=str(default_config_path()))
    parser.add_argument("--ts", default=None)
    parser.add_argument("--session", default="0940")
    parser.add_argument("--allow-stale-trade-date", action="store_true")
    parser.add_argument("--full-universe", action="store_true",
                        help="Force full-universe fetch even for intraday sessions")
    args = parser.parse_args()
    config = load_config(args.config)
    init_db(args.db)
    ts = args.ts or dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    with connect(args.db) as conn:
        masters = active_codes(conn)
        # 两段漏斗：盘中场次只拉 T-1 短名单 ∪ 持仓 ∪ 基准ETF；
        # 全市场扫描只在盘后（1520）场次进行。
        if is_intraday(args.session) and not args.full_universe:
            codes = set(monitor_codes(conn, ts[:10], config))
            if codes:
                masters = [row for row in masters if row["code"] in codes]
            else:
                print("no shortlist for previous trade date; falling back to full universe")
        trade_date = resolve_trade_date([row["code"] for row in masters])
        expected_date = ts[:10]
        if (
            args.session != "0850"
            and trade_date != expected_date
            and not args.allow_stale_trade_date
        ):
            raise SystemExit(
                f"No current-session market data: expected {expected_date}, latest k-line is {trade_date}. "
                "Skip publishing to avoid labeling stale quotes as a new trade day."
            )
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
    scope = "shortlist" if (is_intraday(args.session) and not args.full_universe) else "full"
    print(f"inserted snapshot rows: {len(masters)} @ {ts} session={args.session} [{scope}]")


if __name__ == "__main__":
    main()

