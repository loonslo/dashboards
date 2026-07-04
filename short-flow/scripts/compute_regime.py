import argparse

from _bootstrap import default_db_path
from short_flow.db import connect, init_db
from short_flow.rules.regime import classify_regime


def main():
    parser = argparse.ArgumentParser(description="Compute market regime")
    parser.add_argument("--db", default=str(default_db_path()))
    args = parser.parse_args()
    init_db(args.db)
    with connect(args.db) as conn:
        row = conn.execute("SELECT MAX(trade_date) AS d FROM etf_indicator").fetchone()
        trade_date = row["d"] if row else None
        if not trade_date:
            raise SystemExit("No indicators; run compute_indicators.py first")
        stats = conn.execute(
            """
            SELECT
              AVG(CASE WHEN above_ma20=1 THEN 1.0 ELSE 0.0 END) AS above_ma20_ratio,
              AVG(CASE WHEN ma20_slope_positive=1 THEN 1.0 ELSE 0.0 END) AS ma20_slope_positive_ratio
            FROM etf_indicator WHERE trade_date=?
            """,
            (trade_date,),
        ).fetchone()
        inflow = conn.execute(
            """
            SELECT AVG(CASE WHEN s.main_inflow > 0 THEN 1.0 ELSE 0.0 END) AS inflow_ratio
            FROM etf_snapshot s
            JOIN (
              SELECT code, MAX(id) AS id FROM etf_snapshot WHERE trade_date=? GROUP BY code
            ) latest ON latest.id=s.id
            """,
            (trade_date,),
        ).fetchone()
        above = stats["above_ma20_ratio"] or 0
        slope = stats["ma20_slope_positive_ratio"] or 0
        inflow_ratio = inflow["inflow_ratio"] or 0
        regime = classify_regime(above, slope, inflow_ratio)
        conn.execute(
            """
            INSERT INTO market_regime (trade_date, above_ma20_ratio, ma20_slope_positive_ratio, inflow_5d_ratio, regime)
            VALUES (?, ?, ?, ?, ?)
            ON CONFLICT(trade_date) DO UPDATE SET
              above_ma20_ratio=excluded.above_ma20_ratio,
              ma20_slope_positive_ratio=excluded.ma20_slope_positive_ratio,
              inflow_5d_ratio=excluded.inflow_5d_ratio,
              regime=excluded.regime
            """,
            (trade_date, above, slope, inflow_ratio, regime),
        )
        conn.commit()
    print(f"market_regime {trade_date}: {regime} above_ma20={above:.2f} slope={slope:.2f} inflow={inflow_ratio:.2f}")


if __name__ == "__main__":
    main()


