#!/usr/bin/env bash
set -euo pipefail

python3 "$(dirname "$0")/refresh_instrument_universe.py" --output "$(dirname "$0")/../dashboards/instrument_universe.json"
"$(dirname "$0")/refresh_index_decision.sh"
"$(dirname "$0")/refresh_short_flow.sh"

# 资产管理报告（依赖以上两个看板的最新快照）
python3 "$(dirname "$0")/portfolio_report.py" \
  --portfolio "$(dirname "$0")/../dashboards/asset-management/portfolio.json" \
  --allocation "$(dirname "$0")/../dashboards/asset-management/allocation.json" \
  --trades "$(dirname "$0")/../dashboards/asset-management/trades.json" \
  --index-snapshot "$(dirname "$0")/../dashboards/index-decision/dashboard_latest.json" \
  --short-snapshot "$(dirname "$0")/../dashboards/short-flow/dashboard_latest.json" \
  --output "$(dirname "$0")/../dashboards/asset-management/portfolio_latest.json" \
  "$@"

