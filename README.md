# Dashboards

Private source repo for public Vercel dashboards.

Current dashboards:

- `dashboards/index-decision/` - investment observation dashboard
- `dashboards/short-flow/` - A-share short-term money-flow watch dashboard

Refresh flow:

1. Server runs `scripts/refresh_all.sh`.
2. Each dashboard writes its own `dashboard_latest.json`.
3. Each refresh archives a dated copy in `history/`.
4. Server commits and pushes the changed dashboard files.
5. Vercel deploys the latest static site.

