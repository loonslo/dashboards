import argparse
import datetime as dt
import statistics

from _bootstrap import default_db_path
from short_flow.data_sources.eastmoney import fetch_daily_klines
from short_flow.db import connect, init_db, rows


# Sessions before market close (15:00) — the current day's kline is incomplete.
# Amount ratios must use the previous complete day as numerator, otherwise
# e.g. the 0940 session has only ~15-20% of full-day amount, making
# amount_ratio_20 structurally too low and B_PLATFORM_BREAKOUT_WATCH
# (which requires >= 1.3) impossible to trigger.
INTRADAY_SESSIONS = {"0850", "0940", "1130", "1430"}


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


def amount_avg_complete(klines, window, complete_idx):
    """Amount average over `window` complete days ending at `complete_idx` (inclusive)."""
    start = complete_idx - window + 1
    if start < 0 or complete_idx >= len(klines):
        return None
    sample = klines[start:complete_idx + 1]
    amounts = [row.get("amount") for row in sample]
    if any(a is None for a in amounts) or len(amounts) < window:
        return None
    return mean(amounts)


def latest_trade_date(conn):
    row = conn.execute("SELECT MAX(trade_date) AS d FROM etf_snapshot").fetchone()
    return row["d"] if row and row["d"] else None


def main():
    parser = argparse.ArgumentParser(description="Compute ETF indicators")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--session", default="1520",
                        help="Session key (0850/0940/1130/1430/1520); intraday sessions use "
                             "previous-complete-day amount for ratios to avoid partial-data bias")
    args = parser.parse_args()
    is_intraday = args.session in INTRADAY_SESSIONS
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
            if not klines or len(klines) < 21:
                continue
            closes = [row["close"] for row in klines]
            latest = klines[-1]
            # 盘中场次：价格用当前K线（MA比较有意义），成交额用前一个完整日
            if is_intraday and len(klines) >= 2:
                complete_latest = klines[-2]
                complete_idx = -2
            else:
                complete_latest = latest
                complete_idx = -1
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
                    trade_date,
                    master["code"],
                    ma5, ma10, ma20, ma60,
                    pct_change(closes[-1], closes[-6] if len(closes) >= 6 else None),
                    pct_change(closes[-1], closes[-11] if len(closes) >= 11 else None),
                    pct_change(closes[-1], closes[-21] if len(closes) >= 21 else None),
                    ratio(complete_latest.get("amount"), amount_avg_complete(klines, 5, complete_idx)),
                    ratio(complete_latest.get("amount"), amount_avg_complete(klines, 20, complete_idx)),
                    1 if ma5 is not None and closes[-1] >= ma5 else 0,
                    1 if ma10 is not None and closes[-1] >= ma10 else 0,
                    1 if ma20 is not None and closes[-1] >= ma20 else 0,
                    1 if ma20 is not None and previous_ma20 is not None and ma20 > previous_ma20 else 0,
                ),
            )
            count += 1
        conn.commit()
    label = "intraday (amount from prev complete day)" if is_intraday else "after-close"
    print(f"computed indicators: {count} @ {trade_date} session={args.session} [{label}]")


if __name__ == "__main__":
    main()

