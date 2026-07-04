import datetime as dt
import json
import os
import urllib.error
import urllib.request


def build_alerts(report):
    session_name = report.get("session_name") or report.get("session") or "short-flow"
    regime = (report.get("market_regime") or {}).get("regime", "UNKNOWN")
    focus = report.get("focus_watch") or []
    wait = report.get("wait") or []
    exclude = report.get("exclude") or []
    exit_queue = report.get("exit_queue") or []

    title = f"short-flow {session_name}"
    lines = [
        f"市场状态：{regime}",
        f"可观察：{len(focus)}，等待：{len(wait)}，今日不碰：{len(exclude)}",
    ]
    if focus:
        names = "、".join(f"{item.get('code')} {item.get('name')}" for item in focus[:3])
        lines.append(f"重点观察：{names}")
    if exit_queue:
        names = "、".join(f"{item.get('code')} {item.get('name')}" for item in exit_queue[:3])
        lines.append(f"退出队列：{names}")

    level = "info"
    reason = "scheduled_report"
    if regime == "TREND_DOWN" or exit_queue:
        level = "high"
        reason = "risk_control"
    elif focus:
        level = "normal"
        reason = "focus_watch"

    return [
        {
            "level": level,
            "title": title,
            "body": "\n".join(lines),
            "reason": reason,
        }
    ]


def send_webhook(alert, webhook_url):
    payload = json.dumps(alert, ensure_ascii=False).encode("utf-8")
    request = urllib.request.Request(
        webhook_url,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=10) as response:
        return response.status


def save_alert(conn, *, report, alert, channel, status, report_path, error=None):
    ts = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    conn.execute(
        """
        INSERT INTO alert_log (
          ts, session_name, trade_date, analysis_run_id, channel, level,
          title, body, reason, status, report_path, error
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            ts,
            report.get("session"),
            report.get("trade_date"),
            report.get("analysis_run_id"),
            channel,
            alert.get("level"),
            alert.get("title"),
            alert.get("body"),
            alert.get("reason"),
            status,
            report_path,
            error,
        ),
    )


def dispatch_alerts(conn, *, report, report_path):
    alerts = build_alerts(report)
    webhook_url = os.environ.get("SHORT_FLOW_WEBHOOK_URL", "").strip()
    channel = "webhook" if webhook_url else "local"
    results = []
    for alert in alerts:
        status = "logged"
        error = None
        if webhook_url:
            try:
                send_webhook(alert, webhook_url)
                status = "sent"
            except (urllib.error.URLError, TimeoutError, OSError) as exc:
                status = "failed"
                error = str(exc)
        save_alert(
            conn,
            report=report,
            alert=alert,
            channel=channel,
            status=status,
            report_path=report_path,
            error=error,
        )
        results.append({**alert, "channel": channel, "status": status, "error": error})
    return results
