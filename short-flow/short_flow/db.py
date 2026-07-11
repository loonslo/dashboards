import pathlib
import sqlite3


SCHEMA = """
CREATE TABLE IF NOT EXISTS etf_master (
  code TEXT PRIMARY KEY,
  name TEXT,
  market TEXT,
  category TEXT,
  sub_category TEXT,
  is_broad INTEGER,
  is_theme INTEGER,
  is_qdii INTEGER,
  is_bond INTEGER,
  is_money INTEGER,
  status TEXT,
  updated_at TEXT
);

CREATE TABLE IF NOT EXISTS etf_snapshot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  trade_date TEXT,
  code TEXT,
  name TEXT,
  price REAL,
  pct REAL,
  amount REAL,
  volume REAL,
  main_inflow REAL,
  main_inflow_pct REAL,
  market_cap REAL,
  float_market_cap REAL
);

CREATE TABLE IF NOT EXISTS etf_indicator (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  trade_date TEXT,
  code TEXT,
  ma5 REAL,
  ma10 REAL,
  ma20 REAL,
  ma60 REAL,
  ret5 REAL,
  ret10 REAL,
  ret20 REAL,
  amount_ratio_5 REAL,
  amount_ratio_20 REAL,
  above_ma5 INTEGER,
  above_ma10 INTEGER,
  above_ma20 INTEGER,
  ma20_slope_positive INTEGER
);

CREATE TABLE IF NOT EXISTS market_regime (
  trade_date TEXT PRIMARY KEY,
  above_ma20_ratio REAL,
  ma20_slope_positive_ratio REAL,
  inflow_positive_ratio REAL,
  regime TEXT
);

CREATE TABLE IF NOT EXISTS signal_result (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  trade_date TEXT,
  session_name TEXT NOT NULL DEFAULT 'legacy',
  code TEXT,
  name TEXT,
  group_name TEXT,
  score REAL,
  rule_result TEXT,
  reason TEXT,
  entry_trigger TEXT,
  failure_condition TEXT
);

CREATE TABLE IF NOT EXISTS llm_decision (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  session_name TEXT,
  decision_json TEXT,
  decision_md TEXT
);

CREATE TABLE IF NOT EXISTS analysis_run (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  session_name TEXT,
  trade_date TEXT,
  regime TEXT,
  input_summary_json TEXT,
  hard_rule_summary_json TEXT,
  llm_output_json TEXT,
  validated_output_json TEXT,
  report_json_path TEXT,
  report_md_path TEXT,
  status TEXT,
  error TEXT
);
CREATE TABLE IF NOT EXISTS alert_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  session_name TEXT,
  trade_date TEXT,
  analysis_run_id INTEGER,
  channel TEXT,
  level TEXT,
  title TEXT,
  body TEXT,
  reason TEXT,
  status TEXT,
  report_path TEXT,
  error TEXT
);
CREATE TABLE IF NOT EXISTS backtest_result (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  signal_date TEXT,
  code TEXT,
  name TEXT,
  regime TEXT,
  score REAL,
  rule_result TEXT,
  reason TEXT,
  close_price REAL,
  next_open REAL,
  next_close REAL,
  return_1d_open REAL,
  return_1d_close REAL,
  return_5d REAL,
  return_10d REAL,
  hit_1d INTEGER,
  hit_5d INTEGER,
  hit_10d INTEGER,
  computed_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_bt_signal_date ON backtest_result(signal_date);
CREATE INDEX IF NOT EXISTS idx_bt_regime ON backtest_result(regime);
CREATE TABLE IF NOT EXISTS decision_review (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  created_at TEXT,
  updated_at TEXT,
  analysis_run_id INTEGER,
  trade_date TEXT,
  session_name TEXT,
  code TEXT,
  name TEXT,
  original_decision TEXT,
  outcome_1d REAL,
  outcome_5d REAL,
  outcome_10d REAL,
  review_label TEXT,
  human_note TEXT,
  rule_adjustment_hint TEXT
);
CREATE INDEX IF NOT EXISTS idx_review_trade_date ON decision_review(trade_date);
CREATE INDEX IF NOT EXISTS idx_review_code ON decision_review(code);
CREATE INDEX IF NOT EXISTS idx_review_label ON decision_review(review_label);
CREATE TABLE IF NOT EXISTS backfill_result (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  signal_date TEXT,
  code TEXT,
  name TEXT,
  regime TEXT,
  score REAL,
  rule_result TEXT,
  reason TEXT,
  pct REAL,
  amount REAL,
  main_inflow REAL,
  main_inflow_pct REAL,
  amount_ratio_20 REAL,
  close_price REAL,
  next_open REAL,
  next_close REAL,
  return_1d_open REAL,
  return_1d_close REAL,
  return_5d REAL,
  return_10d REAL,
  return_20d REAL,
  hit_1d INTEGER,
  hit_5d INTEGER,
  hit_10d INTEGER,
  hit_20d INTEGER,
  source TEXT DEFAULT 'backfill',
  computed_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_bf_signal_date ON backfill_result(signal_date);
CREATE INDEX IF NOT EXISTS idx_bf_regime ON backfill_result(regime);
CREATE INDEX IF NOT EXISTS idx_bf_code ON backfill_result(code);

CREATE TABLE IF NOT EXISTS trade_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  entry_date TEXT,
  code TEXT,
  name TEXT,
  regime TEXT,
  pattern TEXT,
  direction_score REAL,
  entry_price REAL,
  stop_loss REAL,
  position_pct REAL,
  risk_amount REAL,
  exit_date TEXT,
  exit_price REAL,
  exit_reason TEXT,
  pnl REAL,
  pnl_pct REAL,
  mae REAL,
  mfe REAL,
  held_days INTEGER,
  notes TEXT
);
"""

MIGRATIONS = [
    "ALTER TABLE signal_result ADD COLUMN session_name TEXT NOT NULL DEFAULT 'legacy'",
    "UPDATE signal_result SET session_name='legacy' WHERE session_name IS NULL OR session_name=''",
    """
    DELETE FROM signal_result
    WHERE id NOT IN (
      SELECT MAX(id)
      FROM signal_result
      GROUP BY trade_date, session_name, code
    )
    """,
    "CREATE UNIQUE INDEX IF NOT EXISTS idx_signal_date_session_code ON signal_result(trade_date, session_name, code)",
    """
    DELETE FROM backtest_result
    WHERE id NOT IN (
      SELECT MIN(id)
      FROM backtest_result
      GROUP BY signal_date, code
    )
    """,
    "CREATE UNIQUE INDEX IF NOT EXISTS idx_bt_signal_code ON backtest_result(signal_date, code)",
    """
    DELETE FROM decision_review
    WHERE id NOT IN (
      SELECT MAX(id)
      FROM decision_review
      WHERE analysis_run_id IS NOT NULL AND code IS NOT NULL
      GROUP BY analysis_run_id, code
      UNION
      SELECT id
      FROM decision_review
      WHERE analysis_run_id IS NULL OR code IS NULL
    )
    """,
    "CREATE UNIQUE INDEX IF NOT EXISTS idx_review_run_code ON decision_review(analysis_run_id, code)",
    # v0.2: rename inflow_5d_ratio → inflow_positive_ratio (it was always
    # single-day inflow>0 proportion, not a 5-day metric)
    "ALTER TABLE market_regime RENAME COLUMN inflow_5d_ratio TO inflow_positive_ratio",
]


def connect(db_path):
    path = pathlib.Path(db_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    return conn


def init_db(db_path):
    conn = connect(db_path)
    try:
        conn.executescript(SCHEMA)
        for migration in MIGRATIONS:
            try:
                conn.execute(migration)
            except Exception:
                pass  # migration already applied or not applicable
        conn.commit()
    finally:
        conn.close()


def rows(conn, query, params=()):
    return [dict(row) for row in conn.execute(query, params).fetchall()]



