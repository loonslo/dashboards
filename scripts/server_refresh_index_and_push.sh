#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [ "$(git branch --show-current)" != "main" ]; then
  echo "Investment refresh must run on the main branch."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "Refusing investment refresh because the checkout is dirty."
  git status --short
  exit 1
fi

git pull --rebase origin main
./scripts/refresh_index_decision.sh
python3 scripts/validate_dashboards.py --max-age-hours 24

git add \
  dashboards/index-decision/dashboard_latest.json \
  dashboards/index-decision/history \
  dashboards/index-decision/watchlist_v1.json

if git diff --cached --quiet; then
  echo "No investment dashboard changes."
  exit 0
fi

git commit -m "refresh investment data $(date +%F)"
if ! git push origin main; then
  git pull --rebase origin main
  git push origin main
fi
