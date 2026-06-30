#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD_DIR="$ROOT/dashboards/index-decision"
TODAY="$(date +%F)"

cd "$ROOT"
python3 scripts/index_decision_dashboard.py \
  --watchlist "$DASHBOARD_DIR/watchlist_v1.json" \
  --dashboard-json "$DASHBOARD_DIR/dashboard_latest.json"

mkdir -p "$DASHBOARD_DIR/history"
cp "$DASHBOARD_DIR/dashboard_latest.json" "$DASHBOARD_DIR/history/$TODAY.json"

python3 - "$DASHBOARD_DIR/history" <<'PY'
import json
import pathlib
import sys

history = pathlib.Path(sys.argv[1])
dates = sorted(path.stem for path in history.glob("*.json") if path.name != "index.json")
(history / "index.json").write_text(
    json.dumps(dates, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)
PY
