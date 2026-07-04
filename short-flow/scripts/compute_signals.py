import argparse
import datetime as dt

from _bootstrap import default_config_path, default_db_path
from short_flow.config import load_config
from short_flow.db import connect, init_db, rows
from short_flow.rules.entry_patterns import classify_entry_pattern
from short_flow.rules.filters import hard_filter, score_direction


def latest_trade_date(conn):
    row = conn.execute("SELECT MAX(trade_date) AS d FROM etf_indicator").fetchone()
    return row["d"] if row and row["d"] else None


def main():
    parser = argparse.ArgumentParser(description="Compute ETF hard-filter signals")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--config", default=str(default_config_path()))
    parser.add_argument("--session", default="0940")
    args = parser.parse_args()
    config = load_config(args.config)
    init_db(args.db)
    ts = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    with connect(args.db) as conn:
        trade_date = latest_trade_date(conn)
        if not trade_date:
            raise SystemExit("No indicators; run compute_indicators.py first")
        conn.execute("DELETE FROM signal_result WHERE trade_date=? AND ts LIKE ?", (trade_date, f"{ts[:10]}%"))
        records = rows(
            conn,
            """
            SELECT m.*, s.price, s.pct, s.amount, s.volume, s.main_inflow, s.main_inflow_pct,
                   i.ma5, i.ma10, i.ma20, i.ma60, i.ret5, i.ret10, i.ret20,
                   i.amount_ratio_5, i.amount_ratio_20, i.above_ma5, i.above_ma10,
                   i.above_ma20, i.ma20_slope_positive
            FROM etf_master m
            JOIN (
              SELECT s1.* FROM etf_snapshot s1
              JOIN (
                SELECT code, MAX(id) AS id FROM etf_snapshot WHERE trade_date=? GROUP BY code
              ) latest ON latest.id=s1.id
            ) s ON s.code=m.code
            JOIN etf_indicator i ON i.code=m.code AND i.trade_date=?
            WHERE m.status='active' AND m.is_money=0 AND m.is_bond=0
            """,
            (trade_date, trade_date),
        )
        count = 0
        for record in records:
            master = record
            snapshot = record
            indicator = record
            rule, reason = hard_filter(master, snapshot, indicator, config)
            score = score_direction(snapshot, indicator)
            pattern = classify_entry_pattern(indicator)
            if rule == "candidate":
                trigger = "09:40后站稳VWAP/MA5且主力资金保持为正"
                failure = "资金转负或跌破MA5；跌破MA10退出观察"
            elif rule == "wait":
                trigger = "等待资金转正并站回MA5"
                failure = "继续跌破MA10或放量长阴"
            else:
                trigger = "不触发"
                failure = "今日不碰，盘后重新评估"
            conn.execute(
                """
                INSERT INTO signal_result (
                  ts, trade_date, code, name, group_name, score, rule_result,
                  reason, entry_trigger, failure_condition
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (ts, trade_date, record["code"], record["name"], record["category"], score, rule, f"{reason}；{pattern}", trigger, failure),
            )
            count += 1
        conn.commit()
    print(f"computed signals: {count} @ {trade_date} session={args.session}")


if __name__ == "__main__":
    main()


