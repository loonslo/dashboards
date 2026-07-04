import argparse
import datetime as dt
import json
import pathlib

from _bootstrap import REPO_ROOT, default_config_path, default_db_path
from short_flow.config import load_config
from short_flow.db import connect, init_db, rows
from short_flow.rules.exit_rules import build_exit_queue
from short_flow.rules.regime import permission_for
from short_flow.reports.markdown import decision_markdown
from short_flow.reports.json_report import write_json


SESSION_LABELS = {
    "0850": "08:50 盘前计划",
    "0940": "09:40 盘中确认",
    "1130": "11:30 午间复核",
    "1430": "14:30 尾盘观察",
    "1520": "15:20 盘后选池",
}


def latest_trade_date(conn):
    row = conn.execute("SELECT MAX(trade_date) AS d FROM signal_result").fetchone()
    return row["d"] if row and row["d"] else None


def signal_items(conn, trade_date, rule_result, limit):
    return rows(
        conn,
        """
        SELECT sr.*, s.price, s.pct, s.amount, s.main_inflow, s.main_inflow_pct,
               i.ma5, i.ma10, i.ma20, i.amount_ratio_20
        FROM signal_result sr
        LEFT JOIN (
          SELECT s1.* FROM etf_snapshot s1
          JOIN (
            SELECT code, trade_date, MAX(id) AS id FROM etf_snapshot GROUP BY code, trade_date
          ) latest ON latest.id=s1.id
        ) s ON s.code=sr.code AND s.trade_date=sr.trade_date
        LEFT JOIN etf_indicator i ON i.code=sr.code AND i.trade_date=sr.trade_date
        WHERE sr.trade_date=? AND sr.rule_result=?
        ORDER BY sr.score DESC
        LIMIT ?
        """,
        (trade_date, rule_result, limit),
    )


def normalize(item):
    return {
        "code": item["code"],
        "name": item["name"],
        "category": item["group_name"],
        "score": item["score"],
        "price": item.get("price"),
        "pct": item.get("pct"),
        "main_inflow": item.get("main_inflow"),
        "main_inflow_pct": item.get("main_inflow_pct"),
        "ma5": item.get("ma5"),
        "ma10": item.get("ma10"),
        "ma20": item.get("ma20"),
        "amount_ratio_20": item.get("amount_ratio_20"),
        "reason": item["reason"],
        "trigger": item["entry_trigger"],
        "failure": item["failure_condition"],
        "suggested_action": "observe_only_or_first_1_3" if item["rule_result"] == "candidate" else "observe_only",
    }


def latest_analysis_run_id(conn, trade_date, session):
    row = conn.execute(
        "SELECT MAX(id) AS id FROM analysis_run WHERE trade_date=? AND session_name=?",
        (trade_date, session),
    ).fetchone()
    return row["id"] if row and row["id"] else None


def build_report(conn, config, session):
    trade_date = latest_trade_date(conn)
    if not trade_date:
        raise SystemExit("No signals to export")
    regime = conn.execute("SELECT * FROM market_regime WHERE trade_date=?", (trade_date,)).fetchone()
    regime_row = dict(regime) if regime else {"trade_date": trade_date, "regime": "RANGE"}
    permission = permission_for(regime_row["regime"], config)
    focus = [normalize(item) for item in signal_items(conn, trade_date, "candidate", 3)]
    wait = [normalize(item) for item in signal_items(conn, trade_date, "wait", 8)]
    exclude = [normalize(item) for item in signal_items(conn, trade_date, "exclude", 12)]
    open_trades = rows(conn, "SELECT * FROM trade_log WHERE exit_date IS NULL ORDER BY entry_date")
    exit_queue = build_exit_queue(regime_row["regime"], open_trades, config)
    guardrails = {
        "train_capital": config["capital"]["train_capital"],
        "first_entry_ratio": config["capital"]["first_entry_ratio"],
        "max_total_exposure_pct": permission["max_exposure_pct"],
        "max_single_etf_pct": config["capital"]["max_single_etf_pct"],
        "theme_position_pct": 0,
        "trend_down_exit_days": permission["trend_down_exit_days"],
    }
    return {
        "generated_at": dt.datetime.now().strftime("%Y-%m-%d %H:%M"),
        "trade_date": trade_date,
        "session": session,
        "session_name": SESSION_LABELS.get(session, session),
        "analysis_run_id": latest_analysis_run_id(conn, trade_date, session),
        "market_regime": regime_row,
        "trading_permission": permission,
        "guardrails": guardrails,
        "focus_watch": focus,
        "wait": wait,
        "exclude": exclude,
        "exit_queue": exit_queue,
        "risk_notes": ["不自动下单", "不追高开", "首笔不超过计划仓位1/3", "TREND_DOWN只做有序退出"],
    }


def update_reports_index(root):
    reports_root = pathlib.Path(root) / "reports"
    items = []
    if reports_root.exists():
        for path in sorted(reports_root.glob("*/*.json")):
            items.append(str(path.relative_to(root)).replace("\\", "/"))
    write_json(pathlib.Path(root) / "reports_index.json", {"reports": items})


def main():
    parser = argparse.ArgumentParser(description="Export SQLite results to static dashboard JSON")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--config", default=str(default_config_path()))
    parser.add_argument("--session", default="0940")
    parser.add_argument("--out-dir", default=str(REPO_ROOT / "dashboards" / "short-flow"))
    args = parser.parse_args()
    config = load_config(args.config)
    init_db(args.db)
    out_dir = pathlib.Path(args.out_dir)
    with connect(args.db) as conn:
        report = build_report(conn, config, args.session)
    latest_path = out_dir / "etf_pool_latest.json"
    write_json(latest_path, report)
    dated_dir = out_dir / "reports" / report["trade_date"]
    report_json_path = dated_dir / f"{args.session}.json"
    report_md_path = dated_dir / f"{args.session}.md"
    write_json(report_json_path, report)
    report_md_path.write_text(decision_markdown(report), encoding="utf-8")
    if report.get("analysis_run_id"):
        with connect(args.db) as conn:
            conn.execute(
                """
                UPDATE analysis_run
                SET report_json_path=?, report_md_path=?
                WHERE id=?
                """,
                (
                    str(report_json_path.relative_to(REPO_ROOT)).replace("\\", "/"),
                    str(report_md_path.relative_to(REPO_ROOT)).replace("\\", "/"),
                    report["analysis_run_id"],
                ),
            )
            conn.commit()
    update_reports_index(out_dir)
    print(f"exported dashboard ETF report: {latest_path}")


if __name__ == "__main__":
    main()






