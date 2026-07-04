#!/usr/bin/env bash
set -euo pipefail

python3 "$(dirname "$0")/refresh_instrument_universe.py" --output "$(dirname "$0")/../dashboards/instrument_universe.json"
"$(dirname "$0")/refresh_index_decision.sh"
"$(dirname "$0")/refresh_short_flow.sh"

