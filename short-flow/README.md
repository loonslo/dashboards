# short-flow ETF Training Watch

This directory contains the v0.1 backend scaffold for the ETF training-position observation system.

## Boundaries

- Python computes facts, indicators, market regime, and hard-rule signals.
- SQLite stores ETF master data, snapshots, indicators, regimes, signals, analysis runs, alerts, and trade logs.
- GitHub Actions restores SQLite from `state/short_flow.sql` before each scheduled run and exports it afterward.
- The dashboard reads exported JSON/Markdown only; it does not connect to SQLite or calculate signals.
- v0.1 does not call an LLM. `run_llm_judge.py` is a rule-only placeholder for the v0.2 LangGraph layer.
- No broker connection and no automatic orders.

## LangGraph Role

LangGraph starts in v0.2. Its job is orchestration and explanation, not raw market-data calculation:

1. Load the latest compressed snapshot and rule output.
2. Keep the decision flow explicit: hard rules, regime, candidates, validation, save, push.
3. Produce structured `focus_watch`, `wait`, `exclude`, triggers, failures, and risk notes.
4. Save the complete run into `analysis_run` for later review.

## Data Assets

Daily analysis is treated as a first-class asset. The important chain is:

```text
etf_snapshot -> etf_indicator -> market_regime -> signal_result
  -> llm_decision / analysis_run -> backtest_result / decision_review
  -> alert_log -> exported reports
```

`analysis_run` keeps input summaries, hard-rule summaries, model or rule output, validated output, report paths, and status. `alert_log` records what the system reminded you, why, through which channel, and whether the push succeeded.
`backtest_result` records forward returns for historical Focus watch signals. `decision_review` records manual review labels and notes so later workflow runs can learn from repeated mistakes and valid patterns.

## Reminders

`push_report.py` creates one reminder per generated report. Without configuration it logs the reminder locally in SQLite. To push to a generic JSON webhook, set:

```bash
SHORT_FLOW_WEBHOOK_URL=https://example.com/webhook
```

Reminder levels are derived from the report: `high` for `TREND_DOWN` or exit queue, `normal` for active focus-watch candidates, and `info` for scheduled reports.

## Run Locally

Use the seed watchlist for a fast end-to-end check:

```bash
python short-flow/scripts/daily_job.py --session 0940 --seed-only
```

The daily pipeline now runs backtest before exporting the dashboard report, so
`etf_pool_latest.json` includes the latest available `backtest` summary.

Record a manual review after a signal has had time to play out:

```bash
python short-flow/scripts/review_decision.py --code 510300 --label good --note "资金确认后延续，规则有效"
```

The production refresh path should omit `--seed-only`; the ETF master script tries the data source first and falls back to the local seed list if needed. To keep the scheduled runner bounded, the training universe contains configured categories (`features.allowed_train_categories`), optional themes, and every hand-maintained watchlist item. The separate public money-flow dashboard still scans the full ETF universe.

## Outputs

- Local database: `short-flow/data/short_flow.db` (ignored by Git)
- Durable private state: `short-flow/state/short_flow.sql` (tracked, excluded from Vercel)
- Dashboard JSON: `dashboards/short-flow/etf_pool_latest.json`
- Session report JSON/Markdown: `dashboards/short-flow/reports/YYYY-MM-DD/`
- Report index: `dashboards/short-flow/reports_index.json`

## v0.1 Scope

- ETF master table
- Quote snapshot
- Indicators
- Market regime
- Hard-filter signals
- Rule-only decision
- Static dashboard export
- Local reminder logging with optional webhook push
