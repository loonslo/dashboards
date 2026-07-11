# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Private repo for public Vercel dashboards providing Chinese A-share market observation tools. Static HTML/CSS/JS frontend, Python backend, SQLite for structured data.

- **index-decision** — 投资观察看板: indices, watchlist, alerts, data gaps
- **short-flow** — A股短线资金跟随看板: market money flow + ETF training-position tracking

## Commands

```bash
# Serve the static site locally (from repo root)
python3 -m http.server 8000

# Refresh index-decision dashboard (generates dashboard_latest.json + history archive)
./scripts/refresh_index_decision.sh

# Refresh short-flow dashboard (money flow data + ETF pipeline)
./scripts/refresh_short_flow.sh

# Run all dashboard refreshes
./scripts/refresh_all.sh

# GitHub Actions refresh/persist/commit entrypoint (historical filename)
./scripts/server_refresh_and_push.sh

# Validate and synchronize durable state
python scripts/validate_dashboards.py
python -m unittest discover -s tests -v
powershell -File scripts/sync_local.ps1 -RestoreState

# Run ETF training pipeline directly (e.g. 0940 session, seed-only to skip API)
cd short-flow && python scripts/daily_job.py --session 0940
python short-flow/scripts/daily_job.py --session 0940 --seed-only

# Validate Python scripts / JSON output
python3 -m py_compile scripts/index_decision_dashboard.py
python3 -m json.tool dashboards/short-flow/etf_pool_latest.json
```

## Architecture

### Directory Layout

```
.
├── index.html                    # Landing page linking to both dashboards
├── vercel.json                   # Vercel config (cleanUrls, trailingSlash)
├── AGENTS.md                     # Old guidance file (historical reference)
├── dashboards/
│   ├── index-decision/           # Investment observation dashboard
│   │   ├── index.html            # SPA frontend (vanilla JS)
│   │   ├── dashboard_latest.json # Latest data snapshot
│   │   ├── watchlist_v1.json     # User-defined watchlist
│   │   └── history/              # Dated archives
│   └── short-flow/               # Short-term money flow dashboard
│       ├── index.html            # SPA frontend (vanilla JS)
│       ├── dashboard_latest.json # Money flow + signal data
│       ├── etf_pool_latest.json  # ETF training-position report
│       ├── watchlist_v1.json     # ETF seed watchlist
│       ├── reports/              # Dated session reports (JSON + MD)
│       └── history/              # Dated archives
├── scripts/
│   ├── index_decision_dashboard.py    # Data fetcher for index-decision
│   ├── short_flow_dashboard.py        # Money flow data fetcher (standalone)
│   ├── refresh_index_decision.sh
│   ├── refresh_short_flow.sh          # Runs short_flow_dashboard.py + daily_job.py
│   ├── refresh_all.sh
│   ├── server_refresh_and_push.sh     # GitHub Actions refresh/persist/push entrypoint
│   ├── short_flow_state.py            # SQLite ↔ durable SQL state
│   └── validate_dashboards.py         # Publication quality gate
└── short-flow/                        # ETF training pipeline (Python package)
    ├── config.yaml                    # Trading parameters (capital, filters, regime rules)
    ├── requirements.txt               # Empty — stdlib only in v0.1
    ├── data/short_flow.db             # Runtime SQLite database (gitignored)
    ├── state/short_flow.sql           # Durable private state restored by Actions
    ├── scripts/
    │   ├── daily_job.py               # Pipeline orchestrator (steps in order)
    │   ├── _bootstrap.py              # Path setup (adds short-flow/ to sys.path)
    │   ├── fetch_etf_master.py        # ETF master list from Eastmoney API
    │   ├── fetch_snapshot.py          # Quote + money flow snapshots
    │   ├── compute_indicators.py      # Technical indicators (MAs, returns, volume ratios)
    │   ├── compute_regime.py          # Market regime classification
    │   ├── compute_signals.py         # Hard-filter signal generation
    │   ├── run_llm_judge.py           # Rule-only judge (placeholder for v0.2 LangGraph)
    │   ├── export_dashboard_json.py   # Export to JSON/Markdown for dashboard
    │   └── push_report.py             # Alert dispatch (local log or webhook)
    └── short_flow/
        ├── config.py                  # YAML config loader with defaults + deep merge
        ├── db.py                      # SQLite schema + connection helpers
        ├── models.py                  # Dataclasses
        ├── analysis.py                # Analysis run persistence
        ├── alerts.py                  # Alert logic + webhook dispatch
        ├── data_sources/
        │   └── eastmoney.py           # Eastmoney API client (quotes, klines, ETF list)
        ├── graph/                     # LangGraph placeholder (v0.2)
        │   ├── workflow.py
        │   ├── nodes.py
        │   ├── state.py
        │   └── prompts.py
        ├── reports/
        │   ├── json_report.py         # Pretty-printed JSON writer
        │   └── markdown.py            # Decision markdown generator
        └── rules/
            ├── filters.py             # Hard filters (category, amount, inflow, MA)
            ├── regime.py              # Market regime classification logic
            ├── entry_patterns.py      # Entry pattern classification
            └── exit_rules.py          # Exit queue builder
```

### short-flow Has Two Independent Data Paths

1. **`scripts/short_flow_dashboard.py`** — Standalone script that fetches A-share ETF money flow data from Eastmoney, builds `dashboard_latest.json` (market flow + watch signals + rankings). No SQLite dependency. Runs via `refresh_short_flow.sh`.

2. **`short-flow/scripts/daily_job.py`** — Modular training pipeline that chained 8 steps: `fetch_etf_master → fetch_snapshot → compute_indicators → compute_regime → compute_signals → run_llm_judge → export_dashboard_json → push_report`. All data flows through SQLite (`short_flow.db`). Outputs `etf_pool_latest.json`, session reports (JSON/MD), and report index. Steps pass `--session` (0850/0940/1130/1430/1520) and `--seed-only` flags.

The two paths are independent — `refresh_short_flow.sh` runs both in sequence.

### Data Pipeline Flow (ETF Training)

```
Eastmoney API → etf_master → etf_snapshot → etf_indicator
                                            → market_regime (aggregate)
                                            → signal_result (per-ETF with hard filters)
                                            → llm_decision + analysis_run
                                            → etf_pool_latest.json + reports/
                                            → alert_log
```

### Key Design Decisions

- **No external dependencies** in v0.1 — Python standard library only (urllib, sqlite3, json). LangGraph/OpenAI deferred to v0.2.
- **Dashboard is read-only** — the frontend never connects to SQLite or calculates signals. It reads exported JSON only.
- **GitHub Actions is the only scheduled writer** — each run restores SQLite from `short-flow/state/short_flow.sql`, refreshes, validates, exports state, and commits outputs. A permanent server is optional.
- **Config-driven trading rules** — `config.yaml` controls capital allocation, regime thresholds, filters, entry params, and schedule. `short_flow/config.py` provides defaults with YAML override via deep merge.
- **Data staleness awareness** — frontend displays `live/stale/unavailable` status per row.
- **Coding style**: 2-space indent in HTML/CSS/JSON, 4-space in Python. snake_case for Python, kebab-case for directories.

### Data Sources

- **Eastmoney** (`push2.eastmoney.com`) — ETF list, quotes, money flow data
- **Tencent/gtimg** (`web.ifzq.gtimg.cn`) — Daily kline data
- **CSIndex** (`csindex.com.cn`) — Chinese index data (CSI 300, etc.)
- **Stooq/CNBC/WSJ** — US index data (S&P 500, NDX)
- API calls retry 3× then fall back to `curl` before raising

## Memory (productivity system)

### Me
ajar，股票交易员。A股ETF + 美股（NDX/SPX/半导体/头部公司）+ 数字币量化。做看板辅助个人决策。不预测市场，少左侧，主做右侧交易。

### Terms
| 术语 | 含义 |
|------|------|
| 右侧交易 | 趋势确认后跟随，不预测 |
| 0850/0940/1130/1430/1520 | short-flow 盘中场次 |
| 数据更新频率 | A股按场次、美股按美东收盘、数字币 7×24 |

### Preferences
- 中文交流；第一性原则；客观优缺点；直接不废话
- 详细记忆见 memory/ 目录（glossary、people、projects、context）
