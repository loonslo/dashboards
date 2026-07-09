import argparse
import re

from _bootstrap import default_db_path
from short_flow.db import connect, init_db, rows
from short_flow.rules.regime import classify_regime


# Common fund-company suffixes in Chinese ETF names. Stripping these
# gives the underlying tracking index, so multiple ETFs on the same
# index (e.g. 沪深300ETF华夏, 沪深300ETF易方达) are grouped together.
# Without this dedup, indices with many ETF listings dominate the
# breadth statistics and the market regime reflects ETF issuance
# structure rather than actual market breadth.
_FUND_SUFFIX_RE = re.compile(
    r"(ETF|联接)?(华夏|易方达|南方|广发|富国|嘉实|博时|华泰柏瑞|"
    r"华安|天弘|国泰|招商|景顺长城|工银|银华|鹏华|万家|大成|"
    r"汇添富|海富通|建信|平安|泰康|兴全|中欧|交银|摩根|华宝|"
    r"方正|申万|中银|前海|永赢|国联安|西藏东财)?$"
)


def tracking_index(name):
    """Extract underlying index name from ETF product name.

    >>> tracking_index("沪深300ETF华夏")
    '沪深300'
    >>> tracking_index("科创50ETF")
    '科创50'
    >>> tracking_index("半导体ETF")
    '半导体'
    """
    cleaned = _FUND_SUFFIX_RE.sub("", name or "")
    return cleaned.strip() or name


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

        # ── Breadth stats: weighted by unique tracking index ──
        # Group indicators by tracking index, take one representative
        # per index, then average. This prevents index families with
        # many ETF listings from dominating.
        indicator_rows = rows(conn, """
            SELECT i.above_ma20, i.ma20_slope_positive, m.name
            FROM etf_indicator i
            JOIN etf_master m ON m.code = i.code
            WHERE i.trade_date=?
        """, (trade_date,))

        seen_index = {}
        for r in indicator_rows:
            idx = tracking_index(r["name"])
            if idx not in seen_index:
                seen_index[idx] = r

        if seen_index:
            deduped = list(seen_index.values())
            above = sum(r["above_ma20"] or 0 for r in deduped) / len(deduped)
            slope = sum(r["ma20_slope_positive"] or 0 for r in deduped) / len(deduped)
            dedup_count = len(deduped)
            raw_count = len(indicator_rows)
        else:
            above = slope = 0
            dedup_count = raw_count = 0

        # ── Inflow breadth: ETF-level, one per snapshot ──
        inflow_row = conn.execute(
            """
            SELECT AVG(CASE WHEN s.main_inflow > 0 THEN 1.0 ELSE 0.0 END) AS inflow_ratio
            FROM etf_snapshot s
            JOIN (
              SELECT code, MAX(id) AS id FROM etf_snapshot WHERE trade_date=? GROUP BY code
            ) latest ON latest.id=s.id
            """,
            (trade_date,),
        ).fetchone()
        inflow_ratio = inflow_row["inflow_ratio"] or 0

        # ── Hysteresis: read previous regime ──
        prev_row = conn.execute(
            "SELECT regime FROM market_regime WHERE trade_date < ? ORDER BY trade_date DESC LIMIT 1",
            (trade_date,),
        ).fetchone()
        previous_regime = prev_row["regime"] if prev_row else None

        regime = classify_regime(above, slope, inflow_ratio, previous_regime=previous_regime)

        conn.execute(
            """
            INSERT INTO market_regime (trade_date, above_ma20_ratio, ma20_slope_positive_ratio, inflow_positive_ratio, regime)
            VALUES (?, ?, ?, ?, ?)
            ON CONFLICT(trade_date) DO UPDATE SET
              above_ma20_ratio=excluded.above_ma20_ratio,
              ma20_slope_positive_ratio=excluded.ma20_slope_positive_ratio,
              inflow_positive_ratio=excluded.inflow_positive_ratio,
              regime=excluded.regime
            """,
            (trade_date, above, slope, inflow_ratio, regime),
        )
        conn.commit()

    print(
        f"market_regime {trade_date}: {regime} "
        f"above_ma20={above:.2f} slope={slope:.2f} inflow={inflow_ratio:.2f} "
        f"indices(dedup)={dedup_count} etfs(raw)={raw_count}"
        + (f" prev={previous_regime}" if previous_regime else "")
    )


if __name__ == "__main__":
    main()


