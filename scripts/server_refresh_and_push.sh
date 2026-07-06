#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

git pull --rebase --autostash
./scripts/refresh_all.sh

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
  short-flow/config.yaml

if git diff --cached --quiet; then
  echo "No dashboard data changes."
  git push
  exit 0
fi

git commit -m "refresh dashboards $(date +%F)"
git push

