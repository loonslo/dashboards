"""回测模块：对历史 Focus watch 信号计算后续实际收益。

在每日 1520 session 收盘后运行，回溯当天及历史所有未回测的信号。
结果写入 backtest_result 表，并导出摘要到 dashboard JSON。
"""

import argparse
import datetime as dt
import statistics

from _bootstrap import default_db_path
from short_flow.data_sources.eastmoney import fetch_daily_klines
from short_flow.db import connect, init_db, rows


def mean(values):
    values = [v for v in values if v is not None]
    return statistics.fmean(values) if values else None


def win_rate(hits):
    if not hits:
        return None
    valid = [h for h in hits if h is not None]
    return sum(valid) / len(valid) if valid else None


def signal_dates_to_backtest(conn):
    """Return distinct trade_dates from signal_result that haven't been backtested yet.

    Only backtest dates at least 10 days in the past so forward returns are available.
    """
    cutoff = (dt.date.today() - dt.timedelta(days=14)).isoformat()
    dates = rows(conn, """
        SELECT DISTINCT sr.trade_date
        FROM signal_result sr
        WHERE sr.rule_result = 'candidate'
          AND sr.trade_date <= ?
          AND sr.trade_date NOT IN (
            SELECT DISTINCT signal_date FROM backtest_result
          )
        ORDER BY sr.trade_date
    """, (cutoff,))
    return [r["trade_date"] for r in dates]


def regime_for_date(conn, trade_date):
    row = conn.execute(
        "SELECT regime FROM market_regime WHERE trade_date=?", (trade_date,)
    ).fetchone()
    return row["regime"] if row else "UNKNOWN"


def forward_returns(code, signal_date, horizons=(1, 5, 10)):
    """Fetch klines and compute forward returns from signal_date.

    Returns dict with next_open, next_close, and returns at each horizon.
    All returns in percentage points (e.g. 2.5 means +2.5%).
    """
    try:
        klines = fetch_daily_klines(code, 120)
    except Exception:
        return {}

    if not klines:
        return {}

    # Locate the signal_date bar
    signal_idx = None
    for i, bar in enumerate(klines):
        if bar["date"] == signal_date:
            signal_idx = i
            break

    if signal_idx is None:
        return {}

    signal_bar = klines[signal_idx]
    result = {"close_price": signal_bar.get("close")}

    # Next-day open/close (index + 1)
    if signal_idx + 1 < len(klines):
        next_bar = klines[signal_idx + 1]
        result["next_open"] = next_bar.get("open")
        result["next_close"] = next_bar.get("close")
        if result["close_price"] and result["close_price"] != 0:
            result["return_1d_open"] = (
                (result["next_open"] / result["close_price"] - 1) * 100
                if result["next_open"] else None
            )
            result["return_1d_close"] = (
                (result["next_close"] / result["close_price"] - 1) * 100
                if result["next_close"] else None
            )
        result["hit_1d"] = (
            1 if result["return_1d_close"] is not None and result["return_1d_close"] > 0
            else 0 if result["return_1d_close"] is not None else None
        )

    # N-day forward (signal_idx + horizon)
    for h in horizons:
        if h == 1:
            continue  # already handled above
        if signal_idx + h < len(klines):
            fwd_close = klines[signal_idx + h].get("close")
            if result["close_price"] and result["close_price"] != 0 and fwd_close:
                result[f"return_{h}d"] = (fwd_close / result["close_price"] - 1) * 100
                result[f"hit_{h}d"] = 1 if result[f"return_{h}d"] > 0 else 0
            else:
                result[f"return_{h}d"] = None
                result[f"hit_{h}d"] = None
        else:
            result[f"return_{h}d"] = None
            result[f"hit_{h}d"] = None

    return result


def backtest_date(conn, trade_date):
    """Run backtest for all Focus watch signals on a single date."""
    signals = rows(conn, """
        SELECT * FROM signal_result
        WHERE trade_date=? AND rule_result='candidate'
        ORDER BY score DESC
    """, (trade_date,))

    if not signals:
        return 0

    regime = regime_for_date(conn, trade_date)
    now = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    count = 0

    for sig in signals:
        fwd = forward_returns(sig["code"], trade_date)
        if not fwd or fwd.get("close_price") is None:
            continue

        conn.execute("""
            INSERT OR REPLACE INTO backtest_result (
              signal_date, code, name, regime, score, rule_result, reason,
              close_price, next_open, next_close,
              return_1d_open, return_1d_close, return_5d, return_10d,
              hit_1d, hit_5d, hit_10d, computed_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            trade_date, sig["code"], sig["name"], regime,
            sig["score"], sig["rule_result"], sig["reason"],
            fwd["close_price"],
            fwd.get("next_open"), fwd.get("next_close"),
            fwd.get("return_1d_open"), fwd.get("return_1d_close"),
            fwd.get("return_5d"), fwd.get("return_10d"),
            fwd.get("hit_1d"), fwd.get("hit_5d"), fwd.get("hit_10d"),
            now,
        ))
        count += 1

    return count


def compute_summary(conn):
    """Compute aggregate backtest statistics grouped by regime."""
    all_results = rows(conn, """
        SELECT * FROM backtest_result
        WHERE hit_1d IS NOT NULL
        ORDER BY signal_date DESC
    """)

    if not all_results:
        return {"total_signals": 0, "by_regime": {}, "recent": []}

    def regime_stats(subset):
        if not subset:
            return None
        return {
            "count": len(subset),
            "avg_score": mean([r["score"] for r in subset]),
            "win_rate_1d": win_rate([r["hit_1d"] for r in subset]),
            "avg_return_1d": mean([r["return_1d_close"] for r in subset]),
            "win_rate_5d": win_rate([r["hit_5d"] for r in subset]),
            "avg_return_5d": mean([r["return_5d"] for r in subset]),
            "win_rate_10d": win_rate([r["hit_10d"] for r in subset]),
            "avg_return_10d": mean([r["return_10d"] for r in subset]),
        }

    by_regime = {}
    for r in all_results:
        reg = r["regime"] or "UNKNOWN"
        by_regime.setdefault(reg, []).append(r)

    regime_summaries = {
        reg: regime_stats(items)
        for reg, items in by_regime.items()
    }

    overall = regime_stats(all_results)

    # Recent signals (last 20 trading days of backtest data)
    recent_dates = sorted(set(r["signal_date"] for r in all_results), reverse=True)[:20]
    recent = [
        {
            "signal_date": r["signal_date"],
            "code": r["code"],
            "name": r["name"],
            "regime": r["regime"],
            "score": r["score"],
            "return_1d": round(r["return_1d_close"], 2) if r["return_1d_close"] is not None else None,
            "return_5d": round(r["return_5d"], 2) if r["return_5d"] is not None else None,
            "hit_1d": r["hit_1d"],
            "hit_5d": r["hit_5d"],
        }
        for r in all_results
        if r["signal_date"] in recent_dates
    ][:30]

    return {
        "total_signals": len(all_results),
        "overall": overall,
        "by_regime": regime_summaries,
        "recent": recent,
    }


def main():
    parser = argparse.ArgumentParser(description="Backtest historical Focus watch signals")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--summary-only", action="store_true",
                        help="Only compute summary from existing backtest data")
    args = parser.parse_args()

    init_db(args.db)

    with connect(args.db) as conn:
        if not args.summary_only:
            dates = signal_dates_to_backtest(conn)
            total = 0
            for d in dates:
                n = backtest_date(conn, d)
                total += n
            conn.commit()
            if dates:
                print(f"backtested {total} signals across {len(dates)} dates")
            else:
                print("no new signals to backtest")

        summary = compute_summary(conn)

    # Print summary
    print()
    print(f"=== 回测摘要 ({summary['total_signals']} 个历史信号) ===")
    overall = summary.get("overall")
    if overall:
        print(f"整体: 1日胜率 {overall['win_rate_1d']:.1%} / 5日胜率 {overall['win_rate_5d']:.1%} / 10日胜率 {overall['win_rate_10d']:.1%}" if overall else "")
        print(f"整体: 1日均收益 {overall['avg_return_1d']:+.2f}% / 5日均收益 {overall['avg_return_5d']:+.2f}%" if overall else "")

    for reg, stats in summary.get("by_regime", {}).items():
        if stats:
            print(f"  {reg}: 信号{stats['count']}个, 5日胜率{stats['win_rate_5d']:.1%}, 5日均收益{stats['avg_return_5d']:+.2f}%")

    return summary


if __name__ == "__main__":
    summary = main()
