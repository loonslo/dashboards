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

Server API mode:

```bash
python scripts/api_server.py
```

Then open `http://127.0.0.1:8787/` or the management page at
`http://127.0.0.1:8787/dashboards/admin/`.

The API server uses local SQLite at `server_data/dashboard_api.db` and seeds its
watchlists from the existing `watchlist_v1.json` files on first run. Watchlist
changes made through the admin page are saved to SQLite and exported back to the
JSON files so the static Vercel pages still have a snapshot fallback.

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

The dashboard pages prefer the API when it is available and fall back to the
checked-in `dashboard_latest.json` files when served as static pages.

When the pages are served from Vercel but the API runs on your own server, set
`dashboards/api_config.json`:

```json
{
  "apiBase": "https://your-api.example.com"
}
```

The admin page also has an API address field that saves the value to browser
`localStorage` as `dashboard_api_base`. Browser `localStorage` takes precedence
over `api_config.json`, which is useful for testing a new server address before
committing it.

LangGraph learning path:

`short-flow/short_flow/graph/workflow.py` is the practice layer. It currently
runs a rule-only judge through the same workflow entry point. If `langgraph` is
installed and `features.use_llm` is enabled in `short-flow/config.yaml`, the
workflow can execute through a LangGraph graph while the data fetching,
indicators, hard filters, SQLite persistence, and static exports remain stable.

