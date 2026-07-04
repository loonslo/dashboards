import json


def json_dumps(value):
    return json.dumps(value, ensure_ascii=False, sort_keys=True)


def summarize_rules(signals):
    counts = {}
    by_category = {}
    for row in signals:
        result = row.get("rule_result") or "unknown"
        category = row.get("group_name") or row.get("category") or "UNKNOWN"
        counts[result] = counts.get(result, 0) + 1
        by_category.setdefault(category, {})
        by_category[category][result] = by_category[category].get(result, 0) + 1
    return {
        "total": len(signals),
        "counts": counts,
        "by_category": by_category,
    }


def upsert_analysis_run(
    conn,
    *,
    ts,
    session_name,
    trade_date,
    regime,
    input_summary=None,
    hard_rule_summary=None,
    llm_output=None,
    validated_output=None,
    report_json_path=None,
    report_md_path=None,
    status="ok",
    error=None,
):
    conn.execute(
        """
        INSERT INTO analysis_run (
          ts, session_name, trade_date, regime, input_summary_json,
          hard_rule_summary_json, llm_output_json, validated_output_json,
          report_json_path, report_md_path, status, error
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            ts,
            session_name,
            trade_date,
            regime,
            json_dumps(input_summary or {}),
            json_dumps(hard_rule_summary or {}),
            json_dumps(llm_output or {}),
            json_dumps(validated_output or {}),
            report_json_path,
            report_md_path,
            status,
            error,
        ),
    )
