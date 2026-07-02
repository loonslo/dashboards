# Repository Guidelines

## Project Structure & Module Organization

This repository is a private source repo for static dashboards deployed through Vercel. The root `index.html` links to published dashboards, while each dashboard lives under `dashboards/<name>/`. The current dashboard is `dashboards/index-decision/`, with its UI in `index.html`, live data in `dashboard_latest.json`, watchlist inputs in `watchlist_v1.json`, and archived snapshots in `history/`.

Automation lives in `scripts/`. `index_decision_dashboard.py` fetches and calculates dashboard data. Shell wrappers refresh one or all dashboards. Runtime caches such as `scripts/index_decision_dashboard_cache.json` and `scripts/index_decision_dashboard_history.json` are ignored.

## Build, Test, and Development Commands

- `python3 -m http.server 8000`: serve the static site locally from the repository root, then open `http://localhost:8000/`.
- `./scripts/refresh_index_decision.sh`: regenerate `dashboards/index-decision/dashboard_latest.json` and archive today’s copy in `history/`.
- `./scripts/refresh_all.sh`: run every dashboard refresh script; currently delegates to the index-decision refresh.
- `./scripts/server_refresh_and_push.sh`: server workflow that pulls, refreshes, commits changed JSON, and pushes for Vercel deployment.

Run shell scripts from the repository root in a Bash-compatible environment.

## Coding Style & Naming Conventions

Use 2-space indentation in HTML, CSS, and JSON. Use 4-space indentation in Python. Keep Python standard-library based unless a dependency is clearly justified. Prefer descriptive snake_case names for Python functions and variables, and kebab-case directory names for dashboards, such as `index-decision`.

Dashboard JSON should be UTF-8, pretty-printed where practical, and committed only when it represents an intentional data refresh.

## Testing Guidelines

There is no formal test suite yet. Before committing, run the relevant refresh command and inspect the generated JSON diff. For quick validation, use:

- `python3 -m py_compile scripts/index_decision_dashboard.py`
- `python3 -m json.tool dashboards/index-decision/dashboard_latest.json`

When changing UI, serve locally and verify the root page plus the affected dashboard page.

## Commit & Pull Request Guidelines

Commit history uses short, imperative messages such as `Add server refresh push script` and dated refresh commits such as `refresh dashboards 2026-06-30`. Keep commits focused: separate script/UI changes from generated data refreshes when possible.

Pull requests should include a short summary, the commands run, screenshots for visible UI changes, and notes about any regenerated files under `dashboards/index-decision/history/`.

## Security & Configuration Tips

Do not commit runtime caches, credentials, local logs, or machine-specific files. Treat this as a public static output pipeline: anything under `dashboards/` may be deployed.
