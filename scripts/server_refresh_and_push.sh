#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

git pull --rebase
./scripts/refresh_all.sh

git add dashboards/index-decision/dashboard_latest.json dashboards/index-decision/history/

if git diff --cached --quiet; then
  echo "No dashboard data changes."
  exit 0
fi

git commit -m "refresh dashboards $(date +%F)"
git push
