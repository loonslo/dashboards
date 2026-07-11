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

# Real exchange trade dates are needed to judge holding horizons correctly.
# Using wall-clock calendar days (e.g. 14 natural days ≈ 10 trading days)
# is inaccurate across weekends/holidays and silently drops signals whose
# forward window spans a holiday. We therefore derive the horizon from the
# actual k-line trade-date sequence.
BACKTEST_HORIZON_DAYS = 10
# A signal is only backtestable once at least this many *trading* days have
# elapsed, so the 10d forward return is observable.
MIN_TRADING_DAYS_BEFORE_BACKTEST = BACKTEST_HORIZON_DAYS


def mean(values):
    values = [v for v in values if v is not None]
    return statistics.fmean(values) if values else None


def win_rate(hits):
    if not hits:
        return None
    valid = [h for h in hits if h is not None]
    return sum(valid) / len(valid) if valid else None


def trading_days_since(conn, trade_date):
    """Count exchange trading days from trade_date up to today (exclusive).

    Derived from the persisted etf_indicator / signal_result trade dates so it
    stays correct across weekends and holidays. Falls back to the calendar-day
    gap when no trade-date history is available.
    """
    rows_dates = rows(conn, """
        SELECT DISTINCT trade_date FROM (
          SELECT trade_date FROM etf_indicator
          UNION
          SELECT trade_date FROM signal_result
        ) WHERE trade_date > ?
        ORDER BY trade_date
    """, (trade_date,))
    if rows_dates:
        return len(rows_dates)
    # Fallback: trading days ≈ calendar days excluding weekends.
    try:
        start = dt.date.fromisoformat(trade_date)
    except (TypeError, ValueError):
        return 0
    days = 0
    cursor = start + dt.timedelta(days=1)
    today = dt.date.today()
    while cursor <= today:
        if cursor.weekday() < 5:
            days += 1
        cursor += dt.timedelta(days=1)
    return days


def signal_dates_to_backtest(conn):
    """Return distinct trade_dates from signal_result that haven't been fully backtested yet.

    A date is eligible only once at least BACKTEST_HORIZON_DAYS *trading* days
    have passed (so the 10d forward return is observable). Partial backtest
    rows (missing 5d/10d) are re-enqueued so they get incrementally completed.
    """
    candidate_dates = rows(conn, """
        SELECT DISTINCT sr.trade_date
        FROM signal_result sr
        WHERE sr.rule_result = 'candidate'
        ORDER BY sr.trade_date
    """)
    eligible = []
    for row in candidate_dates:
        trade_date = row["trade_date"]
        if trading_days_since(conn, trade_date) < MIN_TRADING_DAYS_BEFORE_BACKTEST:
            continue
        # Skip only if EVERY candidate signal for that date already has a
        # complete 10d result. Otherwise keep it for incremental completion.
        incomplete = rows(conn, """
            SELECT 1
            FROM signal_result candidate
            WHERE candidate.trade_date=?
              AND candidate.rule_result='candidate'
              AND NOT EXISTS (
                SELECT 1 FROM backtest_result bt
                WHERE bt.signal_date=candidate.trade_date
                  AND bt.code=candidate.code
                  AND bt.hit_10d IS NOT NULL
              )
            LIMIT 1
        """, (trade_date,))
        if incomplete:
            eligible.append(trade_date)
    return eligible


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
    """Run backtest for all Focus watch signals on a single date.

    Supports incremental completion: if a backtest_result row already exists
    but is missing its 5d/10d returns (because the forward window was not yet
    complete on a previous run), the row is updated in place instead of being
    blindly overwritten or skipped.
    """
    signals = rows(conn, """
        SELECT sr.* FROM signal_result sr
        WHERE sr.trade_date=? AND sr.rule_result='candidate'
          AND sr.id=(
            SELECT chosen.id FROM signal_result chosen
            WHERE chosen.trade_date=sr.trade_date
              AND chosen.code=sr.code
              AND chosen.rule_result='candidate'
            ORDER BY CASE chosen.session_name
              WHEN '1520' THEN 0 WHEN '1430' THEN 1 WHEN '1130' THEN 2
              WHEN '0940' THEN 3 WHEN '0850' THEN 4 ELSE 5 END,
              chosen.id DESC
            LIMIT 1
          )
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

        # Look for an existing (possibly partial) row to complete.
        existing = conn.execute(
            "SELECT id, hit_10d FROM backtest_result WHERE signal_date=? AND code=?",
            (trade_date, sig["code"]),
        ).fetchone()

        if existing is None:
            conn.execute("""
                INSERT INTO backtest_result (
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
        elif existing["hit_10d"] is None and (
            fwd.get("return_5d") is not None or fwd.get("return_10d") is not None
        ):
            # Partial row: fill in whatever forward returns are now available.
            conn.execute("""
                UPDATE backtest_result SET
                  regime=?, score=?, rule_result=?, reason=?,
                  return_5d=?, return_10d=?, hit_5d=?, hit_10d=?, computed_at=?
                WHERE id=?
            """, (
                regime, sig["score"], sig["rule_result"], sig["reason"],
                fwd.get("return_5d"), fwd.get("return_10d"),
                fwd.get("hit_5d"), fwd.get("hit_10d"),
                now, existing["id"],
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

    # v0.2: score quintile breakdown — quantitatively answers whether
    # score_direction (which heavily weights daily return) is a
    # trend-following factor or just a chasing bias.
    # Uses 5d returns as the primary horizon (matches max_hold_days=20);
    # 1d is reference-only because A-share daily-chasing + next-day reversal
    # is a known pattern that can give opposite signals.
    MIN_QUINTILE_SAMPLES = 30
    FIXED_DIFF_THRESHOLD = 0.5  # 5d return difference in pct points
    by_score_quintile = {}
    if len(all_results) >= 20:
        sorted_by_score = sorted(all_results, key=lambda r: r["score"] or 0)
        n = len(sorted_by_score)
        for q in range(5):
            start = q * n // 5
            end = (q + 1) * n // 5
            group = sorted_by_score[start:end]
            if not group:
                continue
            rets_5d = [r["return_5d"] for r in group if r["return_5d"] is not None]
            rets_1d = [r["return_1d_close"] for r in group if r["return_1d_close"] is not None]
            score_range = f"{group[0]['score']:.0f}-{group[-1]['score']:.0f}"
            by_score_quintile[f"Q{q+1}"] = {
                "score_range": score_range,
                "count": len(group),
                "avg_return_5d": round(mean(rets_5d), 2) if rets_5d else None,
                "std_return_5d": round(statistics.stdev(rets_5d), 2) if len(rets_5d) >= 2 else None,
                "win_rate_5d": round(win_rate([r["hit_5d"] for r in group]), 3),
                "avg_return_1d": round(mean(rets_1d), 2) if rets_1d else None,
            }

    return {
        "total_signals": len(all_results),
        "overall": overall,
        "by_regime": regime_summaries,
        "by_score_quintile": by_score_quintile,
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

    quintiles = summary.get("by_score_quintile", {})
    if quintiles:
        print()
        print("--- score 分位数分层 (Q1=最低分, Q5=最高分, 以5日收益为准) ---")
        for q in sorted(quintiles.keys()):
            qt = quintiles[q]
            std_str = f" ±{qt['std_return_5d']:.1f}%" if qt.get("std_return_5d") is not None else ""
            print(f"  {q} [{qt['score_range']}]: n={qt['count']} "
                  f"5d={qt['avg_return_5d']:+.2f}%{std_str} "
                  f"5d_win={qt['win_rate_5d']:.1%} "
                  f"(1d_ref={qt['avg_return_1d']:+.2f}%)")
        # 显著性检验：|Q5-Q1| > 2×pooled SE (p≈0.05)。
        # 以 5 日收益为准——1d 只做参考（A 股当日追涨次日反转是常态）。
        MIN_N = 30
        FIXED_PCT = 0.5
        q1 = quintiles.get("Q1", {})
        q5 = quintiles.get("Q5", {})
        n1, n5 = q1.get("count", 0), q5.get("count", 0)
        a1, a5 = q1.get("avg_return_5d"), q5.get("avg_return_5d")
        s1, s5 = q1.get("std_return_5d"), q5.get("std_return_5d")
        if a1 is not None and a5 is not None:
            diff = a5 - a1
            if n1 < MIN_N or n5 < MIN_N:
                print(f"  ⏳ 样本不足 (Q1={n1}, Q5={n5}，各需≥{MIN_N})，暂不判断")
            elif s1 is not None and s5 is not None:
                # Pooled standard error
                se = (s1**2 / n1 + s5**2 / n5) ** 0.5
                if abs(diff) > 2 * se:
                    tag = "⚠ 追涨偏差(显著)" if diff < 0 else "✓ 趋势跟随(显著)"
                    print(f"  {tag}: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} > 2×SE={2*se:.2f}")
                elif abs(diff) >= FIXED_PCT:
                    tag = "⚠ 追涨偏差(弱)" if diff < 0 else "✓ 趋势跟随(弱)"
                    print(f"  {tag}: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} < 2×SE={2*se:.2f} 但 ≥{FIXED_PCT}pct 固定门槛")
                else:
                    print(f"  — inconclusive: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} < 2×SE={2*se:.2f} 且 <{FIXED_PCT}pct")
            elif abs(diff) >= FIXED_PCT:
                tag = "⚠ 追涨偏差(固定门槛)" if diff < 0 else "✓ 趋势跟随(固定门槛)"
                print(f"  {tag}: Q5-Q1={diff:+.2f}% ≥{FIXED_PCT}pct (SE不可用)")
            else:
                print(f"  — inconclusive: Q5-Q1={diff:+.2f}% <{FIXED_PCT}pct (SE不可用)")

    return summary


if __name__ == "__main__":
    summary = main()
