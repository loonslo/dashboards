import argparse
import json
import pathlib

from _bootstrap import REPO_ROOT, default_db_path
from short_flow.alerts import dispatch_alerts
from short_flow.db import connect, init_db


def main():
    parser = argparse.ArgumentParser(description="Create and optionally send short-flow reminder alerts")
    parser.add_argument("--db", default=str(default_db_path()))
    parser.add_argument("--report", default=str(REPO_ROOT / "dashboards" / "short-flow" / "etf_pool_latest.json"))
    args = parser.parse_args()

    path = pathlib.Path(args.report)
    if not path.exists():
        raise SystemExit(f"report not found: {path}")

    report = json.loads(path.read_text(encoding="utf-8"))
    init_db(args.db)
    report_path = str(path.relative_to(REPO_ROOT)).replace("\\", "/")
    with connect(args.db) as conn:
        alerts = dispatch_alerts(conn, report=report, report_path=report_path)
        conn.commit()

    for alert in alerts:
        print(f"alert {alert['status']} [{alert['level']}] {alert['title']} via {alert['channel']}")


if __name__ == "__main__":
    main()
