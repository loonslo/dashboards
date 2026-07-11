# Repository Guidelines

## Project Structure & Module Organization

This repository is a private source repo for static dashboards deployed through Vercel. The root `index.html` links to `dashboards/index-decision/` and `dashboards/short-flow/`. Each dashboard keeps its UI in `index.html`, latest public data in JSON, watchlist inputs in `watchlist_v1.json`, and archived snapshots under `history/` or `reports/`.

Automation lives in `scripts/`. GitHub Actions is the only scheduled production writer. The ignored short-flow SQLite database is restored from and exported to `short-flow/state/short_flow.sql`; that state is private repository data and excluded from Vercel by `.vercelignore`.

## Build, Test, and Development Commands

- `python3 -m http.server 8000`: serve the static site locally from the repository root, then open `http://localhost:8000/`.
- `./scripts/refresh_index_decision.sh`: regenerate `dashboards/index-decision/dashboard_latest.json` and archive today’s copy in `history/`.
- `./scripts/refresh_all.sh`: run both dashboard refresh pipelines.
- `./scripts/server_refresh_and_push.sh`: refresh/persist/commit entrypoint used by GitHub Actions; the historical filename is retained for compatibility.
- `python scripts/validate_dashboards.py`: validate committed snapshot structure and semantics.
- `python -m unittest discover -s tests -v`: run the regression suite.
- `powershell -File scripts/sync_local.ps1 -RestoreState`: fast-forward local `main` and rebuild local SQLite from the persisted state.

Run shell scripts from the repository root in a Bash-compatible environment.

## Coding Style & Naming Conventions

Use 2-space indentation in HTML, CSS, and JSON. Use 4-space indentation in Python. Keep Python standard-library based unless a dependency is clearly justified. Prefer descriptive snake_case names for Python functions and variables, and kebab-case directory names for dashboards, such as `index-decision`.

Dashboard JSON should be UTF-8, pretty-printed where practical, and committed only when it represents an intentional data refresh.

## Testing Guidelines

Before committing, run the regression suite, dashboard validator, and inspect generated JSON diffs. For quick validation, use:

- `python3 -m py_compile scripts/index_decision_dashboard.py`
- `python3 -m json.tool dashboards/index-decision/dashboard_latest.json`
- `python -m unittest discover -s tests -v`
- `python scripts/validate_dashboards.py`

When changing UI, serve locally and verify the root page plus the affected dashboard page.

## Commit & Pull Request Guidelines

Commit history uses short, imperative messages such as `Add server refresh push script` and dated refresh commits such as `refresh dashboards 2026-06-30`. Keep commits focused: separate script/UI changes from generated data refreshes when possible.

Pull requests should include a short summary, the commands run, screenshots for visible UI changes, and notes about any regenerated files under `dashboards/index-decision/history/`.

## Security & Configuration Tips

Do not commit runtime caches, credentials, local logs, or machine-specific files. `short-flow/state/short_flow.sql` is the intentional exception: it is the durable database snapshot in this private repo and must remain excluded from Vercel. Treat everything under `dashboards/` as public deployable output.

## 未经批准，禁止开subagent