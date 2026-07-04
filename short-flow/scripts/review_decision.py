import argparse
import datetime as dt

from _bootstrap import default_db_path
from short_flow.db import connect, init_db


DECISION_LABELS = {
    "candidate": "focus_watch",
    "wait": "wait",
    "exclude": "exclude",
}


def latest_analysis_run(conn, trade_date=None, session_name=None):
    where = []
    params = []
    if trade_date:
        where.append("trade_date=?")
        params.append(trade_date)
    if session_name:
        where.append("session_name=?")
        params.append(session_name)
    query = "SELECT * FROM analysis_run"
    if where:
        query += " WHERE " + " AND ".join(where)
    query += " ORDER BY id DESC LIMIT 1"
    return conn.execute(query, params).fetchone()


def signal_for_code(conn, trade_date, code):
    if not trade_date:
        return None
    return conn.execute(
        """
        SELECT *
        FROM signal_result
        WHERE trade_date=? AND code=?
        ORDER BY id DESC
        LIMIT 1
        """,
        (trade_date, code),
    ).fetchone()


def main():
    parser = argparse.ArgumentParser(description="Record a manual short-flow decision review")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--analysis-run-id", type=int)
    parser.add_argument("--trade-date")
    parser.add_argument("--session")
    parser.add_argument("--code", required=True)
    parser.add_argument("--name")
    parser.add_argument("--original-decision")
    parser.add_argument("--label", required=True,
                        help="Review label, e.g. good, early, late, false_positive, missed")
    parser.add_argument("--note", default="")
    parser.add_argument("--rule-hint", default="")
    parser.add_argument("--outcome-1d", type=float)
    parser.add_argument("--outcome-5d", type=float)
    parser.add_argument("--outcome-10d", type=float)
    args = parser.parse_args()

    init_db(args.db)
    now = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    code = args.code.strip()
    with connect(args.db) as conn:
        run = None
        if args.analysis_run_id:
            run = conn.execute("SELECT * FROM analysis_run WHERE id=?", (args.analysis_run_id,)).fetchone()
            if not run:
                raise SystemExit(f"analysis_run not found: {args.analysis_run_id}")
        else:
            run = latest_analysis_run(conn, args.trade_date, args.session)

        trade_date = args.trade_date or (run["trade_date"] if run else None)
        session_name = args.session or (run["session_name"] if run else None)
        signal = signal_for_code(conn, trade_date, code)
        original_decision = args.original_decision
        if not original_decision and signal:
            original_decision = DECISION_LABELS.get(signal["rule_result"], signal["rule_result"])
        name = args.name or (signal["name"] if signal else code)
        analysis_run_id = args.analysis_run_id or (run["id"] if run else None)

        conn.execute(
            """
            INSERT INTO decision_review (
              created_at, updated_at, analysis_run_id, trade_date, session_name,
              code, name, original_decision, outcome_1d, outcome_5d, outcome_10d,
              review_label, human_note, rule_adjustment_hint
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(analysis_run_id, code) DO UPDATE SET
              updated_at=excluded.updated_at,
              trade_date=excluded.trade_date,
              session_name=excluded.session_name,
              name=excluded.name,
              original_decision=excluded.original_decision,
              outcome_1d=excluded.outcome_1d,
              outcome_5d=excluded.outcome_5d,
              outcome_10d=excluded.outcome_10d,
              review_label=excluded.review_label,
              human_note=excluded.human_note,
              rule_adjustment_hint=excluded.rule_adjustment_hint
            """,
            (
                now,
                now,
                analysis_run_id,
                trade_date,
                session_name,
                code,
                name,
                original_decision,
                args.outcome_1d,
                args.outcome_5d,
                args.outcome_10d,
                args.label,
                args.note,
                args.rule_hint,
            ),
        )
        conn.commit()

    print(f"saved decision review: {code} {args.label}")


if __name__ == "__main__":
    main()
