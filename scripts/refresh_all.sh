#!/usr/bin/env bash
set -euo pipefail

"$(dirname "$0")/refresh_index_decision.sh"
"$(dirname "$0")/refresh_short_flow.sh"

