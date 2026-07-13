# Dashboards

Private source repo for public Vercel dashboards.

Current dashboards:

- `dashboards/index-decision/` - investment observation dashboard
- `dashboards/short-flow/` - A-share short-term money-flow watch dashboard

Refresh flow:

1. GitHub Actions restores the persisted SQL state and runs the refresh workflow.
2. The shared instrument universe is refreshed into `dashboards/instrument_universe.json`.
3. Each dashboard writes its own `dashboard_latest.json`.
4. Each refresh archives a dated copy in `history/`.
5. The workflow exports SQLite to `short-flow/state/short_flow.sql`, then commits and pushes all changed outputs.
6. Vercel deploys the latest static site.

GitHub Actions is the only scheduled production writer. Its runner is temporary,
so the ignored SQLite runtime database is restored from a Git-friendly SQL dump
before each refresh and exported again afterward. This keeps backtests, reviews,
signals, and analysis runs durable without requiring a permanent server. The
state directory is excluded from the public Vercel deployment.

On the Windows development machine, synchronize the project with:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/sync_local.ps1 -RestoreState
```

The sync script only fast-forwards `main` and refuses to overwrite local tracked
changes. `-RestoreState` rebuilds the ignored local SQLite database from the same
state used by GitHub Actions; omit it when local runtime data should be preserved.

Instrument universe:

```bash
python scripts/refresh_instrument_universe.py
```

This maintains the shared code/name candidate pool used by dashboard search and
manual entry forms. It combines a curated mainstream A-share/US ETF list,
US TOP100 by market cap, and A-share main-board TOP1000 by market cap.

Optional local/API-server mode:

```bash
python scripts/api_server.py
```

Then open `http://127.0.0.1:8787/`.

The API server uses local SQLite at `server_data/dashboard_api.db` and seeds its
watchlists from the existing `watchlist_v1.json` files on first run. Changes made
through the API are saved to SQLite and exported back to the JSON files so the
static Vercel pages still have a snapshot fallback.

The API server is not required for scheduled refreshes or Vercel. Keep it only if
you need direct API integration or an always-on private API.

Useful API endpoints:

- `GET /api/health`
- `GET /api/dashboards`
- `GET /api/latest/index-decision`
- `GET /api/latest/short-flow`
- `GET /api/latest/etf-pool`
- `GET /api/watchlists/index-decision`
- `POST /api/watchlists/index-decision`
- `DELETE /api/watchlists/index-decision/{ticker}`
- `GET /api/watchlists/short-flow`
- `POST /api/watchlists/short-flow`
- `DELETE /api/watchlists/short-flow/{code}`
- `POST /api/refresh/index-decision`
- `POST /api/refresh/short-flow`
- `POST /api/refresh/etf-pool`

Production dashboard pages always read the checked-in JSON snapshots deployed
with the same Git commit. This prevents an old browser `dashboard_api_base`
setting from silently replacing GitHub/Vercel data with a stale server response.

Localhost development still prefers the API when it is available and falls back
to the checked-in `dashboard_latest.json` files. The browser `localStorage` key
`dashboard_api_base` can be used to test a local API address. A deliberately
API-backed deployment must set `window.DASHBOARD_SAME_ORIGIN_API = true`.

For a public API listener, both a management token and an explicit browser-origin
allowlist are required:

```bash
export DASHBOARD_API_HOST=0.0.0.0
export DASHBOARD_API_TOKEN='replace-with-a-long-random-secret'
export DASHBOARD_API_ALLOWED_ORIGINS='https://your-dashboard.vercel.app,https://your-domain.example'
python scripts/api_server.py
```

Read endpoints remain public. Watchlist, strategy-configuration, and refresh
requests require the token in the `X-Dashboard-Token` request header.

LangGraph learning path:

`short-flow/short_flow/graph/workflow.py` is the practice layer. It currently
runs a rule-only judge through the same workflow entry point. If `langgraph` is
installed and `features.use_llm` is enabled in `short-flow/config.yaml`, the
workflow can execute through a LangGraph graph while the data fetching,
indicators, hard filters, SQLite persistence, and static exports remain stable.

