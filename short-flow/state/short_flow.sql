BEGIN TRANSACTION;
CREATE TABLE alert_log (
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
INSERT INTO "alert_log" VALUES(1,'2026-07-13 14:48','0940','2026-07-13',1,'local','info','short-flow 09:40 盘中确认','市场状态：RANGE
可观察：0，等待：3，今日不碰：0','scheduled_report','logged','dashboards/short-flow/etf_pool_latest.json',NULL);
CREATE TABLE analysis_run (
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
INSERT INTO "analysis_run" VALUES(1,'2026-07-13 14:48','0940','2026-07-13','RANGE','{"candidate_count": 0, "exclude_count": 0, "regime": {"above_ma20_ratio": 0.0, "inflow_positive_ratio": 0.0, "ma20_slope_positive_ratio": 0.0, "regime": "RANGE", "trade_date": "2026-07-13"}, "session_name": "0940", "top_candidates": [], "trade_date": "2026-07-13", "wait_count": 3}','{"by_category": {"CORE": {"wait": 2}, "GROWTH": {"wait": 1}}, "counts": {"wait": 3}, "total": 3}','{"exclude": [], "focus_watch": [{"code": "159915", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 1, "name": "创业板ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -11.34, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}, {"code": "510300", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 2, "name": "沪深300ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -11.76, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}, {"code": "510500", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 3, "name": "中证500ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -13.44, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}], "regime": {"above_ma20_ratio": 0.0, "inflow_positive_ratio": 0.0, "ma20_slope_positive_ratio": 0.0, "regime": "RANGE", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [], "workflow_note": "rule-only workflow executed."}','{"exclude": [], "focus_watch": [{"code": "159915", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 1, "name": "创业板ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -11.34, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}, {"code": "510300", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 2, "name": "沪深300ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -11.76, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}, {"code": "510500", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 3, "name": "中证500ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -13.44, "session_name": "0940", "trade_date": "2026-07-13", "ts": "2026-07-13 14:48"}], "regime": {"above_ma20_ratio": 0.0, "inflow_positive_ratio": 0.0, "ma20_slope_positive_ratio": 0.0, "regime": "RANGE", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [], "workflow_note": "rule-only workflow executed."}','dashboards/short-flow/reports/2026-07-13/0940.json','dashboards/short-flow/reports/2026-07-13/0940.md','rule_only',NULL);
CREATE TABLE backfill_result (
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
CREATE TABLE backtest_result (
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
CREATE TABLE decision_review (
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
CREATE TABLE etf_indicator (
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
INSERT INTO "etf_indicator" VALUES(1,'2026-07-13','159915',3.8922,4.0142,4.12214999999999953e+00,3.95346666666666646e+00,-5.28967254408061471e+00,-1.12370160528800777e+01,-2.23608944357774897e+00,1.22565548753275832e+00,1.23549167734559883e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(2,'2026-07-13','510300',4.8238,4.8739,4.92120000000000068e+00,4.87666666666666692e+00,-2.60405987287266604e+00,-4.21455938697317122e+00,-1.41137401411373097e+00,8.59550615783207461e-01,5.79990317009021705e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(3,'2026-07-13','510500',8.606,8.7964,8.8229,8.60329999999999905e+00,-5.56186152099886754e+00,-7.28772008023177431e+00,9.46372239747628185e-01,1.05282853868448533e+00,1.25646200217645476e+00,0,0,0,1);
CREATE TABLE etf_master (
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
INSERT INTO "etf_master" VALUES('510050','上证50ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('510300','沪深300ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('510500','中证500ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('512100','中证1000ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('159915','创业板ETF','SZ','GROWTH','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('588220','科创100F','SH','GROWTH','宽基',1,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('512760','半导体ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('589020','KC半导体','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('515880','通信ETF','SH','SECTOR','科技ETF',0,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('515070','AI ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('562500','机器人ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('512890','红利低波ETF','SH','DEFENSE','防守/轮动',0,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('512000','券商ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('516020','化工ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T14:48:49');
INSERT INTO "etf_master" VALUES('512010','医药ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T14:48:49');
CREATE TABLE etf_snapshot (
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
INSERT INTO "etf_snapshot" VALUES(1,'2026-07-13 14:48','2026-07-13','510300','沪深300ETF华泰柏瑞',4.752,-1.59,7172361393.0,15068178.0,-1846625824.0,-25.75,81530955399.0,81530955399.0);
INSERT INTO "etf_snapshot" VALUES(2,'2026-07-13 14:48','2026-07-13','510500','中证500ETF南方',8.322,-4.32,7227071528.0,8615093.0,-1071399328.0,-14.82,37753323689.0,37753323689.0);
INSERT INTO "etf_snapshot" VALUES(3,'2026-07-13 14:48','2026-07-13','159915','创业板ETF易方达',3.757,-2.72,6996837631.486,18460580.0,-1033924464.0,-14.78,44338065864.0,44338065864.0);
CREATE TABLE llm_decision (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ts TEXT,
  session_name TEXT,
  decision_json TEXT,
  decision_md TEXT
);
INSERT INTO "llm_decision" VALUES(1,'2026-07-13 14:48','0940','{"summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "regime": {"trade_date": "2026-07-13", "above_ma20_ratio": 0.0, "ma20_slope_positive_ratio": 0.0, "inflow_positive_ratio": 0.0, "regime": "RANGE"}, "train_rules": {"theme_enabled": true, "max_total_exposure_pct": 0.4}, "workflow_note": "rule-only workflow executed.", "focus_watch": [{"id": 1, "ts": "2026-07-13 14:48", "trade_date": "2026-07-13", "session_name": "0940", "code": "159915", "name": "创业板ETF", "group_name": "GROWTH", "score": -11.34, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 2, "ts": "2026-07-13 14:48", "trade_date": "2026-07-13", "session_name": "0940", "code": "510300", "name": "沪深300ETF", "group_name": "CORE", "score": -11.76, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 3, "ts": "2026-07-13 14:48", "trade_date": "2026-07-13", "session_name": "0940", "code": "510500", "name": "中证500ETF", "group_name": "CORE", "score": -13.44, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}], "wait": [], "exclude": [], "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"]}','0940 short-flow

v0.1规则引擎输出，大模型判断将在v0.2接入。

可观察：
1. 159915 创业板ETF：主力资金未转正；OBSERVE_ONLY
2. 510300 沪深300ETF：主力资金未转正；OBSERVE_ONLY
3. 510500 中证500ETF：主力资金未转正；OBSERVE_ONLY

等待：
无

今日不碰：
无
');
CREATE TABLE market_regime (
  trade_date TEXT PRIMARY KEY,
  above_ma20_ratio REAL,
  ma20_slope_positive_ratio REAL,
  inflow_positive_ratio REAL,
  regime TEXT
);
INSERT INTO "market_regime" VALUES('2026-07-13',0.0,0.0,0.0,'RANGE');
CREATE TABLE signal_result (
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
INSERT INTO "signal_result" VALUES(1,'2026-07-13 14:48','2026-07-13','0940','159915','创业板ETF','GROWTH',-11.34,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(2,'2026-07-13 14:48','2026-07-13','0940','510300','沪深300ETF','CORE',-11.76,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(3,'2026-07-13 14:48','2026-07-13','0940','510500','中证500ETF','CORE',-13.44,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
CREATE TABLE trade_log (
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
CREATE INDEX idx_bt_signal_date ON backtest_result(signal_date);
CREATE INDEX idx_bt_regime ON backtest_result(regime);
CREATE INDEX idx_review_trade_date ON decision_review(trade_date);
CREATE INDEX idx_review_code ON decision_review(code);
CREATE INDEX idx_review_label ON decision_review(review_label);
CREATE INDEX idx_bf_signal_date ON backfill_result(signal_date);
CREATE INDEX idx_bf_regime ON backfill_result(regime);
CREATE INDEX idx_bf_code ON backfill_result(code);
CREATE UNIQUE INDEX idx_signal_date_session_code ON signal_result(trade_date, session_name, code);
CREATE UNIQUE INDEX idx_bt_signal_code ON backtest_result(signal_date, code);
CREATE UNIQUE INDEX idx_review_run_code ON decision_review(analysis_run_id, code);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('etf_snapshot',3);
INSERT INTO "sqlite_sequence" VALUES('etf_indicator',3);
INSERT INTO "sqlite_sequence" VALUES('signal_result',3);
INSERT INTO "sqlite_sequence" VALUES('llm_decision',1);
INSERT INTO "sqlite_sequence" VALUES('analysis_run',1);
INSERT INTO "sqlite_sequence" VALUES('alert_log',1);
COMMIT;
