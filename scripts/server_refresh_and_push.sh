#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if command -v flock >/dev/null 2>&1; then
  LOCK_FILE="${DASHBOARD_REFRESH_LOCK:-/tmp/dashboards-refresh.lock}"
  exec 9>"$LOCK_FILE"
  if ! flock -n 9; then
    echo "Another dashboard refresh is already running."
    exit 1
  fi
fi

if [ "$(git branch --show-current)" != "main" ]; then
  echo "Server refresh must run on the main branch."
  exit 1
fi

allowed_dirty='^(dashboards/index-decision/watchlist_v1\.json|dashboards/short-flow/watchlist_v1\.json|short-flow/config\.yaml)$'
while IFS= read -r path; do
  [ -z "$path" ] && continue
  if ! printf '%s\n' "$path" | grep -Eq "$allowed_dirty"; then
    echo "Refusing refresh because tracked server file is dirty: $path"
    exit 1
  fi
done < <({ git diff --name-only; git diff --cached --name-only; } | sort -u)

git pull --rebase --autostash origin main
if [ ! -f short-flow/data/short_flow.db ]; then
  python3 scripts/short_flow_state.py restore
fi
./scripts/refresh_all.sh
python3 scripts/validate_dashboards.py --max-age-hours 8
python3 scripts/short_flow_state.py export

git add \
  dashboards/instrument_universe.json \
  dashboards/index-decision/dashboard_latest.json \
  dashboards/index-decision/history \
  dashboards/index-decision/watchlist_v1.json \
  dashboards/short-flow/dashboard_latest.json \
  dashboards/short-flow/etf_pool_latest.json \
  dashboards/short-flow/history \
  dashboards/short-flow/reports \
  dashboards/short-flow/reports_index.json \
  dashboards/short-flow/watchlist_v1.json \
  short-flow/config.yaml \
  short-flow/state/short_flow.sql

if git diff --cached --quiet; then
  echo "No dashboard data changes."
  git push
  exit 0
fi

git commit -m "refresh dashboards $(date +%F)"
if ! git push origin main; then
  git pull --rebase origin main
  git push origin main
fi

