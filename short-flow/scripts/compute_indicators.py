import argparse
import statistics

from _bootstrap import default_db_path
from short_flow.data_sources.eastmoney import fetch_daily_klines
from short_flow.db import connect, init_db, rows


def mean(values):
    values = [value for value in values if value is not None]
    return statistics.fmean(values) if values else None


def pct_change(now, old):
    if now is None or old in (None, 0):
        return None
    return (now / old - 1) * 100


def ratio(now, old):
    if now is None or old in (None, 0):
        return None
    return now / old


def ma(values, window):
    if len(values) < window:
        return None
    return mean(values[-window:])


def amount_avg(klines, window):
    sample = klines[-window - 1:-1]
    if len(sample) < window:
        return None
    return mean([row.get("amount") for row in sample])


def latest_trade_date(conn):
    row = conn.execute("SELECT MAX(trade_date) AS d FROM etf_snapshot").fetchone()
    return row["d"] if row and row["d"] else None


def main():
    parser = argparse.ArgumentParser(description="Compute ETF indicators")
    parser.add_argument("--db", default=str(default_db_path()))
    args = parser.parse_args()
    init_db(args.db)
    with connect(args.db) as conn:
        trade_date = latest_trade_date(conn)
        if not trade_date:
            raise SystemExit("No snapshot rows; run fetch_snapshot.py first")
        masters = rows(conn, "SELECT code FROM etf_master WHERE status='active' AND is_money=0 AND is_bond=0 ORDER BY code")
        conn.execute("DELETE FROM etf_indicator WHERE trade_date=?", (trade_date,))
        count = 0
        for master in masters:
            try:
                klines = fetch_daily_klines(master["code"], 90)
            except Exception:
                continue
            if not klines:
                continue
            closes = [row["close"] for row in klines]
            latest = klines[-1]
            ma5, ma10, ma20, ma60 = ma(closes, 5), ma(closes, 10), ma(closes, 20), ma(closes, 60)
            previous_ma20 = ma(closes[:-1], 20) if len(closes) > 20 else None
            conn.execute(
                """
                INSERT INTO etf_indicator (
                  trade_date, code, ma5, ma10, ma20, ma60, ret5, ret10, ret20,
                  amount_ratio_5, amount_ratio_20, above_ma5, above_ma10,
                  above_ma20, ma20_slope_positive
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    trade_date, master["code"], ma5, ma10, ma20, ma60,
                    pct_change(closes[-1], closes[-6] if len(closes) >= 6 else None),
                    pct_change(closes[-1], closes[-11] if len(closes) >= 11 else None),
                    pct_change(closes[-1], closes[-21] if len(closes) >= 21 else None),
                    ratio(latest.get("amount"), amount_avg(klines, 5)),
                    ratio(latest.get("amount"), amount_avg(klines, 20)),
                    1 if ma5 is not None and closes[-1] >= ma5 else 0,
                    1 if ma10 is not None and closes[-1] >= ma10 else 0,
                    1 if ma20 is not None and closes[-1] >= ma20 else 0,
                    1 if ma20 is not None and previous_ma20 is not None and ma20 > previous_ma20 else 0,
                ),
            )
            count += 1
        conn.commit()
    print(f"computed indicators: {count} @ {trade_date}")


if __name__ == "__main__":
    main()

