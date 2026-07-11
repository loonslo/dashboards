#!/usr/bin/env python3
"""Validate dashboard snapshots before a server refresh is published."""

import argparse
import datetime as dt
import json
import pathlib
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
INDEX_PATH = ROOT / "dashboards" / "index-decision" / "dashboard_latest.json"
SHORT_PATH = ROOT / "dashboards" / "short-flow" / "dashboard_latest.json"
ETF_PATH = ROOT / "dashboards" / "short-flow" / "etf_pool_latest.json"
REPORT_INDEX_PATH = ROOT / "dashboards" / "short-flow" / "reports_index.json"
VALID_SESSIONS = {"0850", "0940", "1130", "1430", "1520"}
# Backtest is considered complete once the 10d forward return is populated.
BACKTEST_MIN_TRADING_DAYS = 10


def load_json(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise ValueError(f"missing file: {path.relative_to(ROOT)}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON: {path.relative_to(ROOT)}: {exc}") from exc


def parse_timestamp(value, field):
    if not value:
        raise ValueError(f"missing timestamp: {field}")
    try:
        return dt.datetime.fromisoformat(str(value).replace("Z", "+00:00"))
    except ValueError as exc:
        raise ValueError(f"invalid timestamp {field}: {value}") from exc


def validate_trade_date(value, field):
    try:
        trade_date = dt.date.fromisoformat(value)
    except (TypeError, ValueError) as exc:
        raise ValueError(f"invalid trade date {field}: {value}") from exc
    if trade_date.weekday() >= 5:
        raise ValueError(f"weekend cannot be published as A-share trade date: {value}")
    return trade_date


def require_nonempty_list(payload, field, source):
    value = payload.get(field)
    if not isinstance(value, list) or not value:
        raise ValueError(f"{source}.{field} must be a non-empty list")


def validate_short_flow_date_consistency(index, short, etf):
    """Reject publications where trade_date, latest quote date, and generation
    date disagree — the core guard against labeling stale quotes as a new trade day."""
    short_date = validate_trade_date(short.get("trade_date"), "short-flow.trade_date")
    etf_date = validate_trade_date(etf.get("trade_date"), "etf-pool.trade_date")
    if short_date != etf_date:
        raise ValueError(f"latest dashboard dates differ: short-flow={short_date}, etf-pool={etf_date}")

    # The index-decision board and the short-flow board must describe the same
    # trade day; otherwise a weekend/holiday refresh would publish mismatched data.
    # The index board uses `asof` rather than `trade_date`, so compare only when
    # both boards expose a trade_date field.
    if index.get("trade_date") is not None:
        index_date = validate_trade_date(index.get("trade_date"), "index-decision.trade_date")
        if index_date != short_date:
            raise ValueError(
                f"cross-board trade dates differ: index-decision={index_date}, short-flow={short_date}"
            )

    # The most recent live snapshot must actually belong to the published trade_date.
    source = short.get("source_status") or {}
    latest_quote_date = source.get("latest_quote_date")
    if latest_quote_date and latest_quote_date != short_date.isoformat():
        raise ValueError(
            f"latest quote date {latest_quote_date} does not match published "
            f"trade_date {short_date.isoformat()}"
        )

    # Generation timestamp must be on/after the trade date (never in the future
    # relative to it) to catch mislabeled-stale-data publishing.
    generated = short.get("generated_at") or etf.get("generated_at")
    if generated:
        gen_ts = parse_timestamp(generated, "generated_at")
        if gen_ts.tzinfo is not None:
            gen_ts = gen_ts.astimezone().replace(tzinfo=None)
        if gen_ts.date() < short_date:
            raise ValueError(
                f"generated_at {gen_ts.date()} is before trade_date {short_date}"
            )
    return short_date


def validate_backtest_completeness(etf):
    """Flag any ETF report whose backtest window has closed but is still missing
    the 10d forward return, so an incomplete backtest never ships silently."""
    backtest = etf.get("backtest") or {}
    recent = backtest.get("recent") or []
    incomplete = [
        r for r in recent
        if r.get("signal_date")
        and r.get("hit_10d") is None
        and _is_backtest_window_closed(r.get("signal_date"))
    ]
    if incomplete:
        dates = ", ".join(sorted({r["signal_date"] for r in incomplete}))
        raise ValueError(
            f"backtest window closed but 10d return missing for signal dates: {dates}"
        )


def _is_backtest_window_closed(signal_date):
    try:
        start = dt.date.fromisoformat(signal_date)
    except (TypeError, ValueError):
        return False
    trading_days = 0
    cursor = start + dt.timedelta(days=1)
    today = dt.date.today()
    while cursor <= today:
        if cursor.weekday() < 5:
            trading_days += 1
        cursor += dt.timedelta(days=1)
    return trading_days >= BACKTEST_MIN_TRADING_DAYS


def validate(max_age_hours=None):
    index = load_json(INDEX_PATH)
    short = load_json(SHORT_PATH)
    etf = load_json(ETF_PATH)
    report_index = load_json(REPORT_INDEX_PATH)

    require_nonempty_list(index, "indices", "index-decision")
    require_nonempty_list(short, "market_flow", "short-flow")
    require_nonempty_list(short, "watch_signals", "short-flow")

    short_date = validate_short_flow_date_consistency(index, short, etf)
    if etf.get("session") not in VALID_SESSIONS:
        raise ValueError(f"invalid ETF report session: {etf.get('session')}")
    if etf.get("analysis_run_id") is None:
        raise ValueError("ETF report is missing analysis_run_id")

    source = short.get("source_status") or {}
    available_rows = int(source.get("live_rows") or 0) + int(source.get("stale_rows") or 0)
    if available_rows <= 0:
        raise ValueError("short-flow has no live or stale rows")

    validate_backtest_completeness(etf)

    reports = report_index.get("reports")
    if not isinstance(reports, list):
        raise ValueError("reports_index.reports must be a list")
    for relative in reports:
        path = ROOT / "dashboards" / "short-flow" / relative
        if not path.is_file():
            raise ValueError(f"reports_index references missing file: {relative}")

    if max_age_hours is not None:
        now = dt.datetime.now()
        timestamps = {
            "index-decision.asof": parse_timestamp(index.get("asof"), "index-decision.asof"),
            "short-flow.asof": parse_timestamp(short.get("asof"), "short-flow.asof"),
            "etf-pool.generated_at": parse_timestamp(etf.get("generated_at"), "etf-pool.generated_at"),
        }
        for field, timestamp in timestamps.items():
            if timestamp.tzinfo is not None:
                timestamp = timestamp.astimezone().replace(tzinfo=None)
            age = now - timestamp
            if age.total_seconds() < -300:
                raise ValueError(f"future timestamp detected: {field}={timestamp}")
            if age > dt.timedelta(hours=max_age_hours):
                raise ValueError(f"stale snapshot: {field} is {age} old")

    return {
        "trade_date": short_date.isoformat(),
        "session": etf["session"],
        "short_rows": len(short["market_flow"]) + len(short["watch_signals"]),
        "reports": len(reports),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-age-hours", type=float, default=None)
    args = parser.parse_args()
    try:
        result = validate(args.max_age_hours)
    except ValueError as exc:
        print(f"VALIDATION FAILED: {exc}", file=sys.stderr)
        return 1
    print("VALIDATION OK:", json.dumps(result, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
