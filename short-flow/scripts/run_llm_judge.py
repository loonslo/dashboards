import argparse
import datetime as dt
import json

from _bootstrap import default_config_path, default_db_path
from short_flow.analysis import summarize_rules, upsert_analysis_run
from short_flow.config import load_config
from short_flow.db import connect, init_db, rows
from short_flow.graph.state import initial_state
from short_flow.graph.workflow import run_workflow


def main():
    parser = argparse.ArgumentParser(description="v0.1 rule-only LLM judge placeholder")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--config", default=str(default_config_path()))
    parser.add_argument("--session", default="0940")
    args = parser.parse_args()
    config = load_config(args.config)
    init_db(args.db)
    ts = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    with connect(args.db) as conn:
        trade_date = conn.execute("SELECT MAX(trade_date) AS d FROM signal_result").fetchone()["d"]
        if not trade_date:
            raise SystemExit("No signals; run compute_signals.py first")
        signals = rows(conn, "SELECT * FROM signal_result WHERE trade_date=? ORDER BY score DESC", (trade_date,))
        regime = conn.execute("SELECT * FROM market_regime WHERE trade_date=?", (trade_date,)).fetchone()
        candidates = [row for row in signals if row["rule_result"] == "candidate"][:3]
        waits = [row for row in signals if row["rule_result"] == "wait"][:5]
        excludes = [row for row in signals if row["rule_result"] == "exclude"][:8]
        input_summary = {
            "session_name": args.session,
            "trade_date": trade_date,
            "regime": dict(regime) if regime else {},
            "candidate_count": len(candidates),
            "wait_count": len(waits),
            "exclude_count": len(excludes),
            "top_candidates": candidates[:5],
        }
        hard_rule_summary = summarize_rules(signals)
        workflow_state = initial_state(
            args.session,
            candidates + waits,
            excludes,
            dict(regime) if regime else {},
            {
                "theme_enabled": config["features"].get("theme_enabled", False),
                "max_total_exposure_pct": config["capital"].get("max_total_exposure_pct"),
            },
        )
        workflow_result = run_workflow(workflow_state, use_llm=config["features"].get("use_llm", False))
        decisions = workflow_result.get("decisions", {})
        theme_enabled = config["features"].get("theme_enabled", False)
        decision = {
            "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。",
            "regime": dict(regime) if regime else {},
            "train_rules": {
                "theme_enabled": theme_enabled,
                "max_total_exposure_pct": config["capital"].get("max_total_exposure_pct"),
            },
            "workflow_note": workflow_result.get("workflow_note", "rule-only workflow executed."),
            "focus_watch": decisions.get("watch", candidates),
            "wait": decisions.get("wait", waits),
            "exclude": decisions.get("avoid", excludes),
            "risk_notes": [
                "不自动下单",
                "首笔不超过计划仓位1/3",
                "主题ETF已启用" if theme_enabled else "主题ETF默认关闭",
            ],
        }
        md_lines = [f"{args.session} short-flow", "", decision["summary"], ""]
        for title, key in (("可观察", "focus_watch"), ("等待", "wait"), ("今日不碰", "exclude")):
            md_lines.append(title + "：")
            if decision[key]:
                for idx, item in enumerate(decision[key], 1):
                    md_lines.append(f"{idx}. {item['code']} {item['name']}：{item['reason']}")
            else:
                md_lines.append("无")
            md_lines.append("")
        decision_md = "\n".join(md_lines)
        conn.execute(
            "INSERT INTO llm_decision (ts, session_name, decision_json, decision_md) VALUES (?, ?, ?, ?)",
            (ts, args.session, json.dumps(decision, ensure_ascii=False), decision_md),
        )
        upsert_analysis_run(
            conn,
            ts=ts,
            session_name=args.session,
            trade_date=trade_date,
            regime=(dict(regime).get("regime") if regime else None),
            input_summary=input_summary,
            hard_rule_summary=hard_rule_summary,
            llm_output=decision,
            validated_output=decision,
            status="rule_only",
        )
        conn.commit()
    print(f"saved rule-only decision: {args.session} @ {trade_date}")


if __name__ == "__main__":
    main()





