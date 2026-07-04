#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD_DIR="$ROOT/dashboards/short-flow"
TODAY="$(date +%F)"
TMP_JSON="$DASHBOARD_DIR/dashboard_latest.tmp.json"

cd "$ROOT"
PYTHON_BIN="${PYTHON_BIN:-}"
if [ -z "$PYTHON_BIN" ]; then
  if command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
  else
    PYTHON_BIN="python3"
  fi
fi
"$PYTHON_BIN" scripts/short_flow_dashboard.py \
  --watchlist "$DASHBOARD_DIR/watchlist_v1.json" \
  --dashboard-json "$TMP_JSON" \
  --previous-json "$DASHBOARD_DIR/dashboard_latest.json"

"$PYTHON_BIN" short-flow/scripts/daily_job.py --session 0940

"$PYTHON_BIN" - "$TMP_JSON" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)
rows = len(data.get("market_flow", [])) + len(data.get("watch_signals", []))
if rows == 0:
    gaps = data.get("data_gaps", [])
    print(f"short-flow refresh produced no rows; first gap: {gaps[0] if gaps else 'unknown'}")
    sys.exit(1)
PY

mv "$TMP_JSON" "$DASHBOARD_DIR/dashboard_latest.json"
mkdir -p "$DASHBOARD_DIR/history"
cp "$DASHBOARD_DIR/dashboard_latest.json" "$DASHBOARD_DIR/history/$TODAY.json"

"$PYTHON_BIN" - "$DASHBOARD_DIR/history" <<'PY'
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
