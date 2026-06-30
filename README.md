# Dashboards

Private source repo for public Vercel dashboards.

Current dashboards:

- `dashboards/index-decision/` - investment observation dashboard

Refresh flow:

1. Server runs `scripts/refresh_index_decision.sh`.
2. The script writes `dashboards/index-decision/dashboard_latest.json`.
3. It also archives a dated copy in `dashboards/index-decision/history/`.
4. Server commits and pushes the changed JSON files.
5. Vercel deploys the latest static site.
