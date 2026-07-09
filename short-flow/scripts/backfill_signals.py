"""回填历史信号：用日度历史数据重建~2年的策略信号，一次性获得
数千样本的 quintile/regime 分层统计功效。

数据源：
- 日K线：Tencent gtimg（与实时相同）
- 历史资金流：Eastmoney push2his 日度主力净流入
- ETF 列表：当前 etf_master 中 active 的 ETF（含存活者偏差，近两年影响小）

纪律：
- 写入独立表 backfill_result，不污染实盘 signal_result
- 回填口径=收盘版（1520场次），与盘中实盘口径分开统计
- 历史资金流(push2his)与实时 snapshot(push2delay)的"主力"口径
  需抽查核对——同一天两个接口数值对不上就不能混用
"""

import argparse
import datetime as dt
import statistics
import time
from collections import defaultdict

from _bootstrap import default_config_path, default_db_path
from short_flow.config import load_config
from short_flow.data_sources.eastmoney import (
    fetch_daily_klines, fetch_historical_flow, fetch_historical_klines,
)
from short_flow.db import connect, init_db, rows
from short_flow.rules.entry_patterns import classify_entry_pattern
from short_flow.rules.filters import hard_filter, score_direction
from short_flow.rules.regime import classify_regime


MIN_KLINES = 60  # need enough history for 20-day MA + forward returns
DEFAULT_DELAY_KLINES = 0.15   # seconds between kline requests
DEFAULT_DELAY_FLOW = 0.10     # seconds between flow requests


def tracking_index(name):
    """Same heuristic as compute_regime.py — strip fund-company suffix."""
    import re
    _RE = re.compile(
        r'(ETF|联接)?(华夏|易方达|南方|广发|富国|嘉实|博时|华泰柏瑞|'
        r'华安|天弘|国泰|招商|景顺长城|工银|银华|鹏华|万家|大成|'
        r'汇添富|海富通|建信|平安|泰康|兴全|中欧|交银|摩根|华宝|'
        r'方正|申万|中银|前海|永赢|国联安|西藏东财)?$'
    )
    return _RE.sub("", name or "").strip() or name


def mean(vals):
    v = [x for x in vals if x is not None]
    return sum(v) / len(v) if v else None


def ma(values, window):
    if len(values) < window:
        return None
    return mean(values[-window:])


def compute_etf_indicators(klines, flow_map):
    """For a single ETF, compute indicator rows for every date with complete data.

    Returns list of dicts, each containing date + indicator fields + flow fields.
    """
    if len(klines) < MIN_KLINES:
        return []
    closes = [r["close"] for r in klines]
    results = []
    for i in range(20, len(klines)):  # need at least 20 prior days
        k = klines[i]
        date = k["date"]
        close = k["close"]
        amount = k.get("amount")
        if close is None:
            continue

        # MAs
        ma5_val = ma(closes[i-4:i+1], 5)  # inclusive of current
        ma10_val = ma(closes[i-9:i+1], 10)
        ma20_val = ma(closes[i-19:i+1], 20)
        ma60_val = ma(closes[i-59:i+1], 60) if i >= 60 else None

        # MA20 slope: compare current MA20 to previous day's MA20
        prev_ma20 = ma(closes[i-20:i], 20) if i >= 21 else None

        # Amount ratios (using complete days, current is end-of-day for backfill)
        amt_window_5 = [r.get("amount") for r in klines[i-4:i] if r.get("amount") is not None]
        amt_window_20 = [r.get("amount") for r in klines[i-19:i] if r.get("amount") is not None]
        amt_avg_5 = mean(amt_window_5) if len(amt_window_5) >= 5 else None
        amt_avg_20 = mean(amt_window_20) if len(amt_window_20) >= 20 else None

        # Returns
        ret5 = (close / closes[i-5] - 1) * 100 if i >= 5 and closes[i-5] else None
        ret10 = (close / closes[i-10] - 1) * 100 if i >= 10 and closes[i-10] else None
        ret20 = (close / closes[i-20] - 1) * 100 if i >= 20 and closes[i-20] else None

        # Flow
        flow = flow_map.get(date, {})
        main_inflow = flow.get("main_net")
        main_inflow_pct = (main_inflow / amount * 100) if main_inflow is not None and amount not in (None, 0) else None
        pct = k.get("pct")

        results.append({
            "date": date,
            "close": close,
            "pct": pct,
            "amount": amount,
            "main_inflow": main_inflow,
            "main_inflow_pct": main_inflow_pct,
            "ma5": ma5_val, "ma10": ma10_val, "ma20": ma20_val, "ma60": ma60_val,
            "ret5": ret5, "ret10": ret10, "ret20": ret20,
            "amount_ratio_5": (amount / amt_avg_5) if amount is not None and amt_avg_5 else None,
            "amount_ratio_20": (amount / amt_avg_20) if amount is not None and amt_avg_20 else None,
            "above_ma5": 1 if ma5_val is not None and close >= ma5_val else 0,
            "above_ma10": 1 if ma10_val is not None and close >= ma10_val else 0,
            "above_ma20": 1 if ma20_val is not None and close >= ma20_val else 0,
            "ma20_slope_positive": 1 if ma20_val is not None and prev_ma20 is not None and ma20_val > prev_ma20 else 0,
            "kline_idx": i,  # for forward-return lookup
        })
    return results


def fetch_etf_data(code, flow_limit=500, delay_kline=0.15, delay_flow=0.10,
                    kline_source="auto"):
    """Fetch klines + flow for one ETF sequentially, with pacing.

    kline_source: "tencent" | "eastmoney" | "auto"
      - "auto": try Tencent first, fall back to Eastmoney if blocked.
    """
    klines = None
    kline_error = None
    kline_src_used = None

    # ── Klines ──
    if kline_source in ("auto", "tencent"):
        try:
            klines = fetch_daily_klines(code, flow_limit + 30)
            kline_src_used = "tencent"
        except Exception as exc:
            kline_error = exc
        if delay_kline:
            time.sleep(delay_kline)

    if klines is None and kline_source in ("auto", "eastmoney"):
        try:
            klines = fetch_historical_klines(code, flow_limit + 30)
            kline_src_used = "eastmoney"
        except Exception:
            pass
        if delay_kline:
            time.sleep(delay_kline)

    if not klines or len(klines) < MIN_KLINES:
        return None, None, None

    # ── Flow ──
    flow_rows = None
    try:
        flow_rows = fetch_historical_flow(code, flow_limit)
    except Exception:
        pass
    if delay_flow:
        time.sleep(delay_flow)

    if not flow_rows:
        return None, None, None

    flow_map = {r["date"]: r for r in flow_rows}
    indicators = compute_etf_indicators(klines, flow_map)
    return klines, flow_map, indicators


def backfill(config, db_path, days=500, delay_kline=0.15, delay_flow=0.10,
             kline_source="auto"):
    """Main backfill routine. Processes ETFs sequentially to avoid rate limits."""
    init_db(db_path)
    cfg = load_config(config)

    with connect(db_path) as conn:
        etfs = rows(conn, """
            SELECT code, name, category FROM etf_master
            WHERE status='active' AND is_money=0 AND is_bond=0
            ORDER BY code
        """)
        print(f"ETFs to backfill: {len(etfs)}")
        print(f"Kline source: {kline_source}, delays: kline={delay_kline}s flow={delay_flow}s")

        # ── Step 1: Sequential fetch ──
        all_indicators = {}
        all_klines = {}
        success = 0
        fail = 0
        fail_tencent = 0
        fail_eastmoney = 0
        kline_via_eastmoney = 0
        t0 = time.time()

        for i, etf in enumerate(etfs):
            code = etf["code"]
            try:
                klines, flow_map, indicators = fetch_etf_data(
                    code, days, delay_kline=delay_kline, delay_flow=delay_flow,
                    kline_source=kline_source,
                )
                if indicators:
                    all_indicators[code] = indicators
                    all_klines[code] = klines
                    success += 1
                    # Track which source was used
                    if klines[0].get("_src") == "eastmoney":
                        kline_via_eastmoney += 1
                else:
                    fail += 1
            except Exception:
                fail += 1

            if (i + 1) % 100 == 0:
                elapsed = time.time() - t0
                rate = (i + 1) / elapsed
                eta = (len(etfs) - i - 1) / rate / 60 if rate > 0 else 0
                print(f"  {i+1}/{len(etfs)} (ok={success} fail={fail}) "
                      f"[{elapsed:.0f}s, ETA {eta:.0f}m]")

        elapsed = time.time() - t0
        print(f"Fetch complete: {success}/{len(etfs)} OK, {fail} failed "
              f"[{elapsed:.0f}s]" + (f", eastmoney fallback: {kline_via_eastmoney}" if kline_via_eastmoney else ""))

        if success == 0:
            print("No ETF data available, aborting.")
            return

        # ── Step 2: Collect all dates and compute regime per date ──
        # Build date -> list of (code, indicator_row)
        date_rows = defaultdict(list)
        for code, indicators in all_indicators.items():
            for row in indicators:
                date_rows[row["date"]].append((code, row))

        all_dates = sorted(date_rows.keys())
        # Keep only dates within last `days` days
        if days and len(all_dates) > days:
            all_dates = all_dates[-days:]
        print(f"Trading dates with data: {len(all_dates)}")

        # Compute regime per date (with tracking-index dedup + hysteresis)
        regime_map = {}
        prev_regime = None
        etf_names = {e["code"]: e["name"] for e in etfs}
        for date in all_dates:
            pairs = date_rows.get(date, [])
            # Dedup by tracking index
            seen_idx = {}
            for code, row in pairs:
                idx = tracking_index(etf_names.get(code, ""))
                if idx not in seen_idx:
                    seen_idx[idx] = row
            deduped = list(seen_idx.values())
            if not deduped:
                continue
            above = mean([r["above_ma20"] for r in deduped]) or 0
            slope = mean([r["ma20_slope_positive"] for r in deduped]) or 0
            inflow_pos = mean([1.0 if (r.get("main_inflow") or 0) > 0 else 0.0 for r in deduped]) or 0
            regime = classify_regime(above, slope, inflow_pos, previous_regime=prev_regime)
            regime_map[date] = {"regime": regime, "above_ma20": above, "slope": slope, "inflow": inflow_pos}
            prev_regime = regime

        print(f"Regimes computed for {len(regime_map)} dates")

        # ── Step 3: Compute signals + forward returns + insert ──
        conn.execute("DELETE FROM backfill_result WHERE source='backfill'")
        insert_count = 0
        now = dt.datetime.now().strftime("%Y-%m-%d %H:%M")

        for date in all_dates:
            regime_info = regime_map.get(date, {})
            regime = regime_info.get("regime", "UNKNOWN")
            pairs = date_rows.get(date, [])
            if not pairs:
                continue

            for code, ind in pairs:
                # Build snapshot-like dict for hard_filter
                snap = {
                    "amount": ind.get("amount"),
                    "main_inflow": ind.get("main_inflow"),
                    "main_inflow_pct": ind.get("main_inflow_pct"),
                    "pct": ind.get("pct"),
                }
                # Build indicator-like dict
                indicator = {
                    "above_ma5": ind.get("above_ma5"),
                    "above_ma10": ind.get("above_ma10"),
                    "above_ma20": ind.get("above_ma20"),
                    "ma20_slope_positive": ind.get("ma20_slope_positive"),
                    "ret20": ind.get("ret20"),
                    "amount_ratio_20": ind.get("amount_ratio_20"),
                }
                master = {"category": etf_names.get(code, "")}

                pattern = classify_entry_pattern(indicator)
                rule, reason = hard_filter(master, snap, indicator, cfg, entry_pattern=pattern)
                score = score_direction(snap, indicator)

                if rule != "candidate":
                    continue

                # Forward returns
                klines = all_klines.get(code)
                k_idx = ind.get("kline_idx")
                if klines is None or k_idx is None:
                    continue

                close_price = ind["close"]
                def _fwd(offset):
                    idx = k_idx + offset
                    if 0 <= idx < len(klines):
                        return klines[idx]
                    return None

                def _ret(fwd_price, base):
                    if fwd_price is None or base in (None, 0):
                        return None
                    return round((fwd_price / base - 1) * 100, 2)

                d1 = _fwd(1)
                d5 = _fwd(5)
                d10 = _fwd(10)
                d20 = _fwd(20)

                conn.execute("""
                    INSERT INTO backfill_result (
                      signal_date, code, name, regime, score, rule_result, reason,
                      pct, amount, main_inflow, main_inflow_pct, amount_ratio_20,
                      close_price, next_open, next_close,
                      return_1d_open, return_1d_close, return_5d, return_10d, return_20d,
                      hit_1d, hit_5d, hit_10d, hit_20d,
                      source, computed_at
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    date, code, etf_names.get(code, ""), regime, score, rule,
                    f"{reason}；{pattern}",
                    ind.get("pct"), ind.get("amount"), ind.get("main_inflow"),
                    ind.get("main_inflow_pct"), ind.get("amount_ratio_20"),
                    close_price,
                    d1["open"] if d1 else None, d1["close"] if d1 else None,
                    _ret(d1["open"] if d1 else None, close_price),
                    _ret(d1["close"] if d1 else None, close_price),
                    _ret(d5["close"] if d5 else None, close_price),
                    _ret(d10["close"] if d10 else None, close_price),
                    _ret(d20["close"] if d20 else None, close_price),
                    1 if (_ret(d1["close"] if d1 else None, close_price) or 0) > 0 else 0,
                    1 if (_ret(d5["close"] if d5 else None, close_price) or 0) > 0 else 0,
                    1 if (_ret(d10["close"] if d10 else None, close_price) or 0) > 0 else 0,
                    1 if (_ret(d20["close"] if d20 else None, close_price) or 0) > 0 else 0,
                    "backfill", now,
                ))
                insert_count += 1

        conn.commit()
        print(f"Inserted {insert_count} candidate signals into backfill_result")

        # ── Step 4: Summary ──
        return compute_backfill_summary(conn)


def compute_backfill_summary(conn):
    """Compute quintile + regime-stratified stats from backfill_result."""
    rows_data = rows(conn, """
        SELECT * FROM backfill_result
        WHERE source='backfill' AND hit_1d IS NOT NULL
        ORDER BY signal_date DESC
    """)
    if not rows_data:
        print("No backfill results to summarize.")
        return

    def _mean(vals):
        v = [x for x in vals if x is not None]
        return sum(v) / len(v) if v else None

    def _std(vals):
        v = [x for x in vals if x is not None]
        if len(v) < 2:
            return None
        m = sum(v) / len(v)
        return (sum((x - m) ** 2 for x in v) / (len(v) - 1)) ** 0.5

    def _win(hits):
        valid = [h for h in hits if h is not None]
        return sum(valid) / len(valid) if valid else None

    total = len(rows_data)
    print(f"\n=== 回填信号摘要 ({total} 个候选信号) ===")
    print(f"整体: 5日均收益 {_mean([r['return_5d'] for r in rows_data]):+.2f}%  "
          f"5日胜率 {_win([r['hit_5d'] for r in rows_data]):.1%}  "
          f"10日均收益 {_mean([r['return_10d'] for r in rows_data]):+.2f}%")

    # ── Regime-stratified ──
    by_regime = defaultdict(list)
    for r in rows_data:
        by_regime[r["regime"] or "UNKNOWN"].append(r)
    print("\n--- 按 regime 分层 ---")
    for reg in sorted(by_regime.keys()):
        items = by_regime[reg]
        print(f"  {reg}: n={len(items)}  5d_avg={_mean([r['return_5d'] for r in items]):+.2f}%  "
              f"5d_win={_win([r['hit_5d'] for r in items]):.1%}")

    # ── Score quintile (5d-based, with significance) ──
    MIN_N = 30
    FIXED_PCT = 0.5
    if total >= 100:
        sorted_by_score = sorted(rows_data, key=lambda r: r["score"] or 0)
        n = total
        print("\n--- score 分位数分层 (Q1=最低分, Q5=最高分, 5日收益为准) ---")
        for q in range(5):
            start = q * n // 5
            end = (q + 1) * n // 5
            group = sorted_by_score[start:end]
            rets = [r["return_5d"] for r in group if r["return_5d"] is not None]
            avg5 = round(_mean(rets), 2) if rets else None
            std5 = round(_std(rets), 2) if len(rets) >= 2 else None
            sr = f"{group[0]['score']:.0f}-{group[-1]['score']:.0f}"
            std_str = f" ±{std5:.1f}%" if std5 else ""
            print(f"  Q{q+1} [{sr}]: n={len(group)}  5d={avg5:+.2f}%{std_str}  "
                  f"5d_win={_win([r['hit_5d'] for r in group]):.1%}")

        # Q5 vs Q1 significance
        q1g = sorted_by_score[:n//5]
        q5g = sorted_by_score[4*n//5:]
        n1, n5 = len(q1g), len(q5g)
        a1, a5 = _mean([r["return_5d"] for r in q1g if r["return_5d"] is not None]), \
                  _mean([r["return_5d"] for r in q5g if r["return_5d"] is not None])
        s1, s5 = _std([r["return_5d"] for r in q1g if r["return_5d"] is not None]), \
                  _std([r["return_5d"] for r in q5g if r["return_5d"] is not None])
        diff = a5 - a1 if a5 is not None and a1 is not None else None

        if diff is not None:
            print()
            if n1 < MIN_N or n5 < MIN_N:
                print(f"  ⏳ 样本不足 (Q1={n1}, Q5={n5}，各需≥{MIN_N})")
            elif s1 and s5:
                se = (s1**2/n1 + s5**2/n5) ** 0.5
                if abs(diff) > 2 * se:
                    tag = "⚠ 追涨偏差(显著)" if diff < 0 else "✓ 趋势跟随(显著)"
                    print(f"  {tag}: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} > 2×SE={2*se:.2f}")
                elif abs(diff) >= FIXED_PCT:
                    tag = "⚠ 追涨偏差(弱)" if diff < 0 else "✓ 趋势跟随(弱)"
                    print(f"  {tag}: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} < 2×SE={2*se:.2f} 但 ≥{FIXED_PCT}pct")
                else:
                    print(f"  — inconclusive: Q5-Q1={diff:+.2f}%, |diff|={abs(diff):.2f} < 2×SE={2*se:.2f} 且 <{FIXED_PCT}pct")

    # ── Score quintile × regime ──
    if total >= 200:
        print("\n--- 按 regime 分层的 score 分位数 (5d) ---")
        for reg in sorted(by_regime.keys()):
            items = by_regime[reg]
            if len(items) < 100:
                continue
            sorted_items = sorted(items, key=lambda r: r["score"] or 0)
            n = len(sorted_items)
            q1 = sorted_items[:n//5]
            q5 = sorted_items[4*n//5:]
            a1 = _mean([r["return_5d"] for r in q1 if r["return_5d"] is not None])
            a5 = _mean([r["return_5d"] for r in q5 if r["return_5d"] is not None])
            if a1 is not None and a5 is not None:
                d = a5 - a1
                tag = "⚠ 追涨偏差" if d < 0 else "✓ 趋势跟随"
                print(f"  {reg}: Q1={a1:+.2f}% Q5={a5:+.2f}% diff={d:+.2f}%  {tag}")


def main():
    parser = argparse.ArgumentParser(description="Backfill historical signals for statistical power")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--config", default=str(default_config_path()))
    parser.add_argument("--days", type=int, default=500,
                        help="Number of calendar days to backfill (default 500)")
    parser.add_argument("--delay-kline", type=float, default=DEFAULT_DELAY_KLINES,
                        help=f"Seconds between kline requests (default {DEFAULT_DELAY_KLINES})")
    parser.add_argument("--delay-flow", type=float, default=DEFAULT_DELAY_FLOW,
                        help=f"Seconds between flow requests (default {DEFAULT_DELAY_FLOW})")
    parser.add_argument("--kline-source", default="auto",
                        choices=["auto", "tencent", "eastmoney"],
                        help="Kline data source (auto=try Tencent first, fallback to Eastmoney)")
    parser.add_argument("--summary-only", action="store_true",
                        help="Only print summary from existing backfill data")
    args = parser.parse_args()

    if args.summary_only:
        init_db(args.db)
        with connect(args.db) as conn:
            compute_backfill_summary(conn)
        return

    print(f"Backfilling ~{args.days} days of historical signals...")
    t0 = time.time()
    backfill(args.config, args.db, days=args.days,
             delay_kline=args.delay_kline, delay_flow=args.delay_flow,
             kline_source=args.kline_source)
    elapsed = time.time() - t0
    print(f"\nDone in {elapsed:.0f}s ({elapsed/60:.1f}m)")


if __name__ == "__main__":
    main()
