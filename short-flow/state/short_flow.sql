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
INSERT INTO "alert_log" VALUES(2,'2026-07-13 18:02','1520','2026-07-13',2,'local','high','short-flow 15:20 盘后选池','市场状态：TREND_DOWN
可观察：0，等待：8，今日不碰：12','risk_control','logged','dashboards/short-flow/etf_pool_latest.json',NULL);
INSERT INTO "alert_log" VALUES(3,'2026-07-13 19:05','1520','2026-07-13',3,'local','high','short-flow 15:20 盘后选池','市场状态：TREND_DOWN
可观察：0，等待：8，今日不碰：12','risk_control','logged','dashboards/short-flow/etf_pool_latest.json',NULL);
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
INSERT INTO "analysis_run" VALUES(2,'2026-07-13 18:02','1520','2026-07-13','TREND_DOWN','{"candidate_count": 0, "exclude_count": 8, "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "session_name": "1520", "top_candidates": [], "trade_date": "2026-07-13", "wait_count": 5}','{"by_category": {"CORE": {"exclude": 91, "wait": 47}, "DEFENSE": {"wait": 1}, "GROWTH": {"exclude": 99, "wait": 48}, "SECTOR": {"wait": 4}, "THEME": {"exclude": 26, "wait": 67}}, "counts": {"exclude": 216, "wait": 167}, "total": 383}','{"exclude": [{"code": "562320", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 234, "name": "沪深300价值ETF银华", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 8.98, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510190", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 146, "name": "上证50ETF华安", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 7.0, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "515360", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 189, "name": "沪深300ETF方正富邦", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.64, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510710", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 166, "name": "上证50ETF博时", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.32, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510850", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 168, "name": "上证50ETF工银", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 3.28, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "159289", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "GROWTH", "id": 33, "name": "创业板综指ETF鹏华", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.69, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "589380", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "THEME", "id": 363, "name": "科创人工智能ETF富国", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.41, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "560330", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 210, "name": "沪深300价值ETF申万菱信", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 0.96, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "focus_watch": [{"code": "512010", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "SECTOR", "id": 171, "name": "医药ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 6.27, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "512890", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "DEFENSE", "id": 181, "name": "红利低波ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 1.33, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "589720", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 374, "name": "科创创新药ETF国泰", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "wait", "score": 0.18, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [{"code": "589190", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "THEME", "id": 351, "name": "科创芯片ETF华宝", "reason": "主力流入强度不足；OBSERVE_ONLY", "rule_result": "wait", "score": -2.19, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "159925", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 127, "name": "沪深300ETF南方", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -3.02, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "workflow_note": "rule-only workflow executed."}','{"exclude": [{"code": "562320", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 234, "name": "沪深300价值ETF银华", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 8.98, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510190", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 146, "name": "上证50ETF华安", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 7.0, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "515360", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 189, "name": "沪深300ETF方正富邦", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.64, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510710", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 166, "name": "上证50ETF博时", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.32, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "510850", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 168, "name": "上证50ETF工银", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 3.28, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "159289", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "GROWTH", "id": 33, "name": "创业板综指ETF鹏华", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.69, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "589380", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "THEME", "id": 363, "name": "科创人工智能ETF富国", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.41, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "560330", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 210, "name": "沪深300价值ETF申万菱信", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 0.96, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "focus_watch": [{"code": "512010", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "SECTOR", "id": 171, "name": "医药ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 6.27, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "512890", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "DEFENSE", "id": 181, "name": "红利低波ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 1.33, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "589720", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 374, "name": "科创创新药ETF国泰", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "wait", "score": 0.18, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [{"code": "589190", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "THEME", "id": 351, "name": "科创芯片ETF华宝", "reason": "主力流入强度不足；OBSERVE_ONLY", "rule_result": "wait", "score": -2.19, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}, {"code": "159925", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 127, "name": "沪深300ETF南方", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -3.02, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 18:02"}], "workflow_note": "rule-only workflow executed."}','dashboards/short-flow/reports/2026-07-13/1520.json','dashboards/short-flow/reports/2026-07-13/1520.md','rule_only',NULL);
INSERT INTO "analysis_run" VALUES(3,'2026-07-13 19:05','1520','2026-07-13','TREND_DOWN','{"candidate_count": 0, "exclude_count": 8, "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "session_name": "1520", "top_candidates": [], "trade_date": "2026-07-13", "wait_count": 5}','{"by_category": {"CORE": {"exclude": 91, "wait": 47}, "DEFENSE": {"wait": 1}, "GROWTH": {"exclude": 99, "wait": 48}, "SECTOR": {"wait": 4}, "THEME": {"exclude": 26, "wait": 67}}, "counts": {"exclude": 216, "wait": 167}, "total": 383}','{"exclude": [{"code": "562320", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 617, "name": "沪深300价值ETF银华", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 8.98, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510190", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 529, "name": "上证50ETF华安", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 7.0, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "515360", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 572, "name": "沪深300ETF方正富邦", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.64, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510710", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 549, "name": "上证50ETF博时", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.32, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510850", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 551, "name": "上证50ETF工银", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 3.28, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "159289", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "GROWTH", "id": 416, "name": "创业板综指ETF鹏华", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.69, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "589380", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "THEME", "id": 746, "name": "科创人工智能ETF富国", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.41, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "560330", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 593, "name": "沪深300价值ETF申万菱信", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 0.96, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "focus_watch": [{"code": "512010", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "SECTOR", "id": 554, "name": "医药ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 6.27, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "512890", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "DEFENSE", "id": 564, "name": "红利低波ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 1.33, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "589720", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 757, "name": "科创创新药ETF国泰", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "wait", "score": 0.18, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [{"code": "589190", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "THEME", "id": 734, "name": "科创芯片ETF华宝", "reason": "主力流入强度不足；OBSERVE_ONLY", "rule_result": "wait", "score": -2.19, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "159925", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 510, "name": "沪深300ETF南方", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -3.04, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "workflow_note": "rule-only workflow executed."}','{"exclude": [{"code": "562320", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 617, "name": "沪深300价值ETF银华", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 8.98, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510190", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 529, "name": "上证50ETF华安", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 7.0, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "515360", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 572, "name": "沪深300ETF方正富邦", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.64, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510710", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 549, "name": "上证50ETF博时", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 4.32, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "510850", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 551, "name": "上证50ETF工银", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 3.28, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "159289", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "GROWTH", "id": 416, "name": "创业板综指ETF鹏华", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.69, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "589380", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "THEME", "id": 746, "name": "科创人工智能ETF富国", "reason": "成交额低于阈值；OBSERVE_ONLY", "rule_result": "exclude", "score": 1.41, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "560330", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估", "group_name": "CORE", "id": 593, "name": "沪深300价值ETF申万菱信", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "exclude", "score": 0.96, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "focus_watch": [{"code": "512010", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "SECTOR", "id": 554, "name": "医药ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 6.27, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "512890", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "DEFENSE", "id": 564, "name": "红利低波ETF", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": 1.33, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "589720", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "GROWTH", "id": 757, "name": "科创创新药ETF国泰", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "rule_result": "wait", "score": 0.18, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "regime": {"above_ma20_ratio": 0.06451612903225806, "inflow_positive_ratio": 0.12755102040816327, "ma20_slope_positive_ratio": 0.5725806451612904, "regime": "TREND_DOWN", "trade_date": "2026-07-13"}, "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"], "summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "train_rules": {"max_total_exposure_pct": 0.4, "theme_enabled": true}, "wait": [{"code": "589190", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "THEME", "id": 734, "name": "科创芯片ETF华宝", "reason": "主力流入强度不足；OBSERVE_ONLY", "rule_result": "wait", "score": -2.19, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}, {"code": "159925", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴", "group_name": "CORE", "id": 510, "name": "沪深300ETF南方", "reason": "主力资金未转正；OBSERVE_ONLY", "rule_result": "wait", "score": -3.04, "session_name": "1520", "trade_date": "2026-07-13", "ts": "2026-07-13 19:05"}], "workflow_note": "rule-only workflow executed."}','dashboards/short-flow/reports/2026-07-13/1520.json','dashboards/short-flow/reports/2026-07-13/1520.md','rule_only',NULL);
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
INSERT INTO "etf_indicator" VALUES(387,'2026-07-13','159012',1.082,1.1055,1.11649999999999982e+00,NULL,-4.04783808647654,-1.0318142734307834e+01,2.75862068965517792e+00,1.20441920852223449e+00,8.69948020400549748e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(388,'2026-07-13','159022',1.2046,1.22270000000000012e+00,1.22005,NULL,-1.0951979780960519e+00,-6.1550759392486,9.822263797942,0.877433908389006,6.34563026950981434e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(389,'2026-07-13','159048',9.95999999999999885e-01,1.0349,1.0238,NULL,-12.708719851577,-1.97916666666666518e+00,-3.97959183673469718e+00,8.781607117014949e-01,1.15256082154091354e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(390,'2026-07-13','159050',9.8339999999999994e-01,1.0238,1.0126,NULL,-1.2851782363977481e+01,-1.79704016913317943e+00,-4.32543769309988768e+00,4.52593362120224884e-01,1.12787860269473827e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(391,'2026-07-13','159107',0.7732,7.82600000000000073e-01,0.7893,8.45000000000000084e-01,-1.04031209362809295e+00,-0.652741514360311,1.46666666666666056e+00,8.72594928562823057e-01,0.727601919065031,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(392,'2026-07-13','159139',1.504,1.5267,1.51915,1.41456666666666652e+00,-1.81573638197714,-6.58989123480485616e+00,9.52738184546135791e+00,1.0735956460415672e+00,1.14072709021008367e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(393,'2026-07-13','159140',1.5132,1.53529999999999988e+00,1.52729999999999987e+00,1.42171666666666651e+00,-1.47551978537894257e+00,-6.55216284987276686e+00,1.01199400299849973e+01,1.18726184136756529e+00,0.971347938440009,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(394,'2026-07-13','159141',1.42859999999999987e+00,1.4485,1.442,1.34704999999999985e+00,-1.20738636363635354e+00,-6.20364126770061,1.01346001583531464e+01,1.16968654737358068e+00,1.07176303010558826e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(395,'2026-07-13','159142',1.4532,1.4742,1.46660000000000012e+00,1.36808333333333331e+00,-6.99300699300697825e-01,-5.89794565937706849e+00,1.06780982073265704e+01,8.85576132608964283e-01,8.122664186671118e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(396,'2026-07-13','159205',1.9002,1.96230000000000015e+00,2.0145,1.93188333333333317e+00,-5.67010309278349566e+00,-1.15087040618955462e+01,-2.60777009047364893e+00,1.23685883292400644e+00,1.591053407765036e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(397,'2026-07-13','159213',1.318,1.35399999999999987e+00,1.3589,1.34134999999999982e+00,-9.11062906724512444e+00,-4.04580152671757353e+00,-3.38201383551114398e+00,7.27895051184126229e-01,8.70116024468677418e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(398,'2026-07-13','159215',1.3604,1.38019999999999987e+00,1.39105000000000011e+00,1.37133333333333329e+00,-3.40333091962345957e+00,-5.25568181818181212e+00,-5.21998508575682862e-01,1.48887005140683,1.99061375373981031e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(399,'2026-07-13','159226',1.28539999999999987e+00,1.29930000000000012e+00,1.31575,1.32015000000000015e+00,-4.05508798775822132e+00,-5.00000000000000444e+00,-2.79069767441860738e+00,1.27757578991025644e+00,1.57089690793820624e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(400,'2026-07-13','159238',1.3588,1.3769,1.38770000000000015e+00,1.3547,-3.26086956521738358e+00,-5.25195173882186949e+00,2.25225225225211822e-01,1.05026651841293294e+00,0.981636076958217,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(401,'2026-07-13','159240',1.3488,1.36609999999999986e+00,1.37935,1.36096666666666665e+00,-4.23976608187134296e+00,-5.75539568345322383e+00,-1.28108515448378534e+00,3.98223721083311232e+00,4.53379823778090873e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(402,'2026-07-13','159242',2.34879999999999977e+00,2.4066,2.47725,2.33866666666666667e+00,-3.19013185878350702e+00,-9.17797286512370646e+00,9.31263858093123175e-01,1.70679601426913651e+00,1.53411279474935025e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(403,'2026-07-13','159243',1.4134,1.44659999999999988e+00,1.48965,1.40633333333333321e+00,-3.12056737588650712e+00,-9.71579643093191158e+00,7.37463126843662664e-01,0.972818185452365,1.13077715774340514e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(404,'2026-07-13','159246',1.3118,1.3437,1.38455,1.30743333333333322e+00,-3.12738367658275118e+00,-9.47968638631504489e+00,1.03420843277646223e+00,1.34194065734379064e+00,1.09560296300839676e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(405,'2026-07-13','159247',1.16639999999999988e+00,1.202,1.2344,1.18485,-5.4008438818565434e+00,-1.1523283346487755e+01,-2.77536860364266946e+00,1.21033241068505081e+00,1.72051208069483752e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(406,'2026-07-13','159248',2.0622,2.0671,2.05325,1.92406666666666681e+00,1.70085042521259666e+00,-2.25961538461538768e+00,1.12144420131290889e+01,1.12765174900085263e+00,9.69927599333084922e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(407,'2026-07-13','159249',1.374,1.3891,1.40124999999999988e+00,1.38863333333333338e+00,-4.83985765124556088e+00,-4.97512437810945229e+00,-2.26608187134503813e+00,1.2466364161842276e+00,1.2286242005600565e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(408,'2026-07-13','159256',0.8516,8.62100000000000088e-01,0.86965,9.33483333333333331e-01,-1.17924528301887043e+00,-5.93119810201658825e-01,1.20772946859903917e+00,1.24361158180897435e+00,1.12406176010609915e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(409,'2026-07-13','159258',1.2280000000000002e+00,1.2625,1.2673,1.25053333333333327e+00,-9.59752321981425282e+00,-4.34070434070434885e+00,-3.63036303630363,6.13345359059922934e-01,9.04662389192190108e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(410,'2026-07-13','159270',1.2128,1.25500000000000011e+00,1.27464999999999983e+00,1.25511666666666665e+00,-8.33333333333333747e+00,-8.76777251184833694e+00,-3.83014154870940926e+00,1.15039319649601301e+00,1.13386658320108413e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(411,'2026-07-13','159272',0.9308,0.9679,9.57249999999999934e-01,9.48266666666666702e-01,-1.27110228401191562e+01,-2.11581291759466161e+00,-3.9344262295082033e+00,1.05802251601662322e+00,1.75757499447764575e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(412,'2026-07-13','159278',1.09399999999999986e+00,1.13819999999999987e+00,1.12555,1.1169,-1.28161888701517678e+01,-1.89753320683112569e+00,-3.99257195914577422e+00,6.16147130324184777e-01,9.98095356118467891e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(413,'2026-07-13','159279',1.579,1.61750000000000016e+00,1.66655000000000019e+00,1.57525,-3.48542458808619448e+00,-9.50683303624481,2.63331138907174633e-01,1.32569953405521467e+00,1.42400512998113359e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(414,'2026-07-13','159287',1.2196,1.25500000000000011e+00,1.284,1.26265,-5.28422738190552632e+00,-8.43653250773993512e+00,-2.7937551355793011e+00,1.53139673863047498e+00,1.0594634427713474e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(415,'2026-07-13','159288',1.08500000000000018e+00,1.12029999999999985e+00,1.14570000000000016e+00,1.13348333333333339e+00,-7.04727921498661302e+00,-1.08639863130881142e+01,-3.51851851851852082e+00,1.01990510733739614e+00,3.40866291478146843e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(416,'2026-07-13','159289',1.18040000000000011e+00,1.2203,1.251,1.2288,-7.28910728910729943e+00,-1.03721298495645264e+01,-4.47257383966246369e+00,1.45841641180678549e+00,1.92895261452947708e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(417,'2026-07-13','159290',1.2672,1.3113,1.3465,1.323,-8.01815431164902747e+00,-1.05224429727741046e+01,-5.59006211180124168e+00,1.50555707772828562e+00,1.44288452908495767e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(418,'2026-07-13','159291',1.27900000000000013e+00,1.3235,1.35504999999999986e+00,1.31263333333333331e+00,-8.53932584269662164e+00,-1.02205882352941141e+01,-4.00943396226414172e+00,8.30258959610262636e-01,1.05308160083996571e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(419,'2026-07-13','159292',1.23680000000000012e+00,1.2755,1.30375,1.28965000000000018e+00,-7.25995316159250236e+00,-9.93176648976497134e+00,-4.42477876106196532e+00,2.09860551331130817e+00,1.55307015977454532e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(420,'2026-07-13','159293',1.1436,1.1721,1.19395,1.16255,-6.23931623931623935e+00,-8.9626556016597636e+00,-2.74822695035460418e+00,9.5633567586926671e-01,0.971428638873669,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(421,'2026-07-13','159298',1.3676,1.4158,1.46065,1.40411666666666667e+00,-4.69992769342010241e+00,-1.19572478289913135e+01,-4.00582665695556894e+00,1.54699614204631785e+00,1.57390136340465769e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(422,'2026-07-13','159300',5.1662,5.2183,5.2606,5.19438333333333357e+00,-2.32156561780505477e+00,-4.01583710407239458e+00,-8.18234950321450327e-01,6.22989962867055524e+00,7.23548564336585542e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(423,'2026-07-13','159310',3.75319999999999964e+00,3.79399999999999959e+00,3.6423,3.0528,-3.12754963285287734e+00,-1.06372303060712543e+01,2.37235151094129719e+01,1.38133203037037555e+00,1.37444392235816525e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(424,'2026-07-13','159325',2.7276,2.7622,2.65255,2.20788333333333364e+00,-2.73818454613653505e+00,-1.18027210884353745e+01,24.2453282223287,9.45700753839764263e-01,1.0324587775972529e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(425,'2026-07-13','159327',4.3598,4.3874,4.10045,3.16436666666666654e+00,-4.3562439496611649e-01,-1.03312990409764609e+01,3.01075268817204246e+01,1.22421999020666572e+00,1.44138464516893582e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(426,'2026-07-13','159330',1.48880000000000012e+00,1.5049,1.5177,1.5018,-2.59308510638297518e+00,-4.18574231523870565e+00,-1.54569892473117587e+00,2.24516745576210885e+00,2.27817434889779,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(427,'2026-07-13','159335',1.582,1.61879999999999979e+00,1.63604999999999978e+00,1.60191666666666665e+00,-6.26535626535625844e+00,-6.26535626535625844e+00,-2.98792116973934929e+00,4.84433203588298721e-01,5.029260586937776e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(428,'2026-07-13','159337',1.9314,1.97,1.9741,1.92038333333333333e+00,-4.72560975609756,-6.62350597609562274e+00,1.84682237914177704e+00,1.58097922835927939e+00,1.68829213125655241e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(429,'2026-07-13','159338',1.276,1.29559999999999986e+00,1.3079,1.29221666666666679e+00,-3.85208012326656579e+00,-5.66893424036281068e+00,-1.26582278481012222e+00,1.03506717510363532e+00,9.81008371027739523e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(430,'2026-07-13','159339',1.2882,1.3069,1.31845,1.3009,-3.59602142310634365e+00,-5.54722638680660296e+00,-9.4339622641509413e-01,1.29413450511088279e+00,1.15629330345635583e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(431,'2026-07-13','159351',1.2798,1.29890000000000016e+00,1.31110000000000015e+00,1.29473333333333329e+00,-3.68946963873944,-5.50527903469081358e+00,-1.02685624012639475e+00,1.53389592715354439e+00,1.56247253693281984e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(432,'2026-07-13','159352',1.3282,1.34819999999999984e+00,1.36055,1.34316666666666661e+00,-3.85470719051149712e+00,-5.94633792603336264e+00,-9.92366412213752102e-01,1.21236870719872458e+00,1.21646436504434229e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(433,'2026-07-13','159353',1.2912,1.31110000000000015e+00,1.323,1.30703333333333326e+00,-3.96341463414634498e+00,-5.82959641255605909e+00,-1.40845070422535023e+00,1.1400651315796908e+00,1.06236310720360394e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(434,'2026-07-13','159356',1.34779999999999988e+00,1.3682,1.3792,1.35906666666666664e+00,-3.36257309941521143e+00,-5.30085959885385804e+00,-6.01503759398491766e-01,1.34180961609048954e+00,1.26411672245267348e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(435,'2026-07-13','159357',1.3446,1.3648,1.3771,1.35738333333333338e+00,-3.80395025603511571e+00,-5.5994256999282177e+00,-9.78915662650614581e-01,1.3396175316881862e+00,1.25128817075791776e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(436,'2026-07-13','159358',1.36799999999999988e+00,1.3892,1.40115,1.38168333333333337e+00,-3.87931034482756897e+00,-5.64174894217206457e+00,-1.03550295857988139e+00,1.28134872078104478e+00,1.04835648649097934e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(437,'2026-07-13','159359',1.3378,1.35780000000000011e+00,1.37045,1.35385,-3.8235294117647145e+00,-5.62770562770561433e+00,-1.28301886792452357e+00,1.49258265664615419e+00,1.32621802203372141e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(438,'2026-07-13','159360',1.36799999999999988e+00,1.3887,1.40095,1.38138333333333318e+00,-3.80747126436781213e+00,-5.43785310734462612e+00,-0.88823094004441,1.63415596557294295e+00,1.2505217783780691e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(439,'2026-07-13','159361',1.3022,1.32140000000000013e+00,1.3338,1.31698333333333339e+00,-3.70370370370369794e+00,-5.62962962962962887e+00,-9.33125972006221271e-01,1.04303534131016095e+00,1.11606173948521347e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(440,'2026-07-13','159362',1.3592,1.3793,1.3914,1.37219999999999986e+00,-3.76266280752530768e+00,-5.4054054054053946e+00,-8.94187779433686103e-01,8.25144081303781584e-01,9.13551568048895701e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(441,'2026-07-13','159363',1.3934,1.42669999999999985e+00,1.47075,1.38778333333333336e+00,-3.09130122214233971e+00,-9.40860215053762516e+00,8.98203592814361684e-01,1.31065946761799,1.35164570345198931e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(442,'2026-07-13','159367',1.94059999999999988e+00,2.0099,2.07705,1.99961666666666682e+00,-5.91506572295247323e+00,-1.22997172478793608e+01,-4.7594677584442131e+00,1.07039921247941349e+00,1.11245142903266924e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(443,'2026-07-13','159369',1.5798,1.6306,1.68449999999999988e+00,1.61975,-5.23690773067332315e+00,-1.20879120879120893e+01,-4.04040404040404421e+00,7.99553462861175456e-01,8.32053253163189343e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(444,'2026-07-13','159371',1.93659999999999987e+00,1.99779999999999979e+00,2.0651,1.98778333333333323e+00,-5.29801324503311743e+00,-1.21455576559546418e+01,-4.47070914696814369e+00,8.22682162467784583e-01,8.12869232146115172e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(445,'2026-07-13','159372',2.0718,2.1358,2.20375000000000031e+00,2.11858333333333304e+00,-5.47619047619047893e+00,-1.20513956579530336e+01,-4.24505547515676706e+00,7.62663229750850657e-01,8.19545760673163536e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(446,'2026-07-13','159373',1.97400000000000019e+00,2.0369,2.10620000000000029e+00,2.02938333333333353e+00,-4.89266100848727525e+00,-1.17647058823529331e+01,-4.12682435832914,1.28336861056622231e+00,1.18583701540913066e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(447,'2026-07-13','159375',8.25399999999999911e-01,8.52399999999999935e-01,8.80400000000000071e-01,0.84705,-5.46967895362662215e+00,-1.18625277161862552e+01,-4.10132689987936505e+00,8.84324468511223371e-01,1.29454685665343438e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(448,'2026-07-13','159376',1.3874,1.4081,1.42125000000000012e+00,1.4048,-3.47271438695959666e+00,-5.1532033426183732e+00,-8.73362445414849197e-01,9.77514775987693429e-01,1.40075078983186829e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(449,'2026-07-13','159379',1.4042,1.4264,1.44015,1.4178,-4.61215932914046433e+00,-6.18556701030927857e+00,-1.7985611510791255e+00,1.54381167784969464e+00,2.11799392449043644e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(450,'2026-07-13','159380',1.4204,1.4393,1.45005,1.42808333333333337e+00,-4.22437673130193758e+00,-5.66166439290586254e+00,-1.1436740528949274e+00,2.59774739844689595e+00,2.41915253762262372e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(451,'2026-07-13','159381',1.3192,1.35180000000000011e+00,1.3927,1.31350000000000011e+00,-3.18181818181818565e+00,-9.23295454545454141e+00,1.18764845605701108e+00,1.06654873028620089e+00,1.21153938841260844e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(452,'2026-07-13','159382',2.9772,3.04900000000000037e+00,3.1393,2.96544999999999969e+00,-3.12605042016806944e+00,-9.28548945546112669e+00,1.05189340813465204e+00,2.78303882097489196e+00,2.74934851080206588e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(453,'2026-07-13','159383',1.92220000000000013e+00,1.98240000000000016e+00,2.04774999999999973e+00,1.9726,-5.17683239364428171e+00,-1.18207816968541319e+01,-4.29384376616658336e+00,9.55375670547241928e-01,1.10382590696582982e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(454,'2026-07-13','159386',1.3446,1.3646,1.37815,1.36251666666666682e+00,-4.09356725146199362e+00,-5.88235294117646,-1.57539384846210328e+00,6.89973058607069367e-01,8.72178582612371355e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(455,'2026-07-13','159388',1.1394,1.1674,1.20265,1.13621666666666665e+00,-3.07557117750438813e+00,-9.44170771756978,9.14913083257085091e-01,1.23204036909738068e+00,1.2992808143565846e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(456,'2026-07-13','159393',5.0912,5.14500000000000046e+00,5.18924999999999947e+00,5.11796666666666588e+00,-2.56709451575263258e+00,-4.26141792470857705e+00,-1.12492599171107876e+00,4.6496528615070849e+00,4.02281001926482417e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(457,'2026-07-13','159500',1.2638,1.291,1.29280000000000017e+00,1.2552333333333332e+00,-4.42203258339798388e+00,-5.954198473282446e+00,2.15588723051409747e+00,1.49362013493555467e+00,1.84770156838244536e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(458,'2026-07-13','159510',1.2132,1.2153,1.215,1.24776666666666669e+00,-1.94963444354183668e+00,1.65975103734439244e-01,-2.18800648298216327e+00,1.01480203636837207e+00,9.00903656728551882e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(459,'2026-07-13','159516',9.00200000000000111e-01,9.10500000000000087e-01,8.54749999999999898e-01,6.6116666666666668e-01,9.33488914819147197e-01,-9.98959417273672656e+00,3.06646525679758141e+01,1.52576438522348722e+00,2.41003446966996648e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(460,'2026-07-13','159523',1.3184,1.3358,1.3474,1.32345,-3.15078769692422877e+00,-5.62865497076025,4.66926070038908847e-01,9.35712757764550873e-01,1.12583303090957254e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(461,'2026-07-13','159526',1.60940000000000016e+00,1.654,1.65835,1.6355333333333335e+00,-9.38606847697757196e+00,-4.00250156347717833e+00,-3.27662255828607973e+00,7.9474576686279752e-01,8.9927047482692124e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(462,'2026-07-13','159530',1.545,1.6069,1.59065,1.5791666666666666e+00,-1.30746268656716466e+01,-2.34741784037559853e+00,-4.39921208141824671e+00,6.8402484193275892e-01,9.83231527376580483e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(463,'2026-07-13','159541',1.65420000000000011e+00,1.70689999999999986e+00,1.74379999999999979e+00,1.7149833333333333e+00,-7.20984759671746644e+00,-1.00568181818181834e+01,-3.71046228710462111e+00,1.2182696794842589e+00,9.38784302267657633e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(464,'2026-07-13','159551',1.419,1.4596,1.46374999999999988e+00,1.44321666666666681e+00,-9.51105157401206469e+00,-4.45544554455444874e+00,-3.499999999999992e+00,0.761388460176259,0.995921841565701,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(465,'2026-07-13','159558',1.426,1.4373,1.3447,1.03636666666666665e+00,-4.4215180545320587e-01,-1.02921646746347956e+01,3.05314009661835861e+01,1.7662317512512784e+00,3.38115548901711493e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(466,'2026-07-13','159559',1.38380000000000014e+00,1.4398,1.42455,1.41603333333333347e+00,-12.8,-1.8018018018018056e+00,-4.38596491228070384e+00,7.36827116647320368e-01,9.74286768624977317e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(467,'2026-07-13','159560',2.9866,3.02029999999999976e+00,2.91075,2.44651666666666667e+00,-2.83083219645292594e+00,-1.09687499999999928e+01,2.3173367920449639e+01,9.99585615686752526e-01,1.0988403326866567e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(468,'2026-07-13','159563',1.9728,2.0284,2.0728,2.03820000000000023e+00,-3.95256916996047369e+00,-6.62824207492794848e+00,-9.67906265919515895e-01,1.98111079685780766e+00,1.67019184088678041e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(469,'2026-07-13','159571',1.5568,1.6115,1.62994999999999978e+00,1.61475000000000012e+00,-8.68761552680221704e+00,-8.68761552680221704e+00,-2.62812089356110334e+00,1.63074499547428741e+00,1.41502381372379293e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(470,'2026-07-13','159572',1.5564,1.6139,1.63875,1.61540000000000016e+00,-8.53284223449969303e+00,-8.42040565457897827e+00,-3.55987055016180331e+00,1.17917332086060389e+00,1.01909078342810666e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(471,'2026-07-13','159573',1.5662,1.62229999999999985e+00,1.6468,1.6226666666666667e+00,-8.45070422535210141e+00,-8.78584502745576401e+00,-3.73470701867352206e+00,1.02570290144826059e+00,1.05402819401888336e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(472,'2026-07-13','159575',1.524,1.5779,1.60215,1.5800333333333334e+00,-8.44360428481411,-8.6737900691388976e+00,-3.71106693174286794e+00,1.05353571628787556e+00,1.03919637525796448e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(473,'2026-07-13','159582',0.9724,0.9696,9.11650000000000071e-01,7.23416666666666707e-01,1.53005464480875374e+00,-7.19280719280718194e+00,3.0477528089887663e+01,5.27386416078693631e+00,6.67823085765278179e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(474,'2026-07-13','159597',9.14600000000000079e-01,0.9477,9.69699999999999895e-01,9.06616666666666626e-01,-7.04375667022412166e+00,-1.35912698412698382e+01,-1.69300225733634013e+00,9.12683404773708684e-01,1.07874874631907,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(475,'2026-07-13','159599',3.6878,3.7297,3.59470000000000045e+00,3.02301666666666646e+00,-2.70494065691416762e+00,-1.09173616376042392e+01,2.33379986004198727e+01,8.71867982598074076e-01,1.05305706187068404e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(476,'2026-07-13','159603',2.0494,2.0909,2.10414999999999974e+00,1.91983333333333328e+00,-4.35420743639921603e+00,-1.08120437956204398e+01,3.5487288135593209e+00,1.37364728051679474e+00,1.11043230540519122e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(477,'2026-07-13','159606',1.3606,1.3856,1.383,1.33593333333333341e+00,-5.57939914163089234e+00,-5.10424155283968339e+00,6.09756097560976151e-01,1.34380211641958591e+00,1.272509736751815e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(478,'2026-07-13','159610',1.3402,1.3651,1.36015,1.31203333333333316e+00,-5.94202898550723,-6.28158844765343,3.01587301587302736e+00,8.62640203693255447e-01,0.949354191316499,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(479,'2026-07-13','159617',1.3122,1.3133,1.3162,1.36653333333333337e+00,-2.69058295964126337e+00,4.62962962962953916e-01,-3.05286671630676798e+00,1.85902280497507921e+00,2.57352172848665672e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(480,'2026-07-13','159620',1.356,1.38019999999999987e+00,1.36745,1.31845,-6.98503207412687388e+00,-4.32551319648094612e+00,4.15003990422986301e+00,1.42120296628427933e+00,1.39291055754651016e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(481,'2026-07-13','159629',3.38939999999999974e+00,3.50020000000000042e+00,3.5528,3.51493333333333302e+00,-7.85147392290249612e+00,-9.06293706293707,-4.382352941176471e+00,1.52362307909210414e+00,2.61242414642895148e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(482,'2026-07-13','159633',3.47379999999999977e+00,3.58860000000000045e+00,3.64285,3.60411666666666707e+00,-7.93914246196404427e+00,-8.89679715302491658e+00,-4.58715596330275765e+00,1.74200017789896399e+00,2.47602146841999548e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(483,'2026-07-13','159656',1.28799999999999981e+00,1.3105,1.32705,1.28943333333333343e+00,-3.22580645161291146e+00,-7.28476821192053414e+00,1.58982511923677627e-01,1.32659920746633863e+00,1.47052446381482915e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(484,'2026-07-13','159665',3.16739999999999977e+00,3.2207,3.11714999999999964e+00,2.61650000000000027e+00,-3.81679389312977734e+00,-1.15789473684210548e+01,2.17391304347826164e+01,1.13184886029418141e+00,1.42158816216978745e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(485,'2026-07-13','159673',1.3232,1.33700000000000018e+00,1.34894999999999987e+00,1.33605,-2.76532137518685772e+00,-4.26784400294334354e+00,-1.36467020470053546e+00,1.70705026583055641e+00,2.25412143359547334e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(486,'2026-07-13','159675',1.6042,1.6631,1.70775,1.63316666666666665e+00,-6.91747572815533118e+00,-1.29398410896708231e+01,-3.82445141065830274e+00,1.12992395879535112e+00,1.19358666702334592e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(487,'2026-07-13','159676',1.741,1.784,1.81425,1.74011666666666653e+00,-5.72069545709478255e+00,-8.04157549234135693e+00,-6.50118203309690834e-01,1.97308885835688529e+00,2.32078646269014887e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(488,'2026-07-13','159677',1.5356,1.5819,1.60015,1.58118333333333316e+00,-7.49531542785758553e+00,-7.89800995024875263e+00,-2.82152230971127737e+00,0.868654231331321,7.55146667572885066e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(489,'2026-07-13','159679',1.26439999999999974e+00,1.301,1.32695,1.35218333333333329e+00,-8.49772382397572201e+00,-7.01619121048573379e+00,-7.6569678407350743e+00,1.20628166653619195e+00,1.5018541533688412e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(490,'2026-07-13','159680',1.7358,1.79350000000000031e+00,1.81885,1.78016666666666667e+00,-9.08590308370044219e+00,-9.28571428571428647e+00,-5.11494252873563315e+00,1.63475448549620971e+00,1.44254451491721225e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(491,'2026-07-13','159681',1.815,1.873,1.93545000000000011e+00,1.8633,-5.31741725447638646e+00,-1.20020171457387743e+01,-4.38356164383560908e+00,1.13298025951171399e+00,9.72998702390754366e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(492,'2026-07-13','159682',1.79379999999999983e+00,1.85219999999999984e+00,1.91445,1.8434166666666667e+00,-5.47645125958379175e+00,-1.20733571064696949e+01,-4.11111111111111,8.4734963938501806e-01,8.1929796706852731e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(493,'2026-07-13','159770',1.1334,1.1654,1.16905,1.15371666666666672e+00,-9.94152046783625209e+00,-4.34782608695651884e+00,-3.74999999999999777e+00,8.9331543910047062e-01,1.01056220468777469e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(494,'2026-07-13','159773',1.4228,1.465,1.49905,1.44778333333333342e+00,-4.86787204450624955e+00,-1.12840466926069975e+01,-2.35546038543896774e+00,7.22230460893403813e-01,7.19536970730094149e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(495,'2026-07-13','159780',1.31,1.3404,1.3532,1.23755,-3.44299923488905479e+00,-1.07496463932107424e+01,3.69761709120788317e+00,8.33419867687363313e-01,8.79958082295470567e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(496,'2026-07-13','159781',1.3164,1.346,1.35755,1.24091666666666666e+00,-3.79939209726444238e+00,-1.07193229901269333e+01,3.68550368550368823e+00,9.23985956326923596e-01,8.72930783894750761e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(497,'2026-07-13','159782',1.316,1.34350000000000013e+00,1.35715,1.23986666666666667e+00,-3.57686453576865348e+00,-1.10252808988764101e+01,3.76740376740374305e+00,1.07108396738870337e+00,1.03407134136503553e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(498,'2026-07-13','159783',1.3254,1.3548,1.3636,1.24545000000000016e+00,-4.44277108433736067e+00,-1.06338028169014044e+01,3.50734094616638181e+00,7.81507496551824165e-01,0.916963856293466,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(499,'2026-07-13','159801',1.509,1.5325,1.48245,1.24393333333333333e+00,-3.55227882037533193e+00,-1.19877675840978525e+01,2.21561969439728372e+01,1.11934244869530719e+00,1.18211356386642951e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(500,'2026-07-13','159810',1.5576,1.6103,1.6545,1.5878,-5.9231253938248134e+00,-1.20730270906949321e+01,-3.36569579288025222e+00,1.18202944987587565e+00,9.83857973657733087e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(501,'2026-07-13','159813',1.9346,1.96640000000000014e+00,1.90755,1.60385,-3.13152400835071675e+00,-1.16611137553545916e+01,2.17847769028871383e+01,1.47268060995615,1.72875205435672,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(502,'2026-07-13','159819',2.0838,2.0913,2.0793,1.95266666666666655e+00,1.48441365660565427e+00,-2.56532066508312617e+00,1.08049702863317165e+01,1.0293143440878405e+00,9.97133052048688295e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(503,'2026-07-13','159820',1.4584,1.4894,1.49295,1.4558,-5.5630026809651456e+00,-6.93527080581242127e+00,1.00358422939068603e+00,1.58016250897832821e+00,1.244546083390488e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(504,'2026-07-13','159836',1.4108,1.457,1.4933,1.44073333333333342e+00,-6.36678200692042395e+00,-1.16840731070496079e+01,-3.14960629921260393e+00,1.3712231650822646e+00,1.77367026355320023e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(505,'2026-07-13','159845',3.3832,3.495,3.55055,3.5208,-7.92388525986935654e+00,-8.93258426966292518e+00,-4.53474676089516925e+00,1.76845882237724616e+00,2.82678862861247148e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(506,'2026-07-13','159908',3.6192,3.73239999999999971e+00,3.83224999999999971e+00,3.67371666666666651e+00,-5.58871405317417,-1.16078232156464284e+01,-2.65734265734266505e+00,9.48803932624436852e-01,0.598268519782356,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(507,'2026-07-13','159915',3.8902,4.01319999999999943e+00,4.12165,3.9533,-5.54156171284635412e+00,-1.14730878186968805e+01,-2.49609984399376,1.1222507819790719e+00,1.18376840903519431e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(508,'2026-07-13','159919',5.0308,5.0838,5.1323,5.0833166666666667e+00,-2.71279732651857896e+00,-4.38562596599692,-1.27668063036106,1.77590004508464915e+00,5.70891594481308217e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(509,'2026-07-13','159922',3.4242,3.50020000000000042e+00,3.51015000000000032e+00,3.42106666666666692e+00,-5.78842315369262294e+00,-7.3211781206171107e+00,7.93166564978631249e-01,1.36625821638858768e+00,1.68906125508170323e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(510,'2026-07-13','159925',4.8734,4.9232,4.9672,4.91533333333333377e+00,-2.37708248679399103e+00,-4.0343519073297358e+00,-0.989078920255515,3.25719451674658611e+00,3.65542694596338124e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(511,'2026-07-13','159935',2.6616,2.7217,2.727,2.66436666666666654e+00,-5.32892319000367642e+00,-6.90278279725333732e+00,1.01960784313726016e+00,1.58712816535528711e+00,1.82150990016757585e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(512,'2026-07-13','159948',4.2926,4.4316,4.55335,4.3665833333333337e+00,-5.50857142857141823e+00,-1.16289012398460798e+01,-2.45398773006134662e+00,1.1280301450475314e+00,1.32446306879243569e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(513,'2026-07-13','159949',1.844,1.90420000000000011e+00,1.97005,1.89715,-5.54075652637187054e+00,-1.24444444444444464e+01,-4.42048517520216,1.08343652212704832e+00,1.11858631347990855e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(514,'2026-07-13','159952',2.3596,2.435,2.5019,2.3996,-5.69883527454243576e+00,-1.17898832684824927e+01,-2.99529311082585847e+00,7.17515535358540068e-01,1.02187126827450236e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(515,'2026-07-13','159956',2.4602,2.5383,2.6118,2.50361666666666682e+00,-5.58659217877093272e+00,-12.2077922077922,-2.99302993029929575e+00,1.41258668871147041e+00,1.25276408778325776e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(516,'2026-07-13','159957',2.5512,2.6345,2.70510000000000028e+00,2.59443333333333336e+00,-5.45943867743174937e+00,-1.14512063377745771e+01,-2.49801744647104584e+00,1.10872252030731566e+00,1.14479268329501526e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(517,'2026-07-13','159958',2.34780000000000033e+00,2.4217,2.48735,2.38963333333333372e+00,-5.60200668896320142e+00,-1.15550332941637297e+01,-2.92347377472055303e+00,1.60668401282245421e+00,1.51680751147044978e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(518,'2026-07-13','159964',2.536,2.61709999999999975e+00,2.68685,2.57515,-5.87326120556415087e+00,-1.17391304347826075e+01,-2.71565495207668483e+00,1.32131684941688298e+00,1.54221816926623378e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(519,'2026-07-13','159966',0.579,0.5968,0.61305,6.16066666666666651e-01,-6.55462184873948317e+00,-1.16057233704292439e+01,-6.08108108108106293e+00,1.19156667490469669e+00,1.01023087860549232e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(520,'2026-07-13','159967',0.9244,0.9599,0.9929,0.9035,-6.38297872340425343e+00,-1.4811229428848005e+01,-1.78571428571429047e+00,1.24118754248335649e+00,1.23024132501976968e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(521,'2026-07-13','159968',1.1018600000000001e+01,11.2573,11.27115,1.09586333333333332e+01,-5.22441014724143215e+00,-6.6404543468763677e+00,1.76190476190476452e+00,1.90388375234757667e+00,1.96316130313207337e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(522,'2026-07-13','159971',1.355,1.3976,1.4453,1.37918333333333342e+00,-4.99999999999999289e+00,-1.10583446404341927e+01,-2.01793721973094752e+00,1.22996975672529762e+00,1.3953132763992655e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(523,'2026-07-13','159977',2.01780000000000026e+00,2.08279999999999976e+00,2.1404,2.05538333333333333e+00,-5.67961165048543925e+00,-1.16014558689717883e+01,-2.89855072463767182e+00,1.37541027476099797e+00,1.43501397565292987e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(524,'2026-07-13','159982',2.2534,2.3,2.306,2.24638333333333317e+00,-5.29743812418583814e+00,-6.79487179487178139e+00,1.01899027327467806e+00,1.90444340580386706e+00,1.8893369155684645e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(525,'2026-07-13','159991',0.9172,9.4719999999999993e-01,0.97735,9.34983333333333277e-01,-5.16129032258064768e+00,-1.18881118881118741e+01,-4.02611534276388,1.27074450526418658e+00,1.28079605037577026e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(526,'2026-07-13','159995',1.52579999999999982e+00,1.55,1.49860000000000015e+00,1.25636666666666685e+00,-3.12292358803986092e+00,-1.15827774408732597e+01,2.23154362416107403e+01,1.4628158585222819e+00,2.09036399268273287e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(527,'2026-07-13','510050',3.0356,3.0407,3.0362,3.02161666666666661e+00,-1.14904793171370922e+00,-2.33538760947129553e+00,9.72501676727022257e-01,1.33138679722359065e+00,0.887428927897,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(528,'2026-07-13','510100',2.9798,2.9852,2.98025,2.96088333333333331e+00,-1.13750418200065928e+00,-2.2494211048627255e+00,1.09476565172768047e+00,1.01083462877627416e+00,9.40825317122960469e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(529,'2026-07-13','510190',4.3358,4.3419,4.33315,4.3109,-6.68356764231403666e-01,-1.93401592718999149e+00,1.05509964830010627e+00,2.17889820232539088e+00,1.4195486833848514e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(530,'2026-07-13','510300',4.82180000000000053e+00,4.8729,4.9207,4.87649999999999916e+00,-2.80910395735082252e+00,-4.41621294615849357e+00,-1.61892901618927442e+00,2.20642511488178794e+00,1.10213346995433192e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(531,'2026-07-13','510310',4.6786,4.7269,4.77195,4.72358333333333391e+00,-2.70670331994079527e+00,-4.36499688214507841e+00,-1.39305615087870204e+00,1.74959261717153324e+00,3.57999549215451462e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(532,'2026-07-13','510320',1.29559999999999986e+00,1.3096,1.32225,1.31003333333333338e+00,-2.29357798165137349e+00,-4.05405405405405705e+00,-1.31274131274130567e+00,1.73426247494678253e+00,1.30770946816404953e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(533,'2026-07-13','510330',5.0302,5.08280000000000065e+00,5.1295,5.07923333333333371e+00,-2.81329923273656579e+00,-4.55950540958268746e+00,-1.4365522745410808e+00,1.50933631095643527e+00,4.07527070835747795e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(534,'2026-07-13','510350',5.0516,5.1029,5.14964999999999939e+00,5.09538333333333337e+00,-2.66353309831570683e+00,-4.18353576248313707e+00,-1.25173852573019495e+00,1.08258902180510863e+00,1.44051910340952082e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(535,'2026-07-13','510360',1.8354,1.8569,1.87375,1.85433333333333338e+00,-2.85252960172228675e+00,-4.34552199258082527e+00,-1.4199890770071,1.53794318287224851e+00,1.69781540655242113e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(536,'2026-07-13','510370',1.06940000000000012e+00,1.0807,1.09175,1.08160000000000011e+00,-2.86241920590950549e+00,-4.36363636363636953e+00,-1.22065727699529613e+00,7.99165968543970706e-01,1.06406155534644231e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(537,'2026-07-13','510380',1.42439999999999988e+00,1.43990000000000017e+00,1.45325000000000015e+00,1.44028333333333335e+00,-2.91464260929910068e+00,-4.57025920873124214e+00,-1.47887323943661774e+00,2.06779648896132073e+00,2.63612673242687955e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(538,'2026-07-13','510390',5.42740000000000044e+00,5.4834,5.53345,5.47178333333333366e+00,-2.47903755012760518e+00,-4.44722271834256943e+00,-1.03588605253421839e+00,8.94499739889928768e+00,7.21603415422274707e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(539,'2026-07-13','510500',8.6,8.7934,8.8214,8.6028,-5.90238365493758188e+00,-7.62201916648095334e+00,5.8238291676775411e-01,1.92840800104103538e+00,2.37574902708529345e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(540,'2026-07-13','510510',2.72360000000000024e+00,2.78590000000000026e+00,2.793,2.72096666666666697e+00,-5.84229390681004723e+00,-7.63009845288327159e+00,8.44529750479838803e-01,1.25281383651796884e+00,1.52222359538273832e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(541,'2026-07-13','510530',9.4006,9.6015,9.62355,9.35618333333333218e+00,-5.34081463009145096e+00,-6.79353386535707137e+00,1.45895979507739692e+00,1.53569210438646908e+00,2.53870051770561255e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(542,'2026-07-13','510550',2.17100000000000026e+00,2.2154,2.2225,2.16716666666666668e+00,-6.26408292023432622e+00,-7.51445086705202491e+00,3.86100386100385328e-01,1.73576089812465483e+00,1.41906918116421243e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(543,'2026-07-13','510560',2.0892,2.1374,2.14365,2.0879833333333333e+00,-6.11863615133116933e+00,-7.84044016506191265e+00,6.50976464697028411e-01,9.34334143420188389e-01,1.18976700882722519e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(544,'2026-07-13','510570',1.3334,1.3622,1.36765,1.33323333333333327e+00,-5.58412931667892,-7.35400144196107774e+00,3.1225604996096834e-01,8.64546629523906817e-01,1.1012038309216876e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(545,'2026-07-13','510580',4.42660000000000053e+00,4.5258,4.53745,4.41733333333333355e+00,-5.69159497021839477e+00,-7.105606258148633e+00,1.01606805293006363e+00,1.17011435227470061e+00,1.30890428525876512e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(546,'2026-07-13','510590',9.1188,9.3163,9.33795,9.08498333333333363e+00,-6.23660522931848149e+00,-7.90443111251446506e+00,4.36179981634521318e-01,1.07826746013907506e+01,1.18161018722536308e+01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(547,'2026-07-13','510600',3.8932,3.9036,3.903,3.8769,-1.27551020408163129e+00,-2.00050645733096388e+00,1.30890052356020802e+00,1.59199991434798526e+00,1.58186706825263057e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(548,'2026-07-13','510680',3.2058,3.213,3.20865,3.1878,-7.7833125778332679e-01,-2.02889640332002407e+00,1.07833809070725372e+00,2.94351231959535875e+00,2.26327030057237221e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(549,'2026-07-13','510710',4.317,4.3234,4.31825,4.27445,-1.06333795654182106e+00,-2.32770424463714098e+00,1.34975136159130038e+00,5.71771463650435296e-01,6.54637942673239159e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(550,'2026-07-13','510800',1.40279999999999982e+00,1.4055,1.4035,1.39688333333333347e+00,-1.20652945351313878e+00,-2.24719101123596054e+00,8.69565217391299327e-01,1.18355853123811427e+00,1.02985319588743595e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(551,'2026-07-13','510850',3.57759999999999944e+00,3.5865,3.57999999999999962e+00,3.55735,-1.25173852573019495e+00,-2.44572684803517903e+00,8.2362965066742344e-01,2.0883846941900952e+00,1.04715549528113394e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(552,'2026-07-13','510950',9.94599999999999928e-01,0.9961,0.9945,9.86866666666666558e-01,-7.02106318956874364e-01,-2.0771513353115667e+00,1.53846153846153299e+00,1.17159036681161077e+00,1.23257346815413426e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(553,'2026-07-13','512000',0.5342,0.5426,0.53495,5.14333333333333309e-01,-4.15913200723327935e+00,-1.11940298507462454e+00,6.2124248496993939e+00,8.4048098742630839e-01,6.16893624620033165e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(554,'2026-07-13','512010',0.3564,0.3578,0.3459,3.49916666666666709e-01,-1.90735694822888879e+00,1.12359550561798027e+00,8.43373493975903,7.03513530294776256e-01,7.27637247230556783e-01,1,1,1,1);
INSERT INTO "etf_indicator" VALUES(555,'2026-07-13','512020',1.34540000000000015e+00,1.36609999999999986e+00,1.3787,1.36028333333333351e+00,-3.8742690058479634e+00,-5.73476702508961544e+00,-1.20210368144252344e+00,1.12547696781492567e+00,1.22452057872279929e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(556,'2026-07-13','512050',1.2702,1.2896,1.30195000000000016e+00,1.28516666666666656e+00,-3.94736842105262164e+00,-5.77069096431281902e+00,-1.19426751592356383e+00,1.28076947405455099e+00,1.30874608879896525e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(557,'2026-07-13','512080',1.3654,1.38439999999999985e+00,1.39675,1.3795666666666666e+00,-3.39350180505414433e+00,-5.30785562632696272e+00,-5.94353640416045436e-01,2.43921326372459201e+00,1.21669702568723292e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(558,'2026-07-13','512100',3.2968,3.406,3.46109999999999962e+00,3.42593333333333349e+00,-8.00582241630276669e+00,-9.06474820143884407e+00,-4.50287095799335457e+00,1.55014376509930262e+00,2.47504600134993202e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(559,'2026-07-13','512370',1.2126,1.2271,1.23975000000000012e+00,1.2250833333333333e+00,-3.649635036496357e+00,-4.19354838709677935e+00,-1.57415078707540123e+00,8.72989229537623256e-01,0.544273950727619,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(560,'2026-07-13','512480',1.361,1.3795,1.32735,1.10323333333333328e+00,-3.29835082458770356e+00,-1.13402061855670144e+01,2.25071225071225242e+01,8.83745934507976893e-01,1.44131542834570858e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(561,'2026-07-13','512500',4.7726,4.8832,4.89530000000000065e+00,4.7669666666666659e+00,-5.76569208750766826e+00,-7.28223697445182782e+00,9.85977212971067551e-01,1.34478410905687395e+00,1.71442290408140674e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(562,'2026-07-13','512510',2.5134,2.5667,2.57139999999999968e+00,2.50563333333333337e+00,-5.52099533437013789e+00,-7.25190839694656,1.2922050854522693e+00,1.31055370774577717e+00,1.35109309641323482e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(563,'2026-07-13','512760',1.4392,1.456,1.40410000000000012e+00,1.18038333333333311e+00,-2.26628895184136647e+00,-1.02730819245773865e+01,2.38779174147216934e+01,0.89679363628224,1.02486268366910038e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(564,'2026-07-13','512890',1.1144,1.1007,1.10775,1.15223333333333344e+00,1.61870503597121295e+00,3.76492194674011848e+00,-3.58361774744028194e+00,1.16279001849602758e+00,1.1105716693391654e+00,1,1,1,0);
INSERT INTO "etf_indicator" VALUES(565,'2026-07-13','512930',0.7402,0.7438,7.3944999999999994e-01,6.95316666666666693e-01,1.39082058414463638e+00,-2.5401069518716568e+00,1.02874432677760871e+01,8.34918178894650586e-01,1.0382023136587084e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(566,'2026-07-13','513310',5.8926,6.0784,6.1929,5.5313166666666671e+00,-7.62376237623762,-1.48463644660784872e+01,-0.779865295994342,7.17386099988620462e-01,8.35005196008735461e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(567,'2026-07-13','515070',1.318,1.3231,1.3155,1.23708333333333331e+00,1.17096018735363127e+00,-2.7027027027027084e+00,1.02978723404255401e+01,9.5641357713395636e-01,1.38769112372296232e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(568,'2026-07-13','515130',1.5914,1.6079,1.6224,1.60340000000000015e+00,-2.85536933581627128e+00,-4.22276621787025519e+00,-1.32408575031526254e+00,3.1617024802635063e+00,3.63354809418427127e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(569,'2026-07-13','515310',1.435,1.4495,1.463,1.45005,-2.55172413793103292e+00,-4.13839891451831576e+00,-1.2578616352201255e+00,1.94814853912128094e+00,2.26034587375803885e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(570,'2026-07-13','515330',1.3847999999999998e+00,1.3996,1.41265,1.3987166666666666e+00,-2.71428571428570242e+00,-4.28671820098383,-1.30434782608693788e+00,2.00328854058344907e+00,1.70591502314602272e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(571,'2026-07-13','515350',6.4554,6.5232,6.58229999999999915e+00,6.51951666666666618e+00,-2.77139794824682317e+00,-3.93343419062027743e+00,-1.41282409563732169e+00,1.4730849521341276e+00,1.49407242415602325e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(572,'2026-07-13','515360',6.9226,6.99710000000000054e+00,7.06234999999999946e+00,6.95768333333333366e+00,-3.02338847689674894e+00,-4.37350583602869047e+00,-9.9009900990100208e-01,1.13822274599072414e+00,1.01708584216237873e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(573,'2026-07-13','515380',5.58,5.63819999999999943e+00,5.69159999999999932e+00,5.63256666666666649e+00,-2.48226950354609732e+00,-4.01396160558464831e+00,-1.20352074726064461e+00,2.17950246318096585e+00,2.25066122176039051e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(574,'2026-07-13','515390',1.40079999999999982e+00,1.4144,1.42855,1.4146,-2.54596888260254505e+00,-4.43828016643551492e+00,-1.36005726556908124e+00,2.71205823421973768e+00,2.66651721359034254e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(575,'2026-07-13','515530',4.6374,4.7386,4.75455,4.63599999999999923e+00,-5.45377974310380331e+00,-7.11625982623085295e+00,1.1945007888212844e+00,1.66594007432521507e+00,1.6474392482015161e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(576,'2026-07-13','515550',1.89259999999999983e+00,1.93099999999999982e+00,1.93005,1.88695,-4.71014492753623059e+00,-5.44427324088341269e+00,1.99445983379502589e+00,8.60198127624322239e-01,4.50232715799103677e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(577,'2026-07-13','515660',5.98919999999999941e+00,6.0511,6.11020000000000074e+00,6.0457833333333335e+00,-2.64462809917355157e+00,-4.18090125264357581e+00,-1.29043070219541089e+00,3.16136262797859801e+00,1.17917226841823374e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(578,'2026-07-13','515880',0.7688,0.7936,8.42800000000000104e-01,7.76633333333333286e-01,-2.24570673712021218e+00,-1.37529137529137539e+01,-6.56565656565657462e+00,6.85368818607683283e-01,1.01589222077541685e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(579,'2026-07-13','515980',1.202,1.2153,1.21145,1.12703333333333333e+00,8.48176420695345711e-02,-4.29845904298460368e+00,1.01774042950513621e+01,2.55912446651278768e+00,2.17512724439498761e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(580,'2026-07-13','516020',8.51399999999999934e-01,8.91200000000000103e-01,9.09500000000000086e-01,9.25716666666666632e-01,-1.27982646420824242e+01,-1.28927410617551423e+01,-1.06666666666666678e+01,5.43547443326712675e-01,0.526938683509235,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(581,'2026-07-13','516300',3.396,3.501,3.55645000000000033e+00,3.52673333333333349e+00,-8.01018964053213,-8.93807789296721111e+00,-4.74794841735052308e+00,1.7841881393008443e+00,2.32795452396859348e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(582,'2026-07-13','516350',2.1678,2.1962,2.11065,1.76953333333333318e+00,-3.37711069418387133e+00,-1.13597246127366542e+01,2.33532934131736702e+01,9.77518537985568203e-01,1.12911852338505935e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(583,'2026-07-13','516640',1.9032,1.9271,1.85855,1.56195,-2.82515991471215,-10.986328125,2.36770691994572679e+01,0.977696147806875,1.26870651405336043e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(584,'2026-07-13','516830',1.076,1.0869,1.0951,1.07606666666666672e+00,-2.2119815668202758e+00,-4.41441441441442528e+00,-5.62324273664482898e-01,1.06966661779889404e+00,1.30552542872158139e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(585,'2026-07-13','516920',1.862,1.8817,1.80949999999999988e+00,1.51795,-2.95404814004376348e+00,-1.0584677419354838e+01,2.39692522711390623e+01,9.32002259134942057e-01,9.87220439827907303e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(586,'2026-07-13','517800',1.1218,1.1209,1.11735,1.09498333333333319e+00,0.917431192660545,-1.96078431372549433e+00,5.66762728146015248e+00,1.24784949321359972e+00,1.09955610107808876e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(587,'2026-07-13','530000',1.3828,1.3864,1.38505000000000011e+00,1.37718333333333342e+00,-1.22390208783296206e+00,-2.55681818181816566e+00,1.17994100294984693e+00,1.06373781493180352e+00,4.75494690716927181e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(588,'2026-07-13','530050',1.1834,1.1862,1.18335000000000012e+00,1.1741666666666668e+00,-7.575757575757458e-01,-1.83180682764363389e+00,1.46299483648881789e+00,1.51908174275825258e+00,1.1814339262608724e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(589,'2026-07-13','560010',3.376,3.48599999999999976e+00,3.54549999999999965e+00,3.5111,-8.19345661450925355e+00,-9.65845464725644298e+00,-4.92044784914555943e+00,1.07859158564145807e+00,1.16074042627388229e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(590,'2026-07-13','560100',1.4128,1.4492,1.4606,1.4290166666666666e+00,-6.49794801641586694e+00,-7.75978407557355076e+00,-1.08538350217075585e+00,1.34811723667690186e+00,1.4966497552225475e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(591,'2026-07-13','560110',1.21939999999999981e+00,1.26,1.28034999999999987e+00,1.26708333333333333e+00,-8.12302839116718544e+00,-9.89945862335652648e+00,-5.052974735126325e+00,1.23044125363089573e+00,2.61385832251477,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(592,'2026-07-13','560180',1.22680000000000011e+00,1.2394,1.2488,1.23283333333333322e+00,-2.74636510500807506e+00,-4.89731437598736,-1.31147540983607147e+00,1.8568663621180963e+00,1.70471795477307663e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(593,'2026-07-13','560330',1.17439999999999988e+00,1.1721,1.17415,1.19948333333333323e+00,-5.89721988205571534e-01,1.81190681622087623e+00,-2.6402640264026389e+00,4.282503505231257e+00,6.12120395257373317e+00,1,1,1,0);
INSERT INTO "etf_indicator" VALUES(594,'2026-07-13','560510',1.2504,1.26929999999999987e+00,1.2806,1.26348333333333329e+00,-3.7765538945711885e+00,-5.55984555984554429e+00,-9.71659919028344809e-01,1.27269392974287254e+00,1.50285572730158278e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(595,'2026-07-13','560530',1.2868,1.3062,1.3182,1.3015333333333332e+00,-3.74331550802138313e+00,-5.40540540540540526e+00,-1.09890109890109499e+00,1.26460905015774294e+00,1.26096730915897947e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(596,'2026-07-13','560590',1.53520000000000012e+00,1.5729,1.58735,1.5869333333333333e+00,-7.23725613593454397e+00,-6.35324015247776863e+00,-2.5132275132275117e+00,1.35199562561481756e+00,1.41857159432778012e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(597,'2026-07-13','560610',1.25339999999999984e+00,1.2708,1.2831,1.26480000000000014e+00,-3.07328605200944959e+00,-5.09259259259259344e+00,-4.85436893203883279e-01,1.16305559162889227e+00,1.03343535627873417e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(598,'2026-07-13','560630',1.2308,1.2651,1.26795,1.24718333333333331e+00,-9.21766072811773895e+00,-4.24836601307190253e+00,-3.45963756177924963e+00,6.63285727863529683e-01,9.98510177638436302e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(599,'2026-07-13','560750',1.3976,1.4183,1.4317,1.4102,-3.65939479239971721e+00,-5.45580110497236869e+00,-1.1552346570397165e+00,1.23139200984503216e+00,1.80109081341701871e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(600,'2026-07-13','560770',1.08360000000000011e+00,1.1139,1.11705,1.10081666666666655e+00,-9.39420544337137286e+00,-4.26716141001856108e+00,-3.82106244175208775e+00,6.68073752929870146e-01,8.53887082687593834e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(601,'2026-07-13','560780',1.3464,1.35809999999999986e+00,1.2685,9.7628333333333328e-01,-8.58704137392651834e-01,-1.05003523608174766e+01,3.0256410256410259e+01,1.29463075538365,1.88005763110808765e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(602,'2026-07-13','560950',1.4324,1.45679999999999987e+00,1.4588,1.44348333333333322e+00,-5.24523160762943,-4.66072652501713413e+00,-5.00715307582255686e-01,8.69024064522117334e-01,1.19998327266571,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(603,'2026-07-13','561000',1.3346,1.33930000000000015e+00,1.3438,1.3341,-1.71641791044777614e+00,-2.44444444444446,7.5987841945290846e-02,1.52225724732879452e+00,1.44392134860778198e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(604,'2026-07-13','561090',1.297,1.313,1.3227,1.29493333333333326e+00,-3.36648814078042146e+00,-5.81655480984341,-4.72813238770686261e-01,1.5461350878922635e+00,1.60325208513515482e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(605,'2026-07-13','561280',1.6738,1.72250000000000014e+00,1.75355,1.76266666666666682e+00,-8.46681922196795788e+00,-8.20424555364314,-5.4373522458628809e+00,1.20941088886878822e+00,1.15756300491795061e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(606,'2026-07-13','561300',1.043,1.0548,1.06485,1.05115,-3.40586565752129,-4.49017773620206117e+00,-1.82692307692309263e+00,1.49196086277803141e+00,1.52678581484466469e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(607,'2026-07-13','561350',1.34080000000000021e+00,1.3707,1.37515,1.34185,-5.90379008746356781e+00,-7.58768790264854331e+00,7.02028081123229341e-01,9.34897051604961393e-01,9.36389665841553808e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(608,'2026-07-13','561550',1.511,1.5525,1.55255,1.49893333333333322e+00,-7.70210057288351901e+00,-7.99492385786803083e+00,0.554785020804438,1.18723659065880671e+00,1.05728757197479739e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(609,'2026-07-13','561590',1.5878,1.63810000000000011e+00,1.6603,1.62348333333333338e+00,-7.77108433734939829e+00,-8.48774656306038366e+00,-2.67005721551176744e+00,1.38040834809902879e+00,1.24389579660789806e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(610,'2026-07-13','561900',1.019,1.02959999999999984e+00,1.03795,1.02486666666666659e+00,-2.5267249757045751e+00,-4.3851286939942895e+00,-1.08481262327417837e+00,1.04529839058415841e+00,1.11331450264028108e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(611,'2026-07-13','561930',1.6098,1.62719999999999975e+00,1.6408999999999998e+00,1.62006666666666654e+00,-2.45700245700244401e+00,-4.10628019323669946e+00,-9.97506234413969572e-01,3.38287272539002303e+00,5.40053499840170392e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(612,'2026-07-13','561950',1.42899999999999982e+00,1.4522,1.46285,1.46423333333333327e+00,-5.1124744376278226e+00,-4.52674897119341679e+00,-7.132667617689048e-01,9.26342643973395607e-01,9.29089424390409868e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(613,'2026-07-13','561980',8.67200000000000081e-01,0.8708,0.8224,0.65535,2.30862697448359632e+00,-6.8584070796460228e+00,3.0139103554868619e+01,1.06762037745093,1.81061723941105068e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(614,'2026-07-13','561990',1.0188,1.0345,1.04749999999999987e+00,1.05243333333333333e+00,-4.97131931166348,-5.51330798479088279e+00,-3.58874878758486115e+00,1.22326100492025058e+00,1.36924768731270285e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(615,'2026-07-13','562070',1.0544,1.0652,1.07435,1.0596,-3.16868592730662479e+00,-4.23963133640553557e+00,-1.32953466286799271e+00,9.29120259491534317e-01,1.10038816896817981e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(616,'2026-07-13','562310',1.1426,1.1641,1.17859999999999986e+00,1.14553333333333329e+00,-3.97236614853193614e+00,-7.94701986754965439e+00,-6.25558534405712407e-01,1.11031755992596647e+00,1.02191635330347652e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(617,'2026-07-13','562320',1.26939999999999986e+00,1.2658,1.2683,1.29665,-9.35307872174595544e-01,1.59872102318145969e+00,-2.9770992366412341e+00,1.67768649814578796e+00,2.01683193977414632e+00,1,1,1,0);
INSERT INTO "etf_indicator" VALUES(618,'2026-07-13','562330',1.20060000000000011e+00,1.21709999999999984e+00,1.2319,1.26975,-4.98793242156074789e+00,-3.03776683087027,-6.04614160700078784e+00,4.92059557487014076e-01,5.06717845781872622e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(619,'2026-07-13','562340',1.459,1.4844,1.48485,1.43598333333333338e+00,-5.34045393858478867e+00,-5.46666666666667566e+00,1.06913756236635126e+00,2.95711955604877685e+00,5.37450034384887054e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(620,'2026-07-13','562360',1.1846,1.217,1.22165,1.20414999999999983e+00,-9.39759036144579518e+00,-4.16312659303315069e+00,-4.00000000000001421e+00,6.96408190020368467e-01,9.0408126928097976e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(621,'2026-07-13','562500',1.0956,1.12609999999999987e+00,1.13019999999999987e+00,1.11493333333333333e+00,-9.47002606429191473e+00,-4.4912923923006387e+00,-4.13983440662373247e+00,8.42199643008995191e-01,1.03128985099419701e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(622,'2026-07-13','562520',1.4372,1.475,1.48375000000000012e+00,1.47616666666666662e+00,-7.82608695652174901e+00,-7.01754385964913396e+00,-2.33876683203403379e+00,1.11753180585407463e+00,1.18520615408183371e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(623,'2026-07-13','562530',1.18659999999999987e+00,1.191,1.19994999999999985e+00,1.27738333333333331e+00,-2.80065897858320367e+00,8.54700854700851664e-01,-4.37601296596434874e+00,1.09180835344068905e+00,1.06558027253494236e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(624,'2026-07-13','562590',1.2862,1.2973,1.21305,9.3299999999999994e-01,-5.70962479608472239e-01,-9.97045790251107533e+00,3.10752688172043036e+01,9.75087264800432507e-01,2.17694474710973429e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(625,'2026-07-13','563030',1.6738,1.70869999999999988e+00,1.70335,1.64171666666666671e+00,-5.98837209302325312e+00,-5.98837209302325312e+00,1.12570356472796451e+00,2.35800030325086718e+00,1.72593280005123039e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(626,'2026-07-13','563090',1.385,1.4013,1.39544999999999985e+00,1.34219999999999983e+00,-3.05832147937410425e+00,-4.75192173305381,3.65019011406844118e+00,1.61011562175569666e+00,1.82840245793351363e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(627,'2026-07-13','563220',1.3284,1.3487,1.36085,1.3430333333333333e+00,-3.85185185185185075e+00,-5.73710965867828548e+00,-1.06707317073170271e+00,9.81760133204448659e-01,1.04559692567994133e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(628,'2026-07-13','563360',1.34819999999999984e+00,1.3688,1.3819,1.3644,-3.86579139314369157e+00,-5.72246065808296222e+00,-1.12528132033007377e+00,1.15450210779566098e+00,1.15932431077529,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(629,'2026-07-13','563500',6.70400000000000106e-01,0.6804,6.86099999999999932e-01,6.75233333333333352e-01,-3.81791483113069762e+00,-5.75539568345322383e+00,-9.07715582450829838e-01,1.36597237864961895e+00,1.50014418769245261e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(630,'2026-07-13','563520',1.2334,1.24670000000000014e+00,1.25845,1.24716666666666653e+00,-2.56615878107457895e+00,-4.17981072555204669e+00,-1.29975629569455408e+00,1.31121738267265675e+00,1.32881285135487581e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(631,'2026-07-13','563550',1.3216,1.3424,1.3507,1.32868333333333343e+00,-4.45434298440979858e+00,-5.3676470588235432e+00,3.11769290724872583e-01,1.53602113670264528e+00,2.01736686522987485e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(632,'2026-07-13','563600',1.095,1.1109,1.1228,1.1190833333333332e+00,-4.47227191413238678e+00,-4.81283422459893905e+00,-2.01834862385321667e+00,5.52793184732234266e+00,2.87015960339929909e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(633,'2026-07-13','563630',1.3324,1.34979999999999988e+00,1.36245,1.3378333333333332e+00,-4.54878943506970046e+00,-5.31295487627366824e+00,-1.06463878326996663e+00,4.57431262109796232e-01,7.84369338118241499e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(634,'2026-07-13','563650',1.3448,1.3663,1.37780000000000013e+00,1.35916666666666663e+00,-3.51133869787857433e+00,-5.2442528735632159e+00,-8.27067669172942832e-01,1.11763921195727689e+00,1.43549687559965244e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(635,'2026-07-13','563660',1.3128,1.3315,1.34345,1.32751666666666667e+00,-3.90390390390390473e+00,-5.8130978660779986e+00,-1.53846153846154409e+00,6.54634373759127252e-01,3.68286693718110846e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(636,'2026-07-13','563750',1.1776,1.2052,1.20794999999999985e+00,1.17631666666666645e+00,-5.64315352697095651e+00,-7.18367346938776307e+00,1.06666666666666021e+00,9.48039107325478469e-01,1.10848159643205312e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(637,'2026-07-13','563800',1.2734,1.2929,1.30515,1.28826666666666667e+00,-4.01234567901235195e+00,-5.75757575757576134e+00,-1.19142176330420124e+00,1.325357250044352e+00,1.47100203185760269e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(638,'2026-07-13','563860',1.3524,1.3734,1.38545,1.3628,-3.99999999999999245e+00,-5.71428571428570464e+00,-1.12359550561796917e+00,9.02735437829847553e-01,9.4499525144505414e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(639,'2026-07-13','563880',1.3162,1.33599999999999985e+00,1.34835,1.33105,-3.80881254667662094e+00,-5.64102564102564318e+00,-9.23076923076926458e-01,1.0828522413109245e+00,1.03184975941875567e+00,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(640,'2026-07-13','588000',2.1816,2.1879,2.1134,1.86216666666666674e+00,-7.56143667296782506e-01,-6.58362989323844072e+00,1.95899772209567224e+01,1.0281556667899292e+00,1.13285389670126934e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(641,'2026-07-13','588010',1.31720000000000014e+00,1.3824,1.38019999999999987e+00,1.19103333333333338e+00,-8.22122571001495572e+00,-1.58904109589041109e+01,2.589807852965742e+00,7.82735836117018579e-01,0.878479752422153,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(642,'2026-07-13','588020',1.04559999999999986e+00,1.0892,1.09145,9.41383333333333349e-01,-9.65073529411765207e+00,-1.47441457068516967e+01,6.38528138528138278e+00,2.00453614930103,3.56960230950792523e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(643,'2026-07-13','588030',2.06299999999999972e+00,2.10850000000000026e+00,2.0732,1.85203333333333342e+00,-6.10576923076923172e+00,-9.07821229050279576e+00,8.92359174567765123e+00,1.25800256274575805e+00,1.24194286624202288e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(644,'2026-07-13','588040',2.094,2.1071,2.0377,1.8015,5.42941757156967241e-01,-5.99907706506690452e+00,1.99646643109540704e+01,1.75221288801977581e+00,2.39063597943489503e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(645,'2026-07-13','588050',2.1138,2.12,2.05075,1.81086666666666662e+00,-4.86854917234658124e-01,-6.32447296058661301e+00,1.96021064950263408e+01,8.55510046406940061e-01,9.26127816163824335e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(646,'2026-07-13','588060',1.3132,1.3175,1.27274999999999982e+00,1.12301666666666677e+00,-6.27450980392152413e-01,-6.28698224852072229e+00,1.96411709159584511e+01,1.4557492574380495e+00,1.56204359177807639e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(647,'2026-07-13','588070',2.6902,2.8023,2.81085,2.42508333333333325e+00,-1.01320014270424465e+01,-1.50134952766531668e+01,5.88482555695670761e+00,1.21230188850507181e+00,1.17453460528061,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(648,'2026-07-13','588080',2.1152,2.1206,2.04885,1.8056833333333333e+00,-8.76338851022384623e-01,-6.60550458715596366e+00,1.96942974720752488e+01,1.26252319684411462e+00,1.50293946878722595e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(649,'2026-07-13','588090',2.1216,2.128,2.05545,1.81528333333333336e+00,-6.3229571984435573e-01,-6.28440366972476915e+00,1.92644483362521832e+01,5.35426971901904913e-01,6.7536230793329155e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(650,'2026-07-13','588100',3.2786,3.289,3.17825,2.74411666666666631e+00,-1.89693329117923692e-01,-6.45925925925925348e+00,2.10042161747796107e+01,1.38097761730000168e+00,1.49751805205964361e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(651,'2026-07-13','588110',3.0684,3.199,3.2006,2.75608333333333366e+00,-1.05886016817190906e+01,-1.51846381093057587e+01,5.98006644518271901e+00,0.991404722762131,1.2289597822245597e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(652,'2026-07-13','588120',1.0402,1.0643,1.04605,9.33266666666666688e-01,-6.29170638703526741e+00,-9.31734317343174645e+00,8.61878453038673697e+00,1.00675378359948086e+00,1.3590833183939126e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(653,'2026-07-13','588140',1.4106,1.4601,1.4531,1.37083333333333334e+00,-8.52233676975945364e+00,-9.88490182802980221e+00,1.21673003802280632e+00,1.06536348608155018e+00,6.00319830360920292e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(654,'2026-07-13','588150',1.46200000000000018e+00,1.4655,1.4147,1.24643333333333328e+00,-0.494350282485867,-5.94125500667556139e+00,1.99148936170212778e+01,1.68231899463787892e+00,1.44243609803015204e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(655,'2026-07-13','588160',1.3466,1.41299999999999981e+00,1.4111,1.21665,-8.79360465116279,-1.57152451309603868e+01,2.5326797385620825e+00,1.70901521404901823e+00,2.19271858063368307e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(656,'2026-07-13','588170',1.2812,1.2795,1.185,8.94450000000000078e-01,1.84563758389262311e+00,-8.03030303030303116e+00,3.65579302587176542e+01,1.04265023986407801e+00,2.52647039381086546e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(657,'2026-07-13','588180',1.3404,1.3442,1.29749999999999987e+00,1.14410000000000011e+00,-6.16808018504244604e-01,-6.45863570391872521e+00,1.93518518518518405e+01,6.86729018156413739e-01,0.729760839268583,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(658,'2026-07-13','588190',2.0462,2.0908,2.05495,1.83836666666666648e+00,-5.87378640776699,-8.83874000940290116e+00,8.56662933930572,8.72607595503067767e-01,8.61378412098466439e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(659,'2026-07-13','588200',4.542,4.5649999999999995e+00,4.38585,3.66885,-1.59018627896411191e+00,-8.20089001907185,2.39130434782608638e+01,9.88128068037717133e-01,1.10584907771963614e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(660,'2026-07-13','588210',2.0602,2.1068,2.0686,1.84351666666666669e+00,-5.88519054510371297e+00,-8.78915381019166375e+00,8.93355667225015359e+00,1.14043079044061967e+00,1.16092793882511857e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(661,'2026-07-13','588220',2.0584,2.1015,2.06575,1.8438,-6.3675832127351617e+00,-9.25666199158483493e+00,8.49636668529905136e+00,1.16540740510471119e+00,1.36644745662143463e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(662,'2026-07-13','588230',2.101,2.1746,2.163,2.04161666666666663e+00,-7.96665122742008513e+00,-9.51730418943533784e+00,1.68884339815762452e+00,1.11488545513724979e+00,9.51670369409117311e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(663,'2026-07-13','588240',1.939,2.0096,2.00065,1.87765,-8.38741887169246425e+00,-9.65041851304776443e+00,2.05784204671857207e+00,8.45803232712999286e-01,8.48764187254331115e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(664,'2026-07-13','588260',3.192,3.20399999999999973e+00,3.0977,2.68035,-1.38530927835052164e+00,-7.24242424242423865e+00,2.03696421549351072e+01,1.3009640180023414e+00,1.94876184703441923e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(665,'2026-07-13','588270',1.9654,2.0362,2.02414999999999967e+00,1.9055833333333334e+00,-8.14814814814813814e+00,-9.53307392996109,1.80623973727422892e+00,9.92855988363639196e-01,1.06590389413213726e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(666,'2026-07-13','588280',1.4874,1.4952,1.4429,1.27418333333333322e+00,-2.77970813064631894e-01,-6.08638743455497355e+00,1.92851205320033294e+01,1.04836312654206875e+00,1.44823457678160205e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(667,'2026-07-13','588290',4.4458,4.4582,4.28459999999999929e+00,3.5884166666666668e+00,-1.25639832480224367e+00,-8.05892547660311819e+00,2.42025168276265745e+01,1.06130541827601199e+00,1.15806953308305415e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(668,'2026-07-13','588300',1.3506,1.3833,1.39655,1.27705,-4.05305821665438159e+00,-1.08219178082191724e+01,3.33333333333334369e+00,1.11664333721814301e+00,1.01528667928490623e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(669,'2026-07-13','588310',1.40839999999999987e+00,1.4403,1.457,1.33623333333333316e+00,-4.02542372881356,-1.08267716535433109e+01,2.79878971255671515e+00,1.65639188340824294e+00,1.74123352525823338e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(670,'2026-07-13','588320',2.07400000000000028e+00,2.11880000000000023e+00,2.141,1.96631666666666671e+00,-3.89423076923076649e+00,-1.04791759964173785e+01,3.7902388369678075e+00,9.93027166388190773e-01,8.67389801431639129e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(671,'2026-07-13','588330',1.3328,1.36209999999999986e+00,1.3773,1.25919999999999987e+00,-3.74531835205992313e+00,-1.08258154059680862e+01,3.6290322580645018e+00,1.1421181212468483e+00,9.63652963756130742e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(672,'2026-07-13','588350',2.0406,2.0866,2.10395,1.92296666666666671e+00,-4.16462518373346135e+00,-1.09289617486338919e+01,3.2734952481520585e+00,1.43100687637679491e+00,1.29126971578708915e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(673,'2026-07-13','588360',1.4222,1.4546,1.46995,1.34748333333333336e+00,-4.0587823652904138e+00,-1.09161793372319682e+01,3.1602708803611712e+00,1.08041771017849108e+00,0.97408749320342,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(674,'2026-07-13','588370',2.1552,2.1617,2.10620000000000029e+00,1.86619999999999985e+00,-1.95331110052408,-7.1718538565629375e+00,1.59436619718309913e+01,1.11503032723160155e+00,1.37893207710462339e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(675,'2026-07-13','588380',1.337,1.3686,1.38245,1.26510000000000011e+00,-3.94932935916543215e+00,-1.07340720221606673e+01,3.36808340016037099e+00,1.56383405522769791e+00,1.40435900885387821e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(676,'2026-07-13','588390',1.4322,1.4645,1.4749,1.34586666666666654e+00,-3.77094972067039124e+00,-1.07512953367875692e+01,3.84325546345138935e+00,1.45353311395947093e+00,1.19506722287925226e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(677,'2026-07-13','588400',1.3312,1.3613,1.37165,1.25318333333333331e+00,-3.98196844477836098e+00,-1.06293706293706264e+01,3.39805825242718295e+00,9.78974057441037825e-01,7.75181781137772141e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(678,'2026-07-13','588410',1.4436,1.46479999999999987e+00,1.459,1.36206666666666675e+00,-1.33520730850317237e+00,-6.4623584277148538e+00,9.51638065522619669e+00,8.27660100202124771e-01,7.09988689495471447e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(679,'2026-07-13','588420',1.4442,1.4661,1.4592,1.36321666666666674e+00,-1.61403508771931214e+00,-6.78191489361702437e+00,9.2751363990647,8.88009952437661454e-01,0.933781040253179,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(680,'2026-07-13','588430',1.4734,1.49670000000000014e+00,1.48865,1.38901666666666656e+00,-1.44528561596697358e+00,-6.52741514360314312e+00,9.48012232415900158e+00,1.34810329121307481e+00,1.23517919735067072e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(681,'2026-07-13','588450',2.5716,2.5985,2.54849999999999976e+00,2.28988333333333349e+00,-2.20298977183318589e+00,-7.6523031203566072e+00,1.35678391959799036e+01,1.37365328057813029e+00,1.34248115734571515e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(682,'2026-07-13','588460',2.521,2.5501,2.47525,2.16091666666666659e+00,-2.4889602569249436e+00,-7.71276595744682147e+00,1.71731789676796928e+01,1.31495969965145564e+00,1.25959834773937573e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(683,'2026-07-13','588470',1.02159999999999984e+00,1.0377,1.03185,NULL,-1.48662041625370333e+00,-6.4030131826742,9.59206174200661898e+00,1.18471376962377683e+00,9.8532757422438777e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(684,'2026-07-13','588480',1.0886,1.1055,1.099,NULL,-1.85356811862835701e+00,-5.61497326203209645e+00,9.28792569659442435e+00,1.06429482273114905e+00,7.41508488946349575e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(685,'2026-07-13','588500',2.9968,3.0834,3.04695,2.72803333333333331e+00,-6.22929092113981841e+00,-1.0584518167456558e+01,8.38759096131749259e+00,6.25105036358403753e-01,9.07354096063376469e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(686,'2026-07-13','588510',1.0299999999999998e+00,1.04559999999999986e+00,1.03895,NULL,-9.85221674876846087e-01,-5.81068416119963071e+00,9.95623632385118639e+00,1.52026717638579622e+00,9.29997286941082856e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(687,'2026-07-13','588520',1.60180000000000011e+00,1.63419999999999987e+00,1.60399999999999987e+00,1.5314833333333333e+00,-3.61370716510903689e+00,-6.69481302774427255e+00,7.95533845080249601e+00,1.14112035604030367e-01,1.8094451716811169e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(688,'2026-07-13','588550',1.6428,1.67,1.65255000000000018e+00,1.48511666666666664e+00,-3.80601596071209469e+00,-8.8423502036067525e+00,8.81944444444444641e+00,0.530865023689392,0.519119187435415,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(689,'2026-07-13','588660',2.1852,2.2346,2.25940000000000029e+00,2.07401666666666661e+00,-4.27661510464058,-1.0771840542832912e+01,3.08672219500245592e+00,1.23572761823504362e+00,1.40074684515671266e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(690,'2026-07-13','588670',2.10240000000000026e+00,2.1358,2.0974,1.87906666666666666e+00,-2.98220298220299717e+00,-7.89954337899543279e+00,1.24303232998885135e+01,1.45675769552182687e+00,1.58105088251069592e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(691,'2026-07-13','588680',2.88239999999999962e+00,2.93620000000000036e+00,2.88375,2.60836666666666694e+00,-5.40819841543230772e+00,-8.1298093007694856e+00,8.70942201108473312e+00,1.54784535061196626e+00,0.96068518524995,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(692,'2026-07-13','588690',1.4192,1.4453,1.43245,1.32496666666666684e+00,-4.67550593161200112e+00,-9.41644562334217383e+00,7.8137332280978855e+00,1.36860115089701772e+00,3.10953094199885704e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(693,'2026-07-13','588710',3.9594,3.95039999999999968e+00,3.6612,2.77105000000000023e+00,1.81867535287729698e+00,-8.55680156021454507e+00,3.66982507288629662e+01,1.06902642151852611e+00,1.72999941085432618e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(694,'2026-07-13','588720',2.0631999999999997e+00,2.0713,2.00925,1.77641666666666653e+00,-7.44786494538218768e-01,-6.41385767790262306e+00,1.89880952380952585e+01,1.50758776904578062e+00,1.50618655283848057e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(695,'2026-07-13','588730',1.795,1.8165,1.78954999999999975e+00,1.72378333333333322e+00,-0.909607731665707,-6.29032258064515836e+00,1.0456273764258551e+01,7.82484635136112549e-01,9.31061293083704555e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(696,'2026-07-13','588750',3.02920000000000033e+00,3.0393,2.92049999999999965e+00,2.44446666666666656e+00,-1.16040955631400155e+00,-7.88804071246820281e+00,2.43452125375697612e+01,7.92566641462608134e-01,8.92364455148476509e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(697,'2026-07-13','588760',0.9112,0.923,0.9094,8.80766666666666697e-01,-8.94854586129756324e-01,-6.04453870625661871e+00,1.01990049751243816e+01,1.09341559919829078e+00,1.33304984047579777e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(698,'2026-07-13','588770',2.3136,2.3209,2.2504,1.9491,-3.11526479750767748e-01,-6.78318768206407352e+00,2.10810810810810878e+01,1.21357151526533812e+00,1.17475074391592726e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(699,'2026-07-13','588780',1.27199999999999979e+00,1.2999,1.2642,1.12505,-6.62509742790334854e+00,-1.05970149253731378e+01,1.60852713178294415e+01,0.690596822391484,8.74135938961132397e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(700,'2026-07-13','588790',0.9614,9.73000000000000087e-01,0.9593,0.92925,-1.06157112526538144e+00,-6.51955867602808147e+00,9.90566037735849391e+00,9.98192909341772183e-01,1.0844221182839977e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(701,'2026-07-13','588800',2.0342,2.0797,2.04315,1.82273333333333331e+00,-6.19512195121950703e+00,-8.81934566145091736e+00,8.95184135977338257e+00,0.906864690407293,9.10402256297997314e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(702,'2026-07-13','588810',3.207,3.2201,3.1023,2.59926666666666639e+00,-9.96143958868900281e-01,-7.97491039426523329e+00,2.43843358901897566e+01,1.06871622980269664e+00,1.22754741642429787e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(703,'2026-07-13','588820',2.2476,2.3259,2.3159,2.18155,-8.50604490500862553e+00,-9.90646258503400289e+00,1.04911778731522353e+00,1.11174797280036741e+00,1.14504750121134679e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(704,'2026-07-13','588840',1.92079999999999984e+00,1.92079999999999984e+00,1.85625,1.6374,-2.70270270270278611e-01,-6.01120733571065546e+00,1.94174757281553525e+01,1.67488764037081061e+00,2.7252613976300597e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(705,'2026-07-13','588850',2.0578,2.1485,2.1719,1.92083333333333339e+00,-1.01265822784810115e+01,-1.34537246049661334e+01,-1.56249999999991118e-01,6.52084559264313079e-01,4.97921424044258764e-01,0,0,0,0);
INSERT INTO "etf_indicator" VALUES(706,'2026-07-13','588870',2.1046,2.1088,2.0352,1.79508333333333336e+00,-5.40275049115923611e-01,-6.55283802491923861e+00,1.98224852071005912e+01,1.33724079070024659e+00,1.61146207059617241e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(707,'2026-07-13','588880',2.0294,2.0741,2.03725,1.81691666666666673e+00,-6.02350636630752944e+00,-8.79277566539924393e+00,8.84855360181509098e+00,1.23721519551192415e+00,1.33388942494315854e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(708,'2026-07-13','588890',5.11180000000000056e+00,5.1361,4.93485,4.13143333333333284e+00,-1.41442715700141885e+00,-7.9433962264151,2.3958333333333325e+01,2.1355172571836678e+00,2.19717936759801,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(709,'2026-07-13','588900',2.102,2.1505,2.11179999999999967e+00,1.88200000000000011e+00,-6.45313235986811939e+00,-8.77354157096922371e+00,8.82191780821917,1.20021316004432354e+00,1.28060174732294407e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(710,'2026-07-13','588910',1.6751999999999998e+00,1.72070000000000011e+00,1.7014,1.60201666666666664e+00,-5.49970431697221,-7.30858468677493267e+00,3.09677419354839056e+00,8.0439110005331349e-01,8.37939042603086381e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(711,'2026-07-13','588920',2.88880000000000025e+00,2.90159999999999973e+00,2.79600000000000026e+00,2.34583333333333321e+00,-3.58166189111741584e-01,-8.06345009914076804e+00,2.45299910474485294e+01,1.12525792828973747e+00,1.38359174770123316e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(712,'2026-07-13','588930',1.89800000000000013e+00,1.9215,1.8928999999999998e+00,1.82236666666666669e+00,-0.698924731182804,-5.86136595310907715e+00,1.04665071770335025e+01,1.05827213674209152e+00,1.43783394565397459e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(713,'2026-07-13','588940',2.1258,2.136,2.06774999999999975e+00,1.82415,-1.93610842207159183e-01,-6.35785649409628117e+00,1.96749854904236585e+01,1.05844596152164904e+00,1.59353746683081842e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(714,'2026-07-13','588950',2.1572,2.16180000000000038e+00,2.0877,1.83845000000000013e+00,-8.13397129186599343e-01,-6.99865410497981788e+00,1.96882217090069246e+01,9.6131571374824154e-01,1.74170943672348,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(715,'2026-07-13','588980',1.8634,1.90539999999999976e+00,1.87215,1.67265,-5.91054313099042,-8.58768753233316672e+00,9.00678593460826348e+00,1.01178615988489,8.01480906228594247e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(716,'2026-07-13','588990',4.733,4.7514,4.56315,3.81725,-1.09361329833770337e+00,-8.0146460537022,2.42990654205607512e+01,1.48883038874777917e+00,1.22597327113960719e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(717,'2026-07-13','589000',1.86900000000000021e+00,1.8951,1.862,1.69561666666666654e+00,-3.07609282245008275e+00,-7.08742886704604124e+00,1.07274969173859489e+01,1.01136461113174402e+00,1.18399884931851873e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(718,'2026-07-13','589010',1.70040000000000013e+00,1.71960000000000023e+00,1.6949,1.6413,-4.19916016796650914e-01,-5.62819783968163633e+00,1.0740493662441608e+01,1.00868954009918,1.45044006787915735e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(719,'2026-07-13','589020',3.1158,3.118,2.8779,2.16906666666666669e+00,2.10780926053903972e+00,-7.54067584480601,3.75058166589111294e+01,1.61609245182334104e+00,2.26086950095345207e+00,0,0,1,1);
INSERT INTO "etf_indicator" VALUES(720,'2026-07-13','589030',1.4756,1.5057,1.46385,1.30288333333333339e+00,-6.26262626262628074e+00,-1.02514506769825981e+01,16.2907268170426,5.99008150223131807e-01,6.34393658115113834e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(721,'2026-07-13','589050',1.6382,1.6664,1.63404999999999978e+00,1.48699999999999987e+00,-2.64941466420208771e+00,-5.10510510510510151e+00,1.07994389901823417e+01,7.25519395650539245e-01,6.12353173285271834e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(722,'2026-07-13','589060',1.9815999999999998e+00,1.99699999999999988e+00,1.95625,1.77666666666666661e+00,-2.1123132405976408e+00,-5.89400693412581766e+00,1.18963486454652489e+01,1.2996256665096888e+00,1.12845022326451394e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(723,'2026-07-13','589070',1.3862,1.4137,1.3744,1.22401666666666675e+00,-6.10632183908045256e+00,-1.03566529492455483e+01,1.62811387900355661e+01,9.87936721263820261e-01,1.52750198214492582e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(724,'2026-07-13','589080',1.857,1.886,1.85,1.68463333333333342e+00,-3.09278350515463928e+00,-6.68756530825496131e+00,1.07253564786112818e+01,1.08794128611942308e+00,1.21730079980349525e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(725,'2026-07-13','589090',1.2848,1.3006,1.28055,1.24035,-3.98089171974536082e-01,-5.65610859728508152e+00,1.05123674911660849e+01,8.26136693164957747e-01,7.26106346353804776e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(726,'2026-07-13','589100',1.1662,1.173,1.1257,9.41283333333333249e-01,-1.32978723404254539e+00,-7.94044665012407779e+00,24.21875,1.12436364472143757e+00,1.48413369204191392e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(727,'2026-07-13','589110',1.1168,1.1303,1.11295,1.07625000000000015e+00,-1.00364963503650761e+00,-5.97920277296359881e+00,1.0488798370672093e+01,8.03593659734529896e-01,6.43935370266536466e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(728,'2026-07-13','589120',0.8496,0.8622,7.98949999999999938e-01,8.01666666666666638e-01,-5.21064301552106634e+00,3.88821385176185696e+00,1.89151599443671898e+01,8.20779637455745669e-01,1.29475870798297409e+00,1,0,1,1);
INSERT INTO "etf_indicator" VALUES(729,'2026-07-13','589130',1.798,1.8072,1.7349,1.45185,-1.6073478760045945e+00,-8.09651474530831372e+00,2.39334779464931202e+01,1.23459491612655658e+00,1.43182521962516307e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(730,'2026-07-13','589150',1.4872,1.4962,1.44935000000000013e+00,1.28423333333333333e+00,-1.24052377670572644e+00,-6.94805194805194759e+00,18.4297520661157,7.44165632244363273e-01,1.03164477803617971e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(731,'2026-07-13','589160',1.6484,1.6514,1.58550000000000013e+00,1.32421666666666681e+00,-1.32408575031526254e+00,-8.58644859813084693e+00,2.40095087163232818e+01,1.41137397477319082e+00,2.10734310659745904e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(732,'2026-07-13','589170',1.3922,1.4203,1.383,1.23365000000000013e+00,-5.94555873925500755e+00,-1.03754266211604218e+01,1.54793315743183779e+01,7.25715455127772246e-01,6.45404848153371069e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(733,'2026-07-13','589180',2.16059999999999963e+00,2.2708,2.2646,1.96036666666666659e+00,-8.27648931332423,-1.55006284038542112e+01,2.1265822784809929e+00,9.25697045161623544e-01,8.95053113461910854e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(734,'2026-07-13','589190',1.6344,1.6422,1.58355,1.32906666666666661e+00,-3.79027163613387951e-01,-7.56154747948417593e+00,2.42710795902285383e+01,9.11926755490775398e-01,1.11145143054850725e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(735,'2026-07-13','589200',1.607,1.6687,1.66170000000000017e+00,1.5638333333333334e+00,-7.85973397823457275e+00,-1.18055555555555571e+01,2.41935483870967527e+00,2.13550547101551657e+00,1.66537842741486885e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(736,'2026-07-13','589210',1.76060000000000016e+00,1.7933,1.74165,1.54986666666666672e+00,-6.23582766439909619e+00,-1.03523035230352338e+01,1.63150492264416229e+01,1.41047344103620408e+00,1.00296969615891229e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(737,'2026-07-13','589220',1.18420000000000014e+00,1.2259,1.22040000000000015e+00,1.14956666666666662e+00,-8.03278688524589,-9.44309927360774636e+00,1.5384615384615552e+00,1.00097909584238653e+00,9.14846803808302522e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(738,'2026-07-13','589230',1.04139999999999988e+00,1.05340000000000011e+00,1.03834999999999988e+00,1.00405,-9.78473581213312737e-01,-6.03528319405756086e+00,1.02396514161219975e+01,7.06578148882358925e-01,8.24832738806169474e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(739,'2026-07-13','589250',1.6078,1.6395,1.59475,1.42268333333333329e+00,-6.00991325898390105e+00,-1.0395747194329596e+01,1.63343558282208469e+01,7.87681234538801233e-01,0.748956228004435,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(740,'2026-07-13','589260',1.6088,1.64110000000000022e+00,1.59635,1.4253,-6.23841877702284719e+00,-10.1775147928994,1.60550458715596349e+01,6.77836662464692318e-01,5.45034510146457207e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(741,'2026-07-13','589270',1.3014,1.3378,1.3082,NULL,-5.53030303030302938e+00,-6.94029850746268373e+00,1.0943060498220646e+01,9.25049830899783431e-01,1.03231821852844385e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(742,'2026-07-13','589280',1.0388,1.0568,1.04705,NULL,-4.67111534795042793e+00,-5.57129367327666713e+00,6.04453870625663,1.98672213503595807e+00,1.33013260639040931e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(743,'2026-07-13','589300',2.0322,2.0654,2.0311,1.84861666666666679e+00,-3.70370370370369794e+00,-7.67045454545455207e+00,1.01072840203275013e+01,3.05058829804770415e+00,1.36205825306937122e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(744,'2026-07-13','589320',1.0038,1.0375,1.0322,NULL,-8.22846079380444805e+00,-9.5419847328244387e+00,1.60771704180062702e+00,2.39995329668283074e+00,1.61348503034986756e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(745,'2026-07-13','589330',1.0192,1.0547,1.04885,NULL,-8.01526717557252688e+00,-9.31326434619003151e+00,2.22693531283140178e+00,1.12152639323361702e+00,5.13485140923943927e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(746,'2026-07-13','589380',1.71960000000000023e+00,1.7411,1.71479999999999987e+00,1.65346666666666664e+00,-8.30367734282322356e-01,-6.06741573033708903e+00,1.07284768211920464e+01,4.72952483386620325e-01,4.72519714204126639e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(747,'2026-07-13','589500',1.8878,1.91449999999999986e+00,1.8798,1.70928333333333326e+00,-3.51437699680510196e+00,-6.88591983556011655e+00,1.07579462102689547e+01,1.27624597543327578e+00,1.19388040799510841e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(748,'2026-07-13','589520',0.728,0.7367,7.26250000000000062e-01,7.03016666666666623e-01,-9.79020979020983617e-01,-6.10079575596818,1.02803738317756909e+01,1.21290457639490423e+00,1.12180491337630083e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(749,'2026-07-13','589550',1.433,1.4449,1.4115,1.35193333333333343e+00,-2.51046025104603165e+00,-2.78164116828929497e+00,8.54037267080745,1.89194338300691389e+00,2.21712722016647356e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(750,'2026-07-13','589560',1.1538,1.1683,1.1507,1.1151000000000002e+00,-9.70873786407755456e-01,-6.18729096989965,1.02161100196463738e+01,1.37813214963649599e+00,9.71735285699998674e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(751,'2026-07-13','589580',1.8744,1.9094000000000002e+00,1.86980000000000012e+00,1.69115,-3.95933654360620668e+00,-6.89834024896265329e+00,1.11455108359133081e+01,6.30944695037188307e-01,5.75678459832682065e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(752,'2026-07-13','589600',1.8656,1.89239999999999985e+00,1.85835000000000016e+00,1.68868333333333331e+00,-3.23974082073434921e+00,-7.77148739063304727e+00,1.08910891089108794e+01,1.58660870758635619e+00,1.48836237853802266e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(753,'2026-07-13','589630',0.932,0.9506,0.9338,8.56383333333333385e-01,-4.09482758620689502e+00,-8.05785123966942151e+00,8.93512851897184745e+00,1.80655251119442894e+00,2.72827871499846708e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(754,'2026-07-13','589660',1.8864,1.91469999999999984e+00,1.877,1.70531666666666681e+00,-3.41333333333333488e+00,-6.79361811631498113e+00,1.08323133414932826e+01,1.06882970316533976e+00,1.05415205578290116e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(755,'2026-07-13','589680',1.8224,1.84789999999999987e+00,1.81699999999999972e+00,1.65895000000000014e+00,-3.15265486725664345e+00,-7.45243128964059309e+00,10.125786163522,1.01850697331835027e+00,9.72803299815042432e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(756,'2026-07-13','589700',2.6184,2.7278,2.73125,2.35390000000000032e+00,-9.93401759530793171e+00,-1.453913043478261e+01,6.59436008676788087e+00,1.37205473670526312e+00,1.04312370392155506e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(757,'2026-07-13','589720',9.21600000000000085e-01,0.9355,0.8664,8.69316666666666626e-01,-5.51020408163264185e+00,3.811659192825112e+00,1.90231362467866418e+01,8.44490091871845316e-01,1.47681229342055431e+00,1,0,1,1);
INSERT INTO "etf_indicator" VALUES(758,'2026-07-13','589770',1.8812000000000002e+00,1.90769999999999972e+00,1.87414999999999976e+00,1.70666666666666677e+00,-3.16014997321906188e+00,-6.75605982465188326e+00,1.05134474327628559e+01,0.801632237157916,8.21261156951844761e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(759,'2026-07-13','589780',1.427,1.47699999999999986e+00,1.47035,1.38609999999999988e+00,-7.97002724795640205e+00,-9.38967136150235,1.57894736842103533e+00,1.02647555090566111e+00,8.60453560513084747e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(760,'2026-07-13','589800',1.87980000000000013e+00,1.90689999999999981e+00,1.87215,1.70226666666666659e+00,-3.74732334047109816e+00,-7.27178958225889182e+00,1.03067484662576767e+01,1.40151324411775,1.43784133454571816e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(761,'2026-07-13','589820',1.4658,1.51519999999999988e+00,1.5076,1.42231666666666667e+00,-8.48243870112657205e+00,-1.0149642160052041e+01,1.69366715758467734e+00,1.36150310629113935e+00,1.04751847118390939e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(762,'2026-07-13','589850',1.9678,1.97399999999999975e+00,1.91205,1.6918833333333334e+00,-1.56739811912220972e-01,-6.36942675159235527e+00,1.94374999999999964e+01,1.01053712727582456e+00,1.43468423842140824e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(763,'2026-07-13','589860',1.8584,1.88680000000000025e+00,1.8539,1.6874,-3.41278439869989735e+00,-7.18375845913587,1.04024767801857542e+01,1.03964693070794456e+00,1.11003391219912961e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(764,'2026-07-13','589880',1.8572,1.8806,1.85180000000000011e+00,1.68693333333333317e+00,-3.09951060358890639e+00,-7.81169167097776,1.04773713577185354e+01,8.88888783200473264e-01,6.17188974336600248e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(765,'2026-07-13','589890',1.85380000000000011e+00,1.8806,1.84684999999999988e+00,1.68198333333333338e+00,-3.79198266522210447e+00,-7.49999999999999555e+00,1.04477611940298373e+01,7.67798421858429058e-01,7.40128567426092676e-01,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(766,'2026-07-13','589900',1.87980000000000013e+00,1.9091,1.87205000000000021e+00,1.70103333333333339e+00,-3.21199143468950953e+00,-6.56330749354005,1.07843137254902021e+01,1.44873914608542953e+00,1.48607787481537911e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(767,'2026-07-13','589950',1.53339999999999987e+00,1.5682,1.5408,1.37121666666666652e+00,-5.95854922279793797e+00,-8.96551724137930605e+00,9.17293233082705583e+00,1.96748393285273248e+00,1.49091258315743924e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(768,'2026-07-13','589980',2.1138,2.16209999999999968e+00,2.12505,1.89721666666666655e+00,-6.32318501170959734e+00,-8.88382687927106218e+00,8.87316276537832848e+00,1.33067700015985335e+00,1.04538181797997653e+00,0,0,0,1);
INSERT INTO "etf_indicator" VALUES(769,'2026-07-13','589990',1.9356000000000002e+00,1.96499999999999985e+00,1.92395,1.7525666666666666e+00,-3.73250388802488508e+00,-6.68341708542713419e+00,1.04042806183115352e+01,1.74123501402419256e+00,1.73063339094582935e+00,0,0,0,1);
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
INSERT INTO "etf_master" VALUES('510050','上证50ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510300','沪深300ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510500','中证500ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512100','中证1000ETF','SH','CORE','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159915','创业板ETF','SZ','GROWTH','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588220','科创100F','SH','GROWTH','宽基',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512760','半导体ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589020','KC半导体','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515880','通信ETF','SH','SECTOR','科技ETF',0,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515070','AI ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562500','机器人ETF','SH','THEME','科技ETF',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512890','红利低波ETF','SH','DEFENSE','防守/轮动',0,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512000','券商ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516020','化工ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512010','医药ETF','SH','SECTOR','防守/轮动',0,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560330','沪深300价值ETF申万菱信','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562320','沪深300价值ETF银华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159510','沪深300价值ETF华夏','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562530','中证1000价值ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159238','沪深300增强ETF景顺','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('530050','上证50ETF东财','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561000','沪深300增强ETF华安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159617','中证500价值ETF华夏','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510190','上证50ETF华安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510850','上证50ETF工银','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562330','中证500价值ETF银华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159563','创业板综ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510600','上证50ETF申万菱信','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510950','上证50ETF广发','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562070','沪深300指增ETF华宝','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510320','沪深300ETF中金','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510680','上证50ETF万家','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515380','沪深300ETF泰康','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561900','沪深300ESGETF招商','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('530000','上证50ETF天弘','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510710','上证50ETF博时','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510100','上证50ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510800','上证50ETF建信','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516830','沪深300ESGETF富国','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159300','沪深300ETF富国','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159925','沪深300ETF南方','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561930','沪深300ETF招商','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510350','沪深300ETF工银','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159330','沪深300ETF东财','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159919','沪深300ETF嘉实','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510370','沪深300ETF兴业','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563520','沪深300ETF永赢','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515350','沪深300ETF民生加银','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510390','沪深300ETF平安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515330','沪深300ETF天弘','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515310','沪深300ETF汇添富','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515130','沪深300ETF博时','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510310','沪深300ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159393','沪深300ETF万家','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515660','沪深300ETF国联安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515360','沪深300ETF方正富邦','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515390','沪深300ETF华安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510360','沪深300ETF广发','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510330','沪深300ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159673','沪深300ETF鹏华','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159523','沪深300成长ETF华夏','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510380','沪深300ETF国寿','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560180','沪深300ESGETF南方','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561990','沪深300增强ETF招商','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512080','A500ETF中金','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159356','A500ETF万家','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563090','上证50增强ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563650','中证A500ETF兴业','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512370','A500增强ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589120','科创创新药ETF汇添富','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159656','沪深300成长ETF万家','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159215','A500ETF平安','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560750','A500ETF申万菱信','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159376','A500ETF浦银','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561300','沪深300增强ETF国泰','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563880','A500ETF汇添富','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159971','创业板ETF富国','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562310','沪深300成长ETF银华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159360','A500ETF天弘','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560510','中证A500ETF泰康','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159287','创业板综ETF博时','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159362','A500ETF工银','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159351','A500ETF嘉实','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512020','A500ETF鹏华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563630','A500增强ETF国联安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159358','中证A500ETF大成','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560610','A500ETF招商','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589720','科创创新药ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560530','中证A500ETF摩根','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159338','中证A500ETF国泰','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563660','A500ETF银河','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('517800','人工智能50ETF方正富邦','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563360','A500ETF华泰柏瑞','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159357','A500ETF博时','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563500','A500ETF华宝','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159359','A500ETF华安','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159249','A500增强ETF工银','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563220','A500ETF富国','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563800','A500ETF广发','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512050','A500ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159373','创业板50ETF嘉实','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159780','科创创业50ETF南方','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159966','创业板价值ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159298','创业板50ETF大成','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159361','A500ETF易方达','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159352','A500ETF南方','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159339','A500ETF银华','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159386','A500ETF永赢','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159949','创业板50ETF华安','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588660','科创创业50ETF兴银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159375','创业板50ETF国泰','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563860','中证A500ETF海富通','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562340','中证500成长ETF银华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159012','科创创业50ETF鹏华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159500','中证500ETF富国','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563600','A500增强ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159353','中证A500ETF景顺','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159606','中证500成长ETF易方达','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159682','创业板50ETF景顺','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159977','创业板ETF天弘','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159379','A500ETF融通','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512930','AI人工智能ETF平安','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159948','创业板ETF南方','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159819','人工智能ETF易方达','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159205','创业板ETF东财','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159240','A500增强ETF天弘','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159957','创业板ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588300','科创创业50ETF招商','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159383','创业板50ETF华泰柏瑞','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159337','中证500ETF东财','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159380','A500ETF东财','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563550','A500增强ETF摩根','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159681','创业板50ETF鹏华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159248','人工智能ETF万家','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588310','科创创业ETF方正富邦','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561090','A500增强ETF华安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159369','创业板50ETF易方达','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589550','科创价值ETF华夏','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159956','创业板ETF建信','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159952','创业板ETF广发','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159958','创业板ETF工银','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588380','科创创业ETF富国','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588330','双创50ETF华宝','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159226','中证A500增强ETF国泰','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159610','中证500增强ETF景顺','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588360','科创创业ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515980','人工智能ETF华富','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159908','创业板ETF博时','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159964','创业板ETF平安','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589190','科创芯片ETF华宝','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159675','创业板增强ETF嘉实','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159367','创业板50ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561590','中证1000增强ETF华泰柏瑞','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589850','科创50ETF东财','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159968','中证500ETF博时','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588040','科创50ETF鹏华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159142','科创创业人工智能ETF景顺','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159141','科创创业人工智能ETF永赢','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159247','创业板ETF汇添富','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159371','创业板50ETF富国','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588510','科创创业人工智能ETF华夏','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561950','中证500增强ETF招商','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560950','中证500增强ETF汇添富','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561460','人工智能ETF天弘','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159022','科创创业人工智能ETF富国','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588320','双创50增强ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588480','科创创业人工智能ETF中金','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159810','创业板ETF浦银','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515550','中证500ETF国联','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589010','科创人工智能ETF华夏','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561980','半导体设备ETF招商','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159935','中证500ETF景顺','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159773','创业板科技ETF华泰柏瑞','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159781','科创创业ETF易方达','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510530','中证500ETF工银','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588720','科创50ETF中银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159782','双创50ETF银华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159982','中证500ETF鹏华','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588410','科创创业人工智能ETF鹏华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588920','科创芯片ETF鹏华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588770','科创信息ETF摩根','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588470','科创创业人工智能ETF华安','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588390','科创创业ETF博时','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563030','中证500增强ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159139','科创创业人工智能ETF华泰柏瑞','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159820','中证500ETF天弘','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159107','创业板软件ETF富国','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('563750','中证500ETF汇添富','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159288','创业板综ETF银华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588930','科创人工智能ETF银华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589090','科创AIETF鹏华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560100','中证500增强ETF南方','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159290','创业板综指增强ETF东财','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159836','创业板300ETF天弘','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159292','创业板综增强ETF华宝','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159256','创业板软件ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('515530','中证500ETF泰康','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588450','科创50增强ETF招商','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588050','科创50ETF工银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589310','科创人工智能ETF鑫元','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588940','科创50ETF富国','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159289','创业板综指ETF鹏华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512510','中证500ETF华泰柏瑞','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588420','科创创业人工智能ETF摩根','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589380','科创人工智能ETF富国','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589520','科创人工智能ETF华宝','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588810','科创芯片ETF富国','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159677','中证1000增强ETF银华','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588430','科创创业人工智能ETF工银','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159676','创业板增强ETF富国','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159246','创业板人工智能ETF富国','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159991','创业板大盘ETF招商','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510580','中证500ETF易方达','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588400','科创创业ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588460','科创50增强ETF鹏华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159140','科创创业人工智能ETF易方达','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588760','科创人工智能ETF广发','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159620','中证500成长ETF华夏','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159242','创业板人工智能ETF大成','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159967','创业板成长ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159293','创业板综增强ETF建信','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561350','中证500ETF国泰','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159922','中证500ETF嘉实','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512500','中证500ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510510','中证500ETF广发','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159381','创业板人工智能ETF华夏','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159388','创业板人工智能ETF国泰','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159516','半导体设备ETF国泰','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159813','半导体ETF鹏华','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589560','科创人工智能ETF汇添富','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562520','中证1000成长ETF华夏','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159382','创业板人工智能ETF南方','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510570','中证500ETF兴业','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588690','科创增强ETF银华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589110','科创人工智能ETF国泰','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588730','科创人工智能ETF易方达','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159541','创业板综ETF万家','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159363','创业板人工智能ETF华宝','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560590','中证1000增强ETF鹏华','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588670','科创综指增强ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159372','创业板50ETF万家','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589680','科创综指ETF鹏华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588350','科创创业50ETF鹏扬','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159783','科创创业50ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588790','科创AIETF博时','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159291','创业板综增强ETF招商','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588520','科创增强ETF永赢','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510560','中证500ETF国寿','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588060','科创50ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588090','科创50ETF华泰柏瑞','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589000','科创综指ETF华夏','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589600','科创综指ETF富国','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589080','科创综指ETF汇添富','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159597','创业板成长ETF易方达','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516640','芯片ETF富国','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589230','科创人工智能ETF南方','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588100','科创信息ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159603','科创创业ETF天弘','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588550','科创综指增强ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589990','科创综指ETF华泰柏瑞','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159629','中证1000ETF富国','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589300','科创综指ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159243','创业板人工智能ETF招商','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589270','科创100ETF前海开源','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159279','创业板人工智能ETF华安','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159845','中证1000ETF华夏','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589280','科创增强ETF华宝','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516300','中证1000ETF华泰柏瑞','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561550','中证500增强ETF华泰柏瑞','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588750','科创芯片ETF汇添富','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588080','科创50ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589630','科创综指ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159633','中证1000ETF易方达','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589500','科创综指ETF工银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588000','科创50ETF华夏','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510590','中证500ETF平安','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589770','科创综指ETF招商','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589890','科创综指ETF景顺','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588950','科创50ETF景顺','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589860','科创综指ETF天弘','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589880','科创综指ETF建信','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159995','芯片ETF华夏','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588280','科创50ETF华安','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589660','科创综指ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589800','科创综指ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560010','中证1000ETF广发','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589150','科创50ETF平安','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588200','科创芯片ETF嘉实','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560110','中证1000ETF汇添富','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589900','科创综指ETF博时','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588290','科创芯片ETF华安','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588680','科创100增强ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588910','科创价值ETF建信','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589050','科创综指ETF兴业','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159560','芯片ETF景顺','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588150','科创50ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('561280','中证1000增强ETF工银','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589400','科创芯片设计ETF富国','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588890','科创芯片ETF南方','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159599','芯片ETF东财','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588990','科创芯片ETF博时','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589420','科创芯片设计ETF永赢','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588260','科创信息ETF华安','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589260','科创芯片设计ETF国泰','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588190','科创100ETF银华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589390','科创芯片设计ETF招商','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159335','央企科创ETF融通','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159665','半导体龙头ETF工银','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588870','科创50ETF汇添富','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159526','机器人ETF嘉实','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159680','中证1000增强ETF招商','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589130','科创芯片ETF易方达','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('512480','半导体ETF国联安','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589030','科创芯片设计ETF易方达','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589070','科创芯片设计ETF天弘','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159572','创业板200ETF易方达','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588180','科创50ETF国联安','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159801','芯片ETF广发','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589290','科创芯片设计ETF汇添富','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588780','科创芯片设计ETF国联安','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589170','科创芯片设计ETF鹏华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589100','科创芯片ETF国泰','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589360','科创50ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159213','机器人ETF汇添富','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588980','科创100ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588210','科创100ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588230','科创200ETF华泰柏瑞','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562360','机器人ETF银华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588710','科创半导体设备ETF华泰柏瑞','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159679','中证1000增强ETF国泰','SZ','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589330','科创200ETF东财','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516920','芯片ETF汇添富','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588800','科创100ETF华夏','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588030','科创100ETF博时','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560770','机器人ETF招商','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588020','科创成长ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159039','机器人ETF华安','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588240','科创200ETF鹏华','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589250','科创芯片设计ETF浦银','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589950','科创100ETF富国','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589980','科创100ETF汇添富','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159573','创业板200ETF华夏','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589780','科创200ETF富国','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589220','科创200ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159258','机器人ETF南方','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588170','科创半导体ETF华夏','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589200','科创200ETF工银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588500','科创100增强ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159551','机器人ETF国泰','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('516350','芯片ETF易方达','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588880','科创100ETF华泰柏瑞','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159575','创业板200ETF银华','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159770','机器人ETF天弘','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588270','科创200ETF易方达','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589320','科创200ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159278','机器人ETF鹏华','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589160','科创芯片ETF广发','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159571','创业板200ETF富国','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('513310','中韩半导体ETF华泰柏瑞','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588900','科创100ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560630','机器人ETF万家','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588140','科创200ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159325','半导体ETF南方','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588120','科创100ETF国泰','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159559','机器人ETF景顺','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('510550','中证500ETF方正富邦','SH','CORE','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589700','科创成长ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589060','科创综指ETF东财','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589580','科创综指ETF兴银','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159048','机器人ETF大成','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159270','创业板200ETF南方','SZ','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589180','科创新材料ETF汇添富','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588820','科创200ETF华夏','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588070','科创成长ETF万家','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588010','科创新材料ETF博时','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159272','机器人ETF富国','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588370','科创50增强ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159558','半导体设备ETF易方达','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589820','科创200ETF建信','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159530','机器人ETF易方达','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588160','科创新材料ETF南方','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159050','机器人ETF广发','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588110','科创成长ETF广发','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('562590','半导体设备ETF华夏','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588840','科创50ETF万家','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589350','科创芯片设计ETF银华','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159582','半导体ETF博时','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('560780','半导体设备ETF广发','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('588850','科创机械ETF嘉实','SH','GROWTH','',1,0,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159310','芯片ETF天弘','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('589210','科创芯片设计ETF广发','SH','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
INSERT INTO "etf_master" VALUES('159327','半导体设备ETF万家','SZ','THEME','',0,1,0,0,0,'active','2026-07-13T18:57:23');
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
INSERT INTO "etf_snapshot" VALUES(4,'2026-07-13 17:56','2026-07-13','159215','A500ETF平安',1.334,-2.41,31161902.075,233079.0,-3011165.0,-9.66,1250735455.0,1250735455.0);
INSERT INTO "etf_snapshot" VALUES(5,'2026-07-13 17:56','2026-07-13','159226','中证A500增强ETF国泰',1.254,-3.32,29099502.4,229303.0,-5091695.0,-17.5,105454929.0,105454929.0);
INSERT INTO "etf_snapshot" VALUES(6,'2026-07-13 17:56','2026-07-13','159238','沪深300增强ETF景顺',1.335,-1.04,6213641.8,46574.0,-267562.0,-4.31,54756608.0,54756608.0);
INSERT INTO "etf_snapshot" VALUES(7,'2026-07-13 17:56','2026-07-13','159240','A500增强ETF天弘',1.31,-3.11,7902611.0,60044.0,-1338439.0,-16.94,19151907.0,19151907.0);
INSERT INTO "etf_snapshot" VALUES(8,'2026-07-13 17:56','2026-07-13','159249','A500增强ETF工银',1.337,-2.69,18332404.5,135717.0,754481.0,4.12,124597601.0,124597601.0);
INSERT INTO "etf_snapshot" VALUES(9,'2026-07-13 17:56','2026-07-13','159300','沪深300ETF富国',5.091,-1.62,519035712.0,1021000.0,-203068263.0,-39.12,912093872.0,912093872.0);
INSERT INTO "etf_snapshot" VALUES(10,'2026-07-13 17:56','2026-07-13','159330','沪深300ETF东财',1.465,-1.74,62464669.3,424453.0,-21604766.0,-34.59,491948477.0,491948477.0);
INSERT INTO "etf_snapshot" VALUES(11,'2026-07-13 17:56','2026-07-13','159337','中证500ETF东财',1.875,-3.15,36377886.7,193418.0,129375.0,0.36,464457396.0,464457396.0);
INSERT INTO "etf_snapshot" VALUES(12,'2026-07-13 17:56','2026-07-13','159338','中证A500ETF国泰',1.248,-2.65,3840034204.0,30473995.0,-250492256.0,-6.52,23563596227.0,23563596227.0);
INSERT INTO "etf_snapshot" VALUES(13,'2026-07-13 17:56','2026-07-13','159339','A500ETF银华',1.26,-2.85,108247119.335,852480.0,-15419149.0,-14.24,2187469428.0,2187469428.0);
INSERT INTO "etf_snapshot" VALUES(14,'2026-07-13 17:56','2026-07-13','159351','A500ETF嘉实',1.253,-2.57,754887152.9,5999048.0,-20203613.0,-2.68,7471793690.0,7471793690.0);
INSERT INTO "etf_snapshot" VALUES(15,'2026-07-13 17:56','2026-07-13','159352','A500ETF南方',1.297,-2.85,3633284820.9,27709491.0,-118125776.0,-3.25,28423886900.0,28423886900.0);
INSERT INTO "etf_snapshot" VALUES(16,'2026-07-13 17:56','2026-07-13','159353','中证A500ETF景顺',1.26,-3.0,196166950.678,1540431.0,-12437346.0,-6.34,3684443878.0,3684443878.0);
INSERT INTO "etf_snapshot" VALUES(17,'2026-07-13 17:56','2026-07-13','159356','A500ETF万家',1.322,-2.29,86012231.3,646476.0,-1251681.0,-1.46,891187486.0,891187486.0);
INSERT INTO "etf_snapshot" VALUES(18,'2026-07-13 17:56','2026-07-13','159357','A500ETF博时',1.315,-2.66,33162127.188,250177.0,-2341452.0,-7.06,1548851500.0,1548851500.0);
INSERT INTO "etf_snapshot" VALUES(19,'2026-07-13 17:56','2026-07-13','159358','中证A500ETF大成',1.338,-2.62,79818969.0,589629.0,-4109919.0,-5.15,797590385.0,797590385.0);
INSERT INTO "etf_snapshot" VALUES(20,'2026-07-13 17:56','2026-07-13','159359','A500ETF华安',1.308,-2.68,48957665.1,370710.0,-381064.0,-0.78,893547685.0,893547685.0);
INSERT INTO "etf_snapshot" VALUES(21,'2026-07-13 17:56','2026-07-13','159360','A500ETF天弘',1.339,-2.55,68880940.2,510618.0,-3122826.0,-4.53,1541436083.0,1541436083.0);
INSERT INTO "etf_snapshot" VALUES(22,'2026-07-13 17:56','2026-07-13','159361','A500ETF易方达',1.274,-2.82,1855242128.25,14427709.0,-58443067.0,-3.15,24425243129.0,24425243129.0);
INSERT INTO "etf_snapshot" VALUES(23,'2026-07-13 17:56','2026-07-13','159362','A500ETF工银',1.33,-2.56,55743308.988,415214.0,-1038328.0,-1.86,1862239655.0,1862239655.0);
INSERT INTO "etf_snapshot" VALUES(24,'2026-07-13 17:56','2026-07-13','159376','A500ETF浦银',1.362,-2.44,14904020.9,108823.0,-1194345.0,-8.01,95234196.0,95234196.0);
INSERT INTO "etf_snapshot" VALUES(25,'2026-07-13 17:56','2026-07-13','159379','A500ETF融通',1.365,-3.05,4232108.5,30404.0,159411.0,3.77,220886308.0,220886308.0);
INSERT INTO "etf_snapshot" VALUES(26,'2026-07-13 17:56','2026-07-13','159380','A500ETF东财',1.383,-3.15,27380172.0,195991.0,-13419253.0,-49.01,168455398.0,168455398.0);
INSERT INTO "etf_snapshot" VALUES(27,'2026-07-13 17:56','2026-07-13','159386','A500ETF永赢',1.312,-2.89,24109762.4,181865.0,-397041.0,-1.65,91668861.0,91668861.0);
INSERT INTO "etf_snapshot" VALUES(28,'2026-07-13 17:56','2026-07-13','159393','沪深300ETF万家',5.01,-1.86,103935999.7,206700.0,-48520191.0,-46.68,282796173.0,282796173.0);
INSERT INTO "etf_snapshot" VALUES(29,'2026-07-13 17:56','2026-07-13','159500','中证500ETF富国',1.232,-2.99,35022229.922,284254.0,-8737810.0,-24.95,173143882.0,173143882.0);
INSERT INTO "etf_snapshot" VALUES(30,'2026-07-13 17:56','2026-07-13','159510','沪深300价值ETF华夏',1.207,-0.9,4048997.9,33509.0,-364501.0,-9.0,73781909.0,73781909.0);
INSERT INTO "etf_snapshot" VALUES(31,'2026-07-13 17:56','2026-07-13','159523','沪深300成长ETF华夏',1.291,-2.05,13839630.5,106291.0,-1916639.0,-13.85,87164896.0,87164896.0);
INSERT INTO "etf_snapshot" VALUES(32,'2026-07-13 17:56','2026-07-13','159606','中证500成长ETF易方达',1.32,-3.01,22661063.112,169288.0,-95244.0,-0.42,497934138.0,497934138.0);
INSERT INTO "etf_snapshot" VALUES(33,'2026-07-13 17:56','2026-07-13','159610','中证500增强ETF景顺',1.298,-3.35,11578358.562,88483.0,-2608180.0,-22.53,204523533.0,204523533.0);
INSERT INTO "etf_snapshot" VALUES(34,'2026-07-13 17:56','2026-07-13','159617','中证500价值ETF华夏',1.302,-1.14,7236360.4,55322.0,-190802.0,-2.64,37000733.0,37000733.0);
INSERT INTO "etf_snapshot" VALUES(35,'2026-07-13 17:56','2026-07-13','159620','中证500成长ETF华夏',1.305,-4.33,6737039.2,50779.0,-316635.0,-4.7,39333919.0,39333919.0);
INSERT INTO "etf_snapshot" VALUES(36,'2026-07-13 17:56','2026-07-13','159629','中证1000ETF富国',3.251,-4.77,510143555.65,1541002.0,-48281751.0,-9.46,1616568385.0,1616568385.0);
INSERT INTO "etf_snapshot" VALUES(37,'2026-07-13 17:56','2026-07-13','159633','中证1000ETF易方达',3.328,-4.91,1400323490.218,4136127.0,-46115681.0,-3.29,2350109319.0,2350109319.0);
INSERT INTO "etf_snapshot" VALUES(38,'2026-07-13 17:56','2026-07-13','159656','沪深300成长ETF万家',1.26,-2.4,30408354.975,239563.0,-2420931.0,-7.96,285060448.0,285060448.0);
INSERT INTO "etf_snapshot" VALUES(39,'2026-07-13 17:56','2026-07-13','159673','沪深300ETF鹏华',1.301,-2.03,97652780.1,746272.0,-4321107.0,-4.42,1776552428.0,1776552428.0);
INSERT INTO "etf_snapshot" VALUES(40,'2026-07-13 17:56','2026-07-13','159677','中证1000增强ETF银华',1.481,-4.2,10262881.3,68284.0,505227.0,4.92,39844959.0,39844959.0);
INSERT INTO "etf_snapshot" VALUES(41,'2026-07-13 17:56','2026-07-13','159679','中证1000增强ETF国泰',1.206,-5.85,9239971.1,75087.0,-2911555.0,-31.51,59925122.0,59925122.0);
INSERT INTO "etf_snapshot" VALUES(42,'2026-07-13 17:56','2026-07-13','159680','中证1000增强ETF招商',1.651,-5.6,115120987.451,685787.0,-12862103.0,-11.17,1333080270.0,1333080270.0);
INSERT INTO "etf_snapshot" VALUES(43,'2026-07-13 17:56','2026-07-13','159820','中证500ETF天弘',1.409,-4.02,17544031.8,122771.0,-3278708.0,-18.69,1798459526.0,1798459526.0);
INSERT INTO "etf_snapshot" VALUES(44,'2026-07-13 17:56','2026-07-13','159845','中证1000ETF华夏',3.242,-4.84,5927633630.277,18057886.0,-267489360.0,-4.51,7094875795.0,7094875795.0);
INSERT INTO "etf_snapshot" VALUES(45,'2026-07-13 17:56','2026-07-13','159919','沪深300ETF嘉实',4.949,-1.77,1727294361.769,3478248.0,-208708752.0,-12.08,26627682585.0,26627682585.0);
INSERT INTO "etf_snapshot" VALUES(46,'2026-07-13 17:56','2026-07-13','159922','中证500ETF嘉实',3.304,-4.37,1125867988.248,3371397.0,-137687987.0,-12.23,7779852041.0,7779852041.0);
INSERT INTO "etf_snapshot" VALUES(47,'2026-07-13 17:56','2026-07-13','159925','沪深300ETF南方',4.805,-1.66,373632716.562,776246.0,-1953760.0,-0.52,2613539752.0,2613539752.0);
INSERT INTO "etf_snapshot" VALUES(48,'2026-07-13 17:56','2026-07-13','159935','中证500ETF景顺',2.576,-3.77,5202853.8,20011.0,639176.0,12.29,63299935.0,63299935.0);
INSERT INTO "etf_snapshot" VALUES(49,'2026-07-13 17:56','2026-07-13','159968','中证500ETF博时',10.685,-3.58,34345875.442,31859.0,-9778869.0,-28.47,650664122.0,650664122.0);
INSERT INTO "etf_snapshot" VALUES(50,'2026-07-13 17:56','2026-07-13','159982','中证500ETF鹏华',2.181,-3.88,30789737.5,139773.0,-3872510.0,-12.58,301438743.0,301438743.0);
INSERT INTO "etf_snapshot" VALUES(51,'2026-07-13 17:56','2026-07-13','510050','上证50ETF华夏',3.011,-1.5,2176640357.0,7193570.0,-316834864.0,-14.56,19296495976.0,19296495976.0);
INSERT INTO "etf_snapshot" VALUES(52,'2026-07-13 17:56','2026-07-13','510100','上证50ETF易方达',2.955,-1.53,418597672.0,1410728.0,-12617058.0,-3.01,2988116094.0,2988116094.0);
INSERT INTO "etf_snapshot" VALUES(53,'2026-07-13 17:56','2026-07-13','510190','上证50ETF华安',4.312,-1.19,2566320.0,5954.0,498906.0,19.44,101982250.0,101982250.0);
INSERT INTO "etf_snapshot" VALUES(54,'2026-07-13 17:56','2026-07-13','510300','沪深300ETF华泰柏瑞',4.744,-1.76,7705111563.0,16190530.0,-1927022048.0,-25.01,81393697898.0,81393697898.0);
INSERT INTO "etf_snapshot" VALUES(55,'2026-07-13 17:56','2026-07-13','510310','沪深300ETF易方达',4.601,-1.83,1492105869.0,3233206.0,-346841365.0,-23.25,42223579297.0,42223579297.0);
INSERT INTO "etf_snapshot" VALUES(56,'2026-07-13 17:56','2026-07-13','510320','沪深300ETF中金',1.278,-1.39,38515675.0,300712.0,-5914508.0,-15.36,768165538.0,768165538.0);
INSERT INTO "etf_snapshot" VALUES(57,'2026-07-13 17:56','2026-07-13','510330','沪深300ETF华夏',4.94,-2.0,1018619624.0,2053857.0,-150712087.0,-14.8,37436553656.0,37436553656.0);
INSERT INTO "etf_snapshot" VALUES(58,'2026-07-13 17:56','2026-07-13','510350','沪深300ETF工银',4.974,-1.68,39378211.0,78877.0,-192264.0,-0.49,3340114138.0,3340114138.0);
INSERT INTO "etf_snapshot" VALUES(59,'2026-07-13 17:56','2026-07-13','510360','沪深300ETF广发',1.805,-1.96,102203687.0,563519.0,-22026404.0,-21.55,2830928066.0,2830928066.0);
INSERT INTO "etf_snapshot" VALUES(60,'2026-07-13 17:56','2026-07-13','510370','沪深300ETF兴业',1.052,-1.77,6447867.0,60883.0,-339571.0,-5.27,88639521.0,88639521.0);
INSERT INTO "etf_snapshot" VALUES(61,'2026-07-13 17:56','2026-07-13','510380','沪深300ETF国寿',1.399,-2.1,3425606.0,24306.0,-436652.0,-12.75,1751271558.0,1751271558.0);
INSERT INTO "etf_snapshot" VALUES(62,'2026-07-13 17:56','2026-07-13','510390','沪深300ETF平安',5.346,-1.78,42548112.0,79598.0,-28344413.0,-66.62,638579700.0,638579700.0);
INSERT INTO "etf_snapshot" VALUES(63,'2026-07-13 17:56','2026-07-13','510500','中证500ETF南方',8.292,-4.67,7517070059.0,8964812.0,-1107343616.0,-14.73,37617226632.0,37617226632.0);
INSERT INTO "etf_snapshot" VALUES(64,'2026-07-13 17:56','2026-07-13','510510','中证500ETF广发',2.627,-4.4,116552780.0,438073.0,-13011911.0,-11.16,2109581625.0,2109581625.0);
INSERT INTO "etf_snapshot" VALUES(65,'2026-07-13 17:56','2026-07-13','510530','中证500ETF工银',9.107,-3.8,21068344.0,22945.0,-3706975.0,-17.6,414180896.0,414180896.0);
INSERT INTO "etf_snapshot" VALUES(66,'2026-07-13 17:56','2026-07-13','510550','中证500ETF方正富邦',2.08,-6.31,2455646.0,11639.0,-968773.0,-39.45,41066064.0,41066064.0);
INSERT INTO "etf_snapshot" VALUES(67,'2026-07-13 17:56','2026-07-13','510560','中证500ETF国寿',2.011,-4.65,2387096.0,11616.0,-476466.0,-19.96,121300906.0,121300906.0);
INSERT INTO "etf_snapshot" VALUES(68,'2026-07-13 17:56','2026-07-13','510570','中证500ETF兴业',1.285,-4.46,4269680.0,32608.0,-947054.0,-22.18,39270371.0,39270371.0);
INSERT INTO "etf_snapshot" VALUES(69,'2026-07-13 17:56','2026-07-13','510580','中证500ETF易方达',4.275,-4.26,339256871.0,780916.0,-21704286.0,-6.4,4055129500.0,4055129500.0);
INSERT INTO "etf_snapshot" VALUES(70,'2026-07-13 17:56','2026-07-13','510590','中证500ETF平安',8.754,-4.94,62274549.0,70590.0,4731685.0,7.6,1211431919.0,1211431919.0);
INSERT INTO "etf_snapshot" VALUES(71,'2026-07-13 17:56','2026-07-13','510600','上证50ETF申万菱信',3.868,-1.28,5240702.0,13517.0,-502960.0,-9.6,48021607.0,48021607.0);
INSERT INTO "etf_snapshot" VALUES(72,'2026-07-13 17:56','2026-07-13','510680','上证50ETF万家',3.187,-1.39,14990197.0,46913.0,-2525193.0,-16.85,58719519.0,58719519.0);
INSERT INTO "etf_snapshot" VALUES(73,'2026-07-13 17:56','2026-07-13','510710','上证50ETF博时',4.279,-1.52,4170211.0,9714.0,607085.0,14.56,439962073.0,439962073.0);
INSERT INTO "etf_snapshot" VALUES(74,'2026-07-13 17:56','2026-07-13','510800','上证50ETF建信',1.392,-1.56,4698476.0,33617.0,-370879.0,-7.89,249969792.0,249969792.0);
INSERT INTO "etf_snapshot" VALUES(75,'2026-07-13 17:56','2026-07-13','510850','上证50ETF工银',3.554,-1.22,14216126.0,39837.0,1614437.0,11.36,176629891.0,176629891.0);
INSERT INTO "etf_snapshot" VALUES(76,'2026-07-13 17:56','2026-07-13','510950','上证50ETF广发',0.988,-1.3,18464492.0,186957.0,-3416084.0,-18.5,106032950.0,106032950.0);
INSERT INTO "etf_snapshot" VALUES(77,'2026-07-13 17:56','2026-07-13','512020','A500ETF鹏华',1.315,-2.59,79629280.0,598684.0,-2929954.0,-3.68,1300551706.0,1300551706.0);
INSERT INTO "etf_snapshot" VALUES(78,'2026-07-13 17:56','2026-07-13','512050','A500ETF华夏',1.241,-2.74,2540673485.0,20257868.0,-89227152.0,-3.51,17042643390.0,17042643390.0);
INSERT INTO "etf_snapshot" VALUES(79,'2026-07-13 17:56','2026-07-13','512080','A500ETF中金',1.338,-2.26,26337460.0,195228.0,-230668.0,-0.88,797696996.0,797696996.0);
INSERT INTO "etf_snapshot" VALUES(80,'2026-07-13 17:56','2026-07-13','512100','中证1000ETF南方',3.158,-4.65,7324695009.0,22877471.0,-444410752.0,-6.07,16608609383.0,16608609383.0);
INSERT INTO "etf_snapshot" VALUES(81,'2026-07-13 17:56','2026-07-13','512370','A500增强ETF华夏',1.188,-2.3,4538978.0,38005.0,-2052529.0,-45.22,373403854.0,373403854.0);
INSERT INTO "etf_snapshot" VALUES(82,'2026-07-13 17:56','2026-07-13','512500','中证500ETF华夏',4.609,-4.38,956142033.0,2053205.0,-94019362.0,-9.83,7599359759.0,7599359759.0);
INSERT INTO "etf_snapshot" VALUES(83,'2026-07-13 17:56','2026-07-13','512510','中证500ETF华泰柏瑞',2.425,-4.15,31593102.0,128511.0,-4821052.0,-15.26,956492284.0,956492284.0);
INSERT INTO "etf_snapshot" VALUES(84,'2026-07-13 17:56','2026-07-13','515130','沪深300ETF博时',1.565,-1.82,47750681.0,304392.0,-3636498.0,-7.62,124359908.0,124359908.0);
INSERT INTO "etf_snapshot" VALUES(85,'2026-07-13 17:56','2026-07-13','515310','沪深300ETF汇添富',1.413,-1.81,58487001.0,413332.0,-11699063.0,-20.0,345635626.0,345635626.0);
INSERT INTO "etf_snapshot" VALUES(86,'2026-07-13 17:56','2026-07-13','515330','沪深300ETF天弘',1.362,-1.8,34277024.0,250096.0,-5206535.0,-15.19,7362576432.0,7362576432.0);
INSERT INTO "etf_snapshot" VALUES(87,'2026-07-13 17:56','2026-07-13','515350','沪深300ETF民生加银',6.35,-1.78,8184676.0,12830.0,305955.0,3.74,74289920.0,74289920.0);
INSERT INTO "etf_snapshot" VALUES(88,'2026-07-13 17:56','2026-07-13','515360','沪深300ETF方正富邦',6.802,-1.92,1860573.0,2716.0,324995.0,17.47,256974799.0,256974799.0);
INSERT INTO "etf_snapshot" VALUES(89,'2026-07-13 17:56','2026-07-13','515380','沪深300ETF泰康',5.497,-1.47,45504193.0,82642.0,-1005630.0,-2.21,3527973545.0,3527973545.0);
INSERT INTO "etf_snapshot" VALUES(90,'2026-07-13 17:56','2026-07-13','515390','沪深300ETF华安',1.378,-1.92,524083085.0,3791586.0,-2427335.0,-0.46,1563593185.0,1563593185.0);
INSERT INTO "etf_snapshot" VALUES(91,'2026-07-13 17:56','2026-07-13','515530','中证500ETF泰康',4.485,-4.13,7143079.0,15689.0,-1324002.0,-18.54,54908510.0,54908510.0);
INSERT INTO "etf_snapshot" VALUES(92,'2026-07-13 17:56','2026-07-13','515550','中证500ETF国联',1.841,-3.76,1200960.0,6418.0,122097.0,10.17,31933434.0,31933434.0);
INSERT INTO "etf_snapshot" VALUES(93,'2026-07-13 17:56','2026-07-13','515660','沪深300ETF国联安',5.892,-1.91,6793787.0,11476.0,-1210527.0,-17.82,2528223074.0,2528223074.0);
INSERT INTO "etf_snapshot" VALUES(94,'2026-07-13 17:56','2026-07-13','516300','中证1000ETF华泰柏瑞',3.253,-4.86,23081199.0,70262.0,-4952090.0,-21.46,87871988.0,87871988.0);
INSERT INTO "etf_snapshot" VALUES(95,'2026-07-13 17:56','2026-07-13','516830','沪深300ESGETF富国',1.061,-1.58,8870014.0,83379.0,628091.0,7.08,92494691.0,92494691.0);
INSERT INTO "etf_snapshot" VALUES(96,'2026-07-13 17:56','2026-07-13','530000','上证50ETF天弘',1.372,-1.51,5552652.0,40389.0,-374021.0,-6.74,1299324348.0,1299324348.0);
INSERT INTO "etf_snapshot" VALUES(97,'2026-07-13 17:56','2026-07-13','530050','上证50ETF东财',1.179,-1.09,7984025.0,67717.0,-1192917.0,-14.94,153049527.0,153049527.0);
INSERT INTO "etf_snapshot" VALUES(98,'2026-07-13 17:56','2026-07-13','560010','中证1000ETF广发',3.227,-5.09,1215655793.0,3682476.0,-42800400.0,-3.52,5229746213.0,5229746213.0);
INSERT INTO "etf_snapshot" VALUES(99,'2026-07-13 17:56','2026-07-13','560100','中证500增强ETF南方',1.367,-4.07,26403889.0,189552.0,160859.0,0.61,83496770.0,83496770.0);
INSERT INTO "etf_snapshot" VALUES(100,'2026-07-13 17:56','2026-07-13','560110','中证1000ETF汇添富',1.165,-5.13,72170438.0,608648.0,-10838828.0,-15.02,264342578.0,264342578.0);
INSERT INTO "etf_snapshot" VALUES(101,'2026-07-13 17:56','2026-07-13','560180','沪深300ESGETF南方',1.204,-2.11,9214453.0,75970.0,-466460.0,-5.06,18786012.0,18786012.0);
INSERT INTO "etf_snapshot" VALUES(102,'2026-07-13 17:56','2026-07-13','560330','沪深300价值ETF申万菱信',1.18,0.85,4744690.0,40387.0,-1076951.0,-22.7,20213400.0,20213400.0);
INSERT INTO "etf_snapshot" VALUES(103,'2026-07-13 17:56','2026-07-13','560510','中证A500ETF泰康',1.223,-2.55,91575329.0,742029.0,-12969469.0,-14.16,3036741894.0,3036741894.0);
INSERT INTO "etf_snapshot" VALUES(104,'2026-07-13 17:56','2026-07-13','560530','中证A500ETF摩根',1.258,-2.63,106927815.0,841859.0,-7862924.0,-7.35,2885378610.0,2885378610.0);
INSERT INTO "etf_snapshot" VALUES(105,'2026-07-13 17:56','2026-07-13','560590','中证1000增强ETF鹏华',1.474,-4.53,5123417.0,34416.0,-425706.0,-8.31,20208540.0,20208540.0);
INSERT INTO "etf_snapshot" VALUES(106,'2026-07-13 17:56','2026-07-13','560610','A500ETF招商',1.226,-2.62,132890703.0,1077127.0,-12454314.0,-9.37,5670235798.0,5670235798.0);
INSERT INTO "etf_snapshot" VALUES(107,'2026-07-13 17:56','2026-07-13','560750','A500ETF申万菱信',1.369,-2.42,19517360.0,141634.0,-162898.0,-0.83,95220521.0,95220521.0);
INSERT INTO "etf_snapshot" VALUES(108,'2026-07-13 17:56','2026-07-13','560950','中证500增强ETF汇添富',1.391,-3.67,1428980.0,10099.0,-357937.0,-25.05,18754853.0,18754853.0);
INSERT INTO "etf_snapshot" VALUES(109,'2026-07-13 17:56','2026-07-13','561000','沪深300增强ETF华安',1.317,-1.13,6487042.0,48962.0,-1705376.0,-26.29,62452140.0,62452140.0);
INSERT INTO "etf_snapshot" VALUES(110,'2026-07-13 17:56','2026-07-13','561090','A500增强ETF华安',1.263,-3.22,20183909.0,157778.0,-4708317.0,-23.33,261408162.0,261408162.0);
INSERT INTO "etf_snapshot" VALUES(111,'2026-07-13 17:56','2026-07-13','561280','中证1000增强ETF工银',1.6,-5.33,11331512.0,69325.0,-1837705.0,-16.22,116556320.0,116556320.0);
INSERT INTO "etf_snapshot" VALUES(112,'2026-07-13 17:56','2026-07-13','561300','沪深300增强ETF国泰',1.021,-2.48,49438163.0,479421.0,-5146203.0,-10.41,381818273.0,381818273.0);
INSERT INTO "etf_snapshot" VALUES(113,'2026-07-13 17:56','2026-07-13','561350','中证500ETF国泰',1.291,-4.37,30845218.0,234912.0,-1823351.0,-5.91,79654700.0,79654700.0);
INSERT INTO "etf_snapshot" VALUES(114,'2026-07-13 17:56','2026-07-13','561550','中证500增强ETF华泰柏瑞',1.45,-4.86,105091961.0,718692.0,-7193544.0,-6.85,1411559920.0,1411559920.0);
INSERT INTO "etf_snapshot" VALUES(115,'2026-07-13 17:56','2026-07-13','561590','中证1000增强ETF华泰柏瑞',1.531,-3.53,10442275.0,67419.0,-802896.0,-7.69,117120888.0,117120888.0);
INSERT INTO "etf_snapshot" VALUES(116,'2026-07-13 17:56','2026-07-13','561900','沪深300ESGETF招商',1.003,-1.47,6078792.0,60146.0,-546971.0,-9.0,23404403.0,23404403.0);
INSERT INTO "etf_snapshot" VALUES(117,'2026-07-13 17:56','2026-07-13','561930','沪深300ETF招商',1.588,-1.67,79573039.0,501298.0,-17171274.0,-21.58,254493833.0,254493833.0);
INSERT INTO "etf_snapshot" VALUES(118,'2026-07-13 17:56','2026-07-13','561950','中证500增强ETF招商',1.392,-3.67,6857455.0,48898.0,69325.0,1.01,102529152.0,102529152.0);
INSERT INTO "etf_snapshot" VALUES(119,'2026-07-13 17:56','2026-07-13','561990','沪深300增强ETF招商',0.994,-2.26,42540998.0,425280.0,-2420440.0,-5.69,332641305.0,332641305.0);
INSERT INTO "etf_snapshot" VALUES(120,'2026-07-13 17:56','2026-07-13','562070','沪深300指增ETF华宝',1.039,-1.33,11494921.0,109938.0,55714.0,0.48,458762138.0,458762138.0);
INSERT INTO "etf_snapshot" VALUES(121,'2026-07-13 17:56','2026-07-13','562310','沪深300成长ETF银华',1.112,-2.54,38302692.0,339757.0,-4735538.0,-12.36,547740402.0,547740402.0);
INSERT INTO "etf_snapshot" VALUES(122,'2026-07-13 17:56','2026-07-13','562320','沪深300价值ETF银华',1.271,0.39,15511815.0,122247.0,-66792.0,-0.43,74093581.0,74093581.0);
INSERT INTO "etf_snapshot" VALUES(123,'2026-07-13 17:56','2026-07-13','562330','中证500价值ETF银华',1.181,-1.25,290202.0,2449.0,-52741.0,-18.17,11832321.0,11832321.0);
INSERT INTO "etf_snapshot" VALUES(124,'2026-07-13 17:56','2026-07-13','562340','中证500成长ETF银华',1.418,-2.94,2797529.0,19457.0,-154889.0,-5.54,11548617.0,11548617.0);
INSERT INTO "etf_snapshot" VALUES(125,'2026-07-13 17:56','2026-07-13','562520','中证1000成长ETF华夏',1.378,-4.44,9015890.0,64234.0,-396366.0,-4.4,28342704.0,28342704.0);
INSERT INTO "etf_snapshot" VALUES(126,'2026-07-13 17:56','2026-07-13','562530','中证1000价值ETF华夏',1.18,-0.92,4943790.0,41695.0,-25303.0,-0.51,47369920.0,47369920.0);
INSERT INTO "etf_snapshot" VALUES(127,'2026-07-13 17:56','2026-07-13','563030','中证500增强ETF易方达',1.617,-3.98,11371994.0,69898.0,-2430198.0,-21.37,161973273.0,161973273.0);
INSERT INTO "etf_snapshot" VALUES(128,'2026-07-13 17:56','2026-07-13','563090','上证50增强ETF易方达',1.363,-2.29,12752393.0,93104.0,423452.0,3.32,76120824.0,76120824.0);
INSERT INTO "etf_snapshot" VALUES(129,'2026-07-13 17:56','2026-07-13','563220','A500ETF富国',1.298,-2.7,506597933.0,3874765.0,-16094906.0,-3.18,7074117777.0,7074117777.0);
INSERT INTO "etf_snapshot" VALUES(130,'2026-07-13 17:56','2026-07-13','563360','A500ETF华泰柏瑞',1.318,-2.66,4277554390.0,32176056.0,-146131424.0,-3.42,30851727467.0,30851727467.0);
INSERT INTO "etf_snapshot" VALUES(131,'2026-07-13 17:56','2026-07-13','563500','A500ETF华宝',0.655,-2.67,36109793.0,545012.0,-1429431.0,-3.96,446682951.0,446682951.0);
INSERT INTO "etf_snapshot" VALUES(132,'2026-07-13 17:56','2026-07-13','563520','沪深300ETF永赢',1.215,-1.78,33055059.0,271086.0,866414.0,2.62,456918985.0,456918985.0);
INSERT INTO "etf_snapshot" VALUES(133,'2026-07-13 17:56','2026-07-13','563550','A500增强ETF摩根',1.287,-3.16,26247392.0,202354.0,-2390890.0,-9.11,102392433.0,102392433.0);
INSERT INTO "etf_snapshot" VALUES(134,'2026-07-13 17:56','2026-07-13','563600','A500增强ETF易方达',1.068,-3.0,10589618.0,98251.0,-1352979.0,-12.78,51779844.0,51779844.0);
INSERT INTO "etf_snapshot" VALUES(135,'2026-07-13 17:56','2026-07-13','563630','A500增强ETF国联安',1.301,-2.62,1475848.0,11223.0,-150175.0,-10.18,51971177.0,51971177.0);
INSERT INTO "etf_snapshot" VALUES(136,'2026-07-13 17:56','2026-07-13','563650','中证A500ETF兴业',1.319,-2.3,13244654.0,100043.0,-697441.0,-5.27,170030971.0,170030971.0);
INSERT INTO "etf_snapshot" VALUES(137,'2026-07-13 17:56','2026-07-13','563660','A500ETF银河',1.284,-2.65,2472888.0,19199.0,-195088.0,-7.89,77149397.0,77149397.0);
INSERT INTO "etf_snapshot" VALUES(138,'2026-07-13 17:56','2026-07-13','563750','中证500ETF汇添富',1.137,-4.05,31131905.0,268596.0,-5749766.0,-18.47,397650978.0,397650978.0);
INSERT INTO "etf_snapshot" VALUES(139,'2026-07-13 17:56','2026-07-13','563800','A500ETF广发',1.244,-2.74,609363054.0,4851986.0,-32103731.0,-5.27,9145860612.0,9145860612.0);
INSERT INTO "etf_snapshot" VALUES(140,'2026-07-13 17:56','2026-07-13','563860','中证A500ETF海富通',1.32,-2.94,31967558.0,238612.0,-1718774.0,-5.38,217594476.0,217594476.0);
INSERT INTO "etf_snapshot" VALUES(141,'2026-07-13 17:56','2026-07-13','563880','A500ETF汇添富',1.288,-2.5,120588198.0,925611.0,-4715544.0,-3.91,1405203363.0,1405203363.0);
INSERT INTO "etf_snapshot" VALUES(142,'2026-07-13 17:56','2026-07-13','512890','红利低波ETF华泰柏瑞',1.126,1.17,1007280128.0,8977096.0,-218077401.0,-21.65,33763234743.0,33763234743.0);
INSERT INTO "etf_snapshot" VALUES(143,'2026-07-13 17:56','2026-07-13','159012','科创创业50ETF鹏华',1.043,-2.98,11208991.263,105488.0,-1238922.0,-11.05,84359037.0,84359037.0);
INSERT INTO "etf_snapshot" VALUES(144,'2026-07-13 17:56','2026-07-13','159107','创业板软件ETF富国',0.761,-4.04,34403354.37,443024.0,-4618990.0,-13.43,483100309.0,483100309.0);
INSERT INTO "etf_snapshot" VALUES(145,'2026-07-13 17:56','2026-07-13','159205','创业板ETF东财',1.83,-3.07,148932400.9,805184.0,-41802412.0,-28.07,711972597.0,711972597.0);
INSERT INTO "etf_snapshot" VALUES(146,'2026-07-13 17:56','2026-07-13','159247','创业板ETF汇添富',1.121,-3.61,60898305.305,537807.0,-17277386.0,-28.37,289201147.0,289201147.0);
INSERT INTO "etf_snapshot" VALUES(147,'2026-07-13 17:56','2026-07-13','159256','创业板软件ETF华夏',0.838,-4.12,77269075.1,909611.0,-3634078.0,-4.7,365521991.0,365521991.0);
INSERT INTO "etf_snapshot" VALUES(148,'2026-07-13 17:56','2026-07-13','159270','创业板200ETF南方',1.155,-6.4,14920733.1,126152.0,-513128.0,-3.44,95592015.0,95592015.0);
INSERT INTO "etf_snapshot" VALUES(149,'2026-07-13 17:56','2026-07-13','159287','创业板综ETF博时',1.183,-2.55,5949882.376,50090.0,-393414.0,-6.61,110691835.0,110691835.0);
INSERT INTO "etf_snapshot" VALUES(150,'2026-07-13 17:56','2026-07-13','159288','创业板综ETF银华',1.042,-4.05,967625.09,9203.0,-216216.0,-22.35,87710278.0,87710278.0);
INSERT INTO "etf_snapshot" VALUES(151,'2026-07-13 17:56','2026-07-13','159289','创业板综指ETF鹏华',1.132,-4.15,4062918.801,35331.0,1099603.0,27.06,32717788.0,32717788.0);
INSERT INTO "etf_snapshot" VALUES(152,'2026-07-13 17:56','2026-07-13','159290','创业板综指增强ETF东财',1.216,-4.1,5807003.6,47005.0,157708.0,2.72,47546082.0,47546082.0);
INSERT INTO "etf_snapshot" VALUES(153,'2026-07-13 17:56','2026-07-13','159291','创业板综增强ETF招商',1.221,-4.61,2823961.6,22719.0,-323813.0,-11.47,23757471.0,23757471.0);
INSERT INTO "etf_snapshot" VALUES(154,'2026-07-13 17:56','2026-07-13','159292','创业板综增强ETF华宝',1.188,-4.12,5615200.4,46691.0,287905.0,5.13,222381163.0,222381163.0);
INSERT INTO "etf_snapshot" VALUES(155,'2026-07-13 17:56','2026-07-13','159293','创业板综增强ETF建信',1.097,-4.36,6896006.318,61822.0,307529.0,4.46,23211859.0,23211859.0);
INSERT INTO "etf_snapshot" VALUES(156,'2026-07-13 17:56','2026-07-13','159298','创业板50ETF大成',1.318,-2.8,14616433.7,109661.0,-1948881.0,-13.33,186208466.0,186208466.0);
INSERT INTO "etf_snapshot" VALUES(157,'2026-07-13 17:56','2026-07-13','159335','央企科创ETF融通',1.526,-5.57,2594707.2,16702.0,-364006.0,-14.03,89856509.0,89856509.0);
INSERT INTO "etf_snapshot" VALUES(158,'2026-07-13 17:56','2026-07-13','159367','创业板50ETF华夏',1.861,-3.53,21977831.1,116488.0,-263776.0,-1.2,230911073.0,230911073.0);
INSERT INTO "etf_snapshot" VALUES(159,'2026-07-13 17:56','2026-07-13','159369','创业板50ETF易方达',1.52,-3.25,19138579.1,124366.0,-4933069.0,-25.78,466265302.0,466265302.0);
INSERT INTO "etf_snapshot" VALUES(160,'2026-07-13 17:56','2026-07-13','159371','创业板50ETF富国',1.859,-3.63,9485828.3,50436.0,-2171048.0,-22.89,312723159.0,312723159.0);
INSERT INTO "etf_snapshot" VALUES(161,'2026-07-13 17:56','2026-07-13','159372','创业板50ETF万家',1.985,-4.57,4157495.7,20642.0,-1526781.0,-36.72,110071402.0,110071402.0);
INSERT INTO "etf_snapshot" VALUES(162,'2026-07-13 17:56','2026-07-13','159373','创业板50ETF嘉实',1.905,-2.76,70902694.4,366681.0,-1817580.0,-2.56,258237026.0,258237026.0);
INSERT INTO "etf_snapshot" VALUES(163,'2026-07-13 17:56','2026-07-13','159375','创业板50ETF国泰',0.795,-2.93,16578527.5,205376.0,-843450.0,-5.09,230228298.0,230228298.0);
INSERT INTO "etf_snapshot" VALUES(164,'2026-07-13 17:56','2026-07-13','159383','创业板50ETF华泰柏瑞',1.85,-3.14,8202236.4,43805.0,-2403440.0,-29.3,66771099.0,66771099.0);
INSERT INTO "etf_snapshot" VALUES(165,'2026-07-13 17:56','2026-07-13','159541','创业板综ETF万家',1.583,-4.52,12001438.7,74978.0,2174678.0,18.12,95127735.0,95127735.0);
INSERT INTO "etf_snapshot" VALUES(166,'2026-07-13 17:56','2026-07-13','159563','创业板综ETF华夏',1.944,-1.27,6735343.6,35643.0,-2538087.0,-37.68,45413343.0,45413343.0);
INSERT INTO "etf_snapshot" VALUES(167,'2026-07-13 17:56','2026-07-13','159571','创业板200ETF富国',1.482,-6.2,794638.8,5252.0,-53498.0,-6.73,26649048.0,26649048.0);
INSERT INTO "etf_snapshot" VALUES(168,'2026-07-13 17:56','2026-07-13','159572','创业板200ETF易方达',1.49,-5.64,22544474.2,149047.0,-1848899.0,-8.2,252926169.0,252926169.0);
INSERT INTO "etf_snapshot" VALUES(169,'2026-07-13 17:56','2026-07-13','159573','创业板200ETF华夏',1.495,-5.97,25556603.8,167709.0,-1518791.0,-5.94,106827164.0,106827164.0);
INSERT INTO "etf_snapshot" VALUES(170,'2026-07-13 17:56','2026-07-13','159575','创业板200ETF银华',1.453,-6.08,3549514.1,24388.0,-190298.0,-5.36,13673348.0,13673348.0);
INSERT INTO "etf_snapshot" VALUES(171,'2026-07-13 17:56','2026-07-13','159597','创业板成长ETF易方达',0.871,-4.7,29570441.9,333001.0,-2448058.0,-8.28,719234465.0,719234465.0);
INSERT INTO "etf_snapshot" VALUES(172,'2026-07-13 17:56','2026-07-13','159603','科创创业ETF天弘',1.955,-4.73,20008362.1,100151.0,-6852841.0,-34.25,4707780604.0,4707780604.0);
INSERT INTO "etf_snapshot" VALUES(173,'2026-07-13 17:56','2026-07-13','159675','创业板增强ETF嘉实',1.534,-3.52,10518646.7,67572.0,-463135.0,-4.4,79532824.0,79532824.0);
INSERT INTO "etf_snapshot" VALUES(174,'2026-07-13 17:56','2026-07-13','159676','创业板增强ETF富国',1.681,-4.22,28377837.886,167379.0,-6699036.0,-23.61,172410392.0,172410392.0);
INSERT INTO "etf_snapshot" VALUES(175,'2026-07-13 17:56','2026-07-13','159681','创业板50ETF鹏华',1.745,-3.16,155797127.5,878027.0,-25486799.0,-16.36,1737622726.0,1737622726.0);
INSERT INTO "etf_snapshot" VALUES(176,'2026-07-13 17:56','2026-07-13','159682','创业板50ETF景顺',1.726,-3.03,347635832.8,1988296.0,-39275227.0,-11.3,4874755028.0,4874755028.0);
INSERT INTO "etf_snapshot" VALUES(177,'2026-07-13 17:56','2026-07-13','159773','创业板科技ETF华泰柏瑞',1.368,-3.8,6863906.3,49530.0,3455.0,0.05,195217868.0,195217868.0);
INSERT INTO "etf_snapshot" VALUES(178,'2026-07-13 17:56','2026-07-13','159780','科创创业50ETF南方',1.262,-2.77,206403601.402,1606102.0,-9009628.0,-4.37,4311053303.0,4311053303.0);
INSERT INTO "etf_snapshot" VALUES(179,'2026-07-13 17:56','2026-07-13','159781','科创创业ETF易方达',1.266,-3.8,696714887.039,5415622.0,51134862.0,7.34,15927369287.0,15927369287.0);
INSERT INTO "etf_snapshot" VALUES(180,'2026-07-13 17:56','2026-07-13','159782','双创50ETF银华',1.267,-3.87,51470156.871,399872.0,-6500237.0,-12.63,711028075.0,711028075.0);
INSERT INTO "etf_snapshot" VALUES(181,'2026-07-13 17:56','2026-07-13','159783','科创创业50ETF华夏',1.269,-4.59,298275877.03,2305417.0,-36584503.0,-12.27,5694332168.0,5694332168.0);
INSERT INTO "etf_snapshot" VALUES(182,'2026-07-13 17:56','2026-07-13','159810','创业板ETF浦银',1.493,-3.74,4850466.0,31901.0,-424977.0,-8.76,72373859.0,72373859.0);
INSERT INTO "etf_snapshot" VALUES(183,'2026-07-13 17:56','2026-07-13','159836','创业板300ETF天弘',1.353,-4.11,5472001.5,40107.0,-212110.0,-3.88,134957844.0,134957844.0);
INSERT INTO "etf_snapshot" VALUES(184,'2026-07-13 17:56','2026-07-13','159908','创业板ETF博时',3.48,-3.44,36034201.7,102507.0,1250162.0,3.47,1114397004.0,1114397004.0);
INSERT INTO "etf_snapshot" VALUES(185,'2026-07-13 17:56','2026-07-13','159915','创业板ETF易方达',3.751,-2.87,7214651859.377,19042355.0,-1080751776.0,-14.98,44267257135.0,44267257135.0);
INSERT INTO "etf_snapshot" VALUES(186,'2026-07-13 17:56','2026-07-13','159948','创业板ETF南方',4.134,-3.07,173465967.824,413447.0,-8413164.0,-4.85,4422130408.0,4422130408.0);
INSERT INTO "etf_snapshot" VALUES(187,'2026-07-13 17:56','2026-07-13','159949','创业板50ETF华安',1.773,-2.9,2600135551.085,14472834.0,107064480.0,4.12,20603652074.0,20603652074.0);
INSERT INTO "etf_snapshot" VALUES(188,'2026-07-13 17:56','2026-07-13','159952','创业板ETF广发',2.267,-3.28,594493036.222,2584123.0,-70651113.0,-11.88,8816555532.0,8816555532.0);
INSERT INTO "etf_snapshot" VALUES(189,'2026-07-13 17:56','2026-07-13','159956','创业板ETF建信',2.366,-3.27,10999989.1,45966.0,-222800.0,-2.03,99321543.0,99321543.0);
INSERT INTO "etf_snapshot" VALUES(190,'2026-07-13 17:56','2026-07-13','159957','创业板ETF华夏',2.459,-3.11,255585713.4,1028466.0,-35708629.0,-13.97,2096997233.0,2096997233.0);
INSERT INTO "etf_snapshot" VALUES(191,'2026-07-13 17:56','2026-07-13','159958','创业板ETF工银',2.258,-3.3,15524111.2,67915.0,1343885.0,8.66,492721450.0,492721450.0);
INSERT INTO "etf_snapshot" VALUES(192,'2026-07-13 17:56','2026-07-13','159964','创业板ETF平安',2.436,-3.49,9980052.5,40351.0,-597014.0,-5.98,471321862.0,471321862.0);
INSERT INTO "etf_snapshot" VALUES(193,'2026-07-13 17:56','2026-07-13','159966','创业板价值ETF华夏',0.556,-2.8,10335401.81,184091.0,-1147172.0,-11.1,329429733.0,329429733.0);
INSERT INTO "etf_snapshot" VALUES(194,'2026-07-13 17:56','2026-07-13','159967','创业板成长ETF华夏',0.882,-4.34,1173170648.99,13011137.0,-81399712.0,-6.94,4963107309.0,4963107309.0);
INSERT INTO "etf_snapshot" VALUES(195,'2026-07-13 17:56','2026-07-13','159971','创业板ETF富国',1.311,-2.53,130108393.5,987579.0,-19021273.0,-14.62,1782986598.0,1782986598.0);
INSERT INTO "etf_snapshot" VALUES(196,'2026-07-13 17:56','2026-07-13','159977','创业板ETF天弘',1.943,-3.04,313829502.904,1590386.0,-11419827.0,-3.64,5964762881.0,5964762881.0);
INSERT INTO "etf_snapshot" VALUES(197,'2026-07-13 17:56','2026-07-13','159991','创业板大盘ETF招商',0.882,-4.23,11524575.8,128935.0,-783501.0,-6.8,85609718.0,85609718.0);
INSERT INTO "etf_snapshot" VALUES(198,'2026-07-13 17:56','2026-07-13','588000','科创50ETF华夏',2.1,-4.93,9118631347.0,42418236.0,-1519325264.0,-16.66,66640703002.0,66640703002.0);
INSERT INTO "etf_snapshot" VALUES(199,'2026-07-13 17:56','2026-07-13','588010','科创新材料ETF博时',1.228,-6.47,256099931.0,2015227.0,-4982941.0,-1.95,1182472892.0,1182472892.0);
INSERT INTO "etf_snapshot" VALUES(200,'2026-07-13 17:56','2026-07-13','588020','科创成长ETF易方达',0.983,-5.93,356983060.0,3525989.0,-7827387.0,-2.19,1485679667.0,1485679667.0);
INSERT INTO "etf_snapshot" VALUES(201,'2026-07-13 17:56','2026-07-13','588030','科创100ETF博时',1.953,-5.92,353548601.0,1755881.0,4772025.0,1.35,4657588801.0,4657588801.0);
INSERT INTO "etf_snapshot" VALUES(202,'2026-07-13 17:56','2026-07-13','588040','科创50ETF鹏华',2.037,-3.6,62123579.0,298213.0,-17127101.0,-27.57,179029893.0,179029893.0);
INSERT INTO "etf_snapshot" VALUES(203,'2026-07-13 17:56','2026-07-13','588050','科创50ETF工银',2.044,-4.13,550485145.0,2624406.0,-72586793.0,-13.19,10287945307.0,10287945307.0);
INSERT INTO "etf_snapshot" VALUES(204,'2026-07-13 17:56','2026-07-13','588060','科创50ETF广发',1.267,-4.67,717280975.0,5547088.0,-120572242.0,-16.81,6782428339.0,6782428339.0);
INSERT INTO "etf_snapshot" VALUES(205,'2026-07-13 17:56','2026-07-13','588070','科创成长ETF万家',2.519,-6.46,8427934.0,32682.0,243818.0,2.89,66594803.0,66594803.0);
INSERT INTO "etf_snapshot" VALUES(206,'2026-07-13 17:56','2026-07-13','588080','科创50ETF易方达',2.036,-4.9,3070297020.0,14755260.0,-26755680.0,-0.87,41525498673.0,41525498673.0);
INSERT INTO "etf_snapshot" VALUES(207,'2026-07-13 17:56','2026-07-13','588090','科创50ETF华泰柏瑞',2.043,-4.67,268189618.0,1277861.0,-23430581.0,-8.74,5099476730.0,5099476730.0);
INSERT INTO "etf_snapshot" VALUES(208,'2026-07-13 17:56','2026-07-13','588100','科创信息ETF嘉实',3.157,-4.71,42525465.0,130404.0,-3133470.0,-7.37,212304146.0,212304146.0);
INSERT INTO "etf_snapshot" VALUES(209,'2026-07-13 17:56','2026-07-13','588110','科创成长ETF广发',2.871,-6.63,73267745.0,245792.0,8607925.0,11.75,495988218.0,495988218.0);
INSERT INTO "etf_snapshot" VALUES(210,'2026-07-13 17:56','2026-07-13','588120','科创100ETF国泰',0.983,-6.29,138884545.0,1362263.0,4119044.0,2.97,1104520426.0,1104520426.0);
INSERT INTO "etf_snapshot" VALUES(211,'2026-07-13 17:56','2026-07-13','588140','科创200ETF广发',1.331,-6.27,6406769.0,46877.0,462897.0,7.23,277847581.0,277847581.0);
INSERT INTO "etf_snapshot" VALUES(212,'2026-07-13 17:56','2026-07-13','588150','科创50ETF南方',1.409,-5.31,69605361.0,483525.0,-4225031.0,-6.07,412742045.0,412742045.0);
INSERT INTO "etf_snapshot" VALUES(213,'2026-07-13 17:56','2026-07-13','588160','科创新材料ETF南方',1.255,-6.62,247099327.0,1893716.0,-2989560.0,-1.21,786252480.0,786252480.0);
INSERT INTO "etf_snapshot" VALUES(214,'2026-07-13 17:56','2026-07-13','588180','科创50ETF国联安',1.289,-5.64,38733704.0,293272.0,-7024073.0,-18.13,838950414.0,838950414.0);
INSERT INTO "etf_snapshot" VALUES(215,'2026-07-13 17:56','2026-07-13','588190','科创100ETF银华',1.939,-5.55,174759392.0,872155.0,-1965514.0,-1.12,2870918891.0,2870918891.0);
INSERT INTO "etf_snapshot" VALUES(216,'2026-07-13 17:56','2026-07-13','588210','科创100ETF易方达',1.951,-5.75,19560580.0,97335.0,657001.0,3.36,338018554.0,338018554.0);
INSERT INTO "etf_snapshot" VALUES(217,'2026-07-13 17:56','2026-07-13','588220','科创100ETF鹏华',1.941,-6.19,891074529.0,4494973.0,13752922.0,1.54,6762828132.0,6762828132.0);
INSERT INTO "etf_snapshot" VALUES(218,'2026-07-13 17:56','2026-07-13','588230','科创200ETF华泰柏瑞',1.987,-5.83,126790360.0,620568.0,-23917850.0,-18.86,840379809.0,840379809.0);
INSERT INTO "etf_snapshot" VALUES(219,'2026-07-13 17:56','2026-07-13','588240','科创200ETF鹏华',1.835,-5.95,41232909.0,216764.0,-1718741.0,-4.17,180991555.0,180991555.0);
INSERT INTO "etf_snapshot" VALUES(220,'2026-07-13 17:56','2026-07-13','588260','科创信息ETF华安',3.061,-5.52,15091862.0,48258.0,-2706533.0,-17.93,143089506.0,143089506.0);
INSERT INTO "etf_snapshot" VALUES(221,'2026-07-13 17:56','2026-07-13','588270','科创200ETF易方达',1.86,-6.11,29569073.0,153691.0,-2311966.0,-7.82,482502600.0,482502600.0);
INSERT INTO "etf_snapshot" VALUES(222,'2026-07-13 17:56','2026-07-13','588280','科创50ETF华安',1.435,-5.03,54308661.0,368946.0,-7639560.0,-14.07,401973646.0,401973646.0);
INSERT INTO "etf_snapshot" VALUES(223,'2026-07-13 17:56','2026-07-13','588300','科创创业50ETF招商',1.302,-3.13,88003821.0,663918.0,-6835454.0,-7.77,1829584066.0,1829584066.0);
INSERT INTO "etf_snapshot" VALUES(224,'2026-07-13 17:56','2026-07-13','588310','科创创业ETF方正富邦',1.359,-3.21,5812961.0,41936.0,-917924.0,-15.79,41636363.0,41636363.0);
INSERT INTO "etf_snapshot" VALUES(225,'2026-07-13 17:56','2026-07-13','588320','双创50增强ETF广发',1.999,-3.71,15876353.0,78334.0,-507136.0,-3.19,113592375.0,113592375.0);
INSERT INTO "etf_snapshot" VALUES(226,'2026-07-13 17:56','2026-07-13','588330','双创50ETF华宝',1.285,-3.31,111370174.0,849528.0,-4851570.0,-4.36,1302653083.0,1302653083.0);
INSERT INTO "etf_snapshot" VALUES(227,'2026-07-13 17:56','2026-07-13','588350','科创创业50ETF鹏扬',1.956,-4.59,13459297.0,67070.0,-3372592.0,-25.06,1237259976.0,1237259976.0);
INSERT INTO "etf_snapshot" VALUES(228,'2026-07-13 17:56','2026-07-13','588360','科创创业ETF国泰',1.371,-3.38,35507712.0,253168.0,-415286.0,-1.17,288844748.0,288844748.0);
INSERT INTO "etf_snapshot" VALUES(229,'2026-07-13 17:56','2026-07-13','588370','科创50增强ETF南方',2.058,-6.5,17698485.0,83936.0,-1896400.0,-10.72,130213776.0,130213776.0);
INSERT INTO "etf_snapshot" VALUES(230,'2026-07-13 17:56','2026-07-13','588380','科创创业ETF富国',1.289,-3.3,216228274.0,1647482.0,-14436931.0,-6.68,3220914530.0,3220914530.0);
INSERT INTO "etf_snapshot" VALUES(231,'2026-07-13 17:56','2026-07-13','588390','科创创业ETF博时',1.378,-3.97,13652229.0,97762.0,-2212953.0,-16.21,194209670.0,194209670.0);
INSERT INTO "etf_snapshot" VALUES(232,'2026-07-13 17:56','2026-07-13','588400','科创创业ETF嘉实',1.278,-4.27,41119024.0,315568.0,-4519656.0,-10.99,1526699577.0,1526699577.0);
INSERT INTO "etf_snapshot" VALUES(233,'2026-07-13 17:56','2026-07-13','588450','科创50增强ETF招商',2.486,-4.13,24610343.0,97529.0,-3732480.0,-15.17,120741788.0,120741788.0);
INSERT INTO "etf_snapshot" VALUES(234,'2026-07-13 17:56','2026-07-13','588460','科创50增强ETF鹏华',2.429,-4.29,143367607.0,574820.0,-20107396.0,-14.03,1428286006.0,1428286006.0);
INSERT INTO "etf_snapshot" VALUES(235,'2026-07-13 17:56','2026-07-13','588500','科创100增强ETF易方达',2.83,-6.04,10609378.0,36496.0,-1627816.0,-15.34,89561010.0,89561010.0);
INSERT INTO "etf_snapshot" VALUES(236,'2026-07-13 17:56','2026-07-13','588520','科创增强ETF永赢',1.547,-4.62,756071.0,4836.0,2698.0,0.36,13856479.0,13856479.0);
INSERT INTO "etf_snapshot" VALUES(237,'2026-07-13 17:56','2026-07-13','588550','科创综指增强ETF易方达',1.567,-4.74,4184427.0,25993.0,-127636.0,-3.05,86639430.0,86639430.0);
INSERT INTO "etf_snapshot" VALUES(238,'2026-07-13 17:56','2026-07-13','588660','科创创业50ETF兴银',2.104,-2.91,8365868.0,39104.0,-1855546.0,-22.18,65947776.0,65947776.0);
INSERT INTO "etf_snapshot" VALUES(239,'2026-07-13 17:56','2026-07-13','588670','科创综指增强ETF嘉实',2.017,-4.54,9248793.0,44807.0,2374.0,0.03,76226464.0,76226464.0);
INSERT INTO "etf_snapshot" VALUES(240,'2026-07-13 17:56','2026-07-13','588680','科创100增强ETF广发',2.746,-5.18,5715508.0,20462.0,-1940279.0,-33.95,88863306.0,88863306.0);
INSERT INTO "etf_snapshot" VALUES(241,'2026-07-13 17:56','2026-07-13','588690','科创增强ETF银华',1.366,-4.48,2039288.0,14554.0,-196961.0,-9.66,65070776.0,65070776.0);
INSERT INTO "etf_snapshot" VALUES(242,'2026-07-13 17:56','2026-07-13','588720','科创50ETF中银',1.999,-3.85,22032936.0,106486.0,-3093438.0,-14.04,189388858.0,189388858.0);
INSERT INTO "etf_snapshot" VALUES(243,'2026-07-13 17:56','2026-07-13','588770','科创信息ETF摩根',2.24,-3.95,43349551.0,188534.0,3362371.0,7.76,758457513.0,758457513.0);
INSERT INTO "etf_snapshot" VALUES(244,'2026-07-13 17:56','2026-07-13','588800','科创100ETF华夏',1.923,-5.92,331988024.0,1672857.0,-17484220.0,-5.27,2985220986.0,2985220986.0);
INSERT INTO "etf_snapshot" VALUES(245,'2026-07-13 17:56','2026-07-13','588820','科创200ETF华夏',2.119,-6.45,38574010.0,175299.0,-1089586.0,-2.82,308102600.0,308102600.0);
INSERT INTO "etf_snapshot" VALUES(246,'2026-07-13 17:56','2026-07-13','588840','科创50ETF万家',1.845,-6.87,29052295.0,154892.0,-7110373.0,-24.47,85305420.0,85305420.0);
INSERT INTO "etf_snapshot" VALUES(247,'2026-07-13 17:56','2026-07-13','588850','科创机械ETF嘉实',1.917,-7.03,25301698.0,128138.0,-414894.0,-1.64,162521343.0,162521343.0);
INSERT INTO "etf_snapshot" VALUES(248,'2026-07-13 17:56','2026-07-13','588870','科创50ETF汇添富',2.025,-5.59,165961824.0,804425.0,-31325610.0,-18.88,673417800.0,673417800.0);
INSERT INTO "etf_snapshot" VALUES(249,'2026-07-13 17:56','2026-07-13','588880','科创100ETF华泰柏瑞',1.919,-6.07,17287854.0,88110.0,-1531019.0,-8.86,190687192.0,190687192.0);
INSERT INTO "etf_snapshot" VALUES(250,'2026-07-13 17:56','2026-07-13','588900','科创100ETF南方',1.986,-6.23,16889658.0,81381.0,-245955.0,-1.46,641047054.0,641047054.0);
INSERT INTO "etf_snapshot" VALUES(251,'2026-07-13 17:56','2026-07-13','588910','科创价值ETF建信',1.598,-5.22,15280264.0,93145.0,-557252.0,-3.65,164672462.0,164672462.0);
INSERT INTO "etf_snapshot" VALUES(252,'2026-07-13 17:56','2026-07-13','588940','科创50ETF富国',2.062,-4.14,220265799.0,1046192.0,-45664299.0,-20.73,1264872040.0,1264872040.0);
INSERT INTO "etf_snapshot" VALUES(253,'2026-07-13 17:56','2026-07-13','588950','科创50ETF景顺',2.073,-5.0,121639229.0,575576.0,-30577159.0,-25.14,820347660.0,820347660.0);
INSERT INTO "etf_snapshot" VALUES(254,'2026-07-13 17:56','2026-07-13','588980','科创100ETF广发',1.767,-5.71,3476983.0,19263.0,-450297.0,-12.95,21062640.0,21062640.0);
INSERT INTO "etf_snapshot" VALUES(255,'2026-07-13 17:56','2026-07-13','589000','科创综指ETF华夏',1.796,-4.67,172307268.0,931262.0,-5073748.0,-2.94,1443100023.0,1443100023.0);
INSERT INTO "etf_snapshot" VALUES(256,'2026-07-13 17:56','2026-07-13','589050','科创综指ETF兴业',1.58,-5.28,5233063.0,32779.0,-351642.0,-6.72,80529440.0,80529440.0);
INSERT INTO "etf_snapshot" VALUES(257,'2026-07-13 17:56','2026-07-13','589060','科创综指ETF东财',1.9,-6.36,7015404.0,36067.0,-393965.0,-5.62,118062010.0,118062010.0);
INSERT INTO "etf_snapshot" VALUES(258,'2026-07-13 17:56','2026-07-13','589080','科创综指ETF汇添富',1.786,-4.7,48929786.0,267131.0,-3659129.0,-7.48,264436946.0,264436946.0);
INSERT INTO "etf_snapshot" VALUES(259,'2026-07-13 17:56','2026-07-13','589120','科创创新药ETF汇添富',0.855,-2.4,226803912.0,2631597.0,-40559491.0,-17.88,975230100.0,975230100.0);
INSERT INTO "etf_snapshot" VALUES(260,'2026-07-13 17:56','2026-07-13','589150','科创50ETF平安',1.433,-5.1,25739642.0,175627.0,-2608512.0,-10.13,913447508.0,913447508.0);
INSERT INTO "etf_snapshot" VALUES(261,'2026-07-13 17:56','2026-07-13','589180','科创新材料ETF汇添富',2.017,-6.4,66952215.0,319267.0,-8877844.0,-13.26,283021406.0,283021406.0);
INSERT INTO "etf_snapshot" VALUES(262,'2026-07-13 17:56','2026-07-13','589200','科创200ETF工银',1.524,-6.04,8400491.0,53888.0,3914.0,0.05,29728668.0,29728668.0);
INSERT INTO "etf_snapshot" VALUES(263,'2026-07-13 17:56','2026-07-13','589220','科创200ETF国泰',1.122,-6.03,39586655.0,343259.0,-837257.0,-2.11,334912297.0,334912297.0);
INSERT INTO "etf_snapshot" VALUES(264,'2026-07-13 17:56','2026-07-13','589270','科创100ETF前海开源',1.247,-4.81,4230389.0,33172.0,80683.0,1.91,34313200.0,34313200.0);
INSERT INTO "etf_snapshot" VALUES(265,'2026-07-13 17:56','2026-07-13','589280','科创增强ETF华宝',1.0,-4.85,16243015.0,159335.0,-2105467.0,-12.96,149069000.0,149069000.0);
INSERT INTO "etf_snapshot" VALUES(266,'2026-07-13 17:56','2026-07-13','589300','科创综指ETF嘉实',1.951,-4.78,6632821.0,32719.0,263239.0,3.97,73323458.0,73323458.0);
INSERT INTO "etf_snapshot" VALUES(267,'2026-07-13 17:56','2026-07-13','589320','科创200ETF嘉实',0.948,-6.14,33101361.0,339702.0,-3016041.0,-9.11,105278244.0,105278244.0);
INSERT INTO "etf_snapshot" VALUES(268,'2026-07-13 17:56','2026-07-13','589330','科创200ETF东财',0.964,-5.86,7894148.0,79880.0,-1282993.0,-16.25,82809528.0,82809528.0);
INSERT INTO "etf_snapshot" VALUES(269,'2026-07-13 17:56','2026-07-13','589360','科创50ETF国泰',1.028,-5.69,57137044.0,546286.0,-14260543.0,-24.96,289046872.0,289046872.0);
INSERT INTO "etf_snapshot" VALUES(270,'2026-07-13 17:56','2026-07-13','589500','科创综指ETF工银',1.812,-4.93,17141206.0,92091.0,1168104.0,6.81,154135968.0,154135968.0);
INSERT INTO "etf_snapshot" VALUES(271,'2026-07-13 17:56','2026-07-13','589550','科创价值ETF华夏',1.398,-3.25,7639738.0,53895.0,-831638.0,-10.89,35363109.0,35363109.0);
INSERT INTO "etf_snapshot" VALUES(272,'2026-07-13 17:56','2026-07-13','589580','科创综指ETF兴银',1.795,-6.36,456923.0,2406.0,-170417.0,-37.3,18586866.0,18586866.0);
INSERT INTO "etf_snapshot" VALUES(273,'2026-07-13 17:56','2026-07-13','589600','科创综指ETF富国',1.792,-4.68,23447537.0,128263.0,-2194640.0,-9.36,396990720.0,396990720.0);
INSERT INTO "etf_snapshot" VALUES(274,'2026-07-13 17:56','2026-07-13','589630','科创综指ETF国泰',0.891,-4.91,50782322.0,554284.0,-356330.0,-0.7,295150878.0,295150878.0);
INSERT INTO "etf_snapshot" VALUES(275,'2026-07-13 17:56','2026-07-13','589660','科创综指ETF南方',1.811,-5.03,56205338.0,302117.0,-1465916.0,-2.61,437410830.0,437410830.0);
INSERT INTO "etf_snapshot" VALUES(276,'2026-07-13 17:56','2026-07-13','589680','科创综指ETF鹏华',1.751,-4.58,172836697.0,954018.0,-9583131.0,-5.54,1742146412.0,1742146412.0);
INSERT INTO "etf_snapshot" VALUES(277,'2026-07-13 17:56','2026-07-13','589700','科创成长ETF南方',2.457,-6.33,7986431.0,31918.0,-264676.0,-3.31,35112987.0,35112987.0);
INSERT INTO "etf_snapshot" VALUES(278,'2026-07-13 17:56','2026-07-13','589720','科创创新药ETF国泰',0.926,-2.63,1111610682.0,11886272.0,-110218512.0,-9.92,3457520105.0,3457520105.0);
INSERT INTO "etf_snapshot" VALUES(279,'2026-07-13 17:56','2026-07-13','589770','科创综指ETF招商',1.808,-4.94,20972792.0,113135.0,1882467.0,8.98,277653114.0,277653114.0);
INSERT INTO "etf_snapshot" VALUES(280,'2026-07-13 17:56','2026-07-13','589780','科创200ETF富国',1.351,-5.98,3970928.0,28472.0,-70145.0,-1.77,73244465.0,73244465.0);
INSERT INTO "etf_snapshot" VALUES(281,'2026-07-13 17:56','2026-07-13','589800','科创综指ETF易方达',1.798,-5.07,218956889.0,1185175.0,14031021.0,6.41,1682906798.0,1682906798.0);
INSERT INTO "etf_snapshot" VALUES(282,'2026-07-13 17:56','2026-07-13','589820','科创200ETF建信',1.381,-6.56,11132096.0,77558.0,-1054419.0,-9.47,166714596.0,166714596.0);
INSERT INTO "etf_snapshot" VALUES(283,'2026-07-13 17:56','2026-07-13','589850','科创50ETF东财',1.911,-3.53,204524024.0,1051595.0,-29082147.0,-14.22,930765942.0,930765942.0);
INSERT INTO "etf_snapshot" VALUES(284,'2026-07-13 17:56','2026-07-13','589860','科创综指ETF天弘',1.783,-5.01,37692086.0,205145.0,1696231.0,4.5,296377392.0,296377392.0);
INSERT INTO "etf_snapshot" VALUES(285,'2026-07-13 17:56','2026-07-13','589880','科创综指ETF建信',1.782,-5.01,37564543.0,206617.0,-1698796.0,-4.52,828622872.0,828622872.0);
INSERT INTO "etf_snapshot" VALUES(286,'2026-07-13 17:56','2026-07-13','589890','科创综指ETF景顺',1.776,-4.98,8997384.0,49012.0,-42097.0,-0.47,142056912.0,142056912.0);
INSERT INTO "etf_snapshot" VALUES(287,'2026-07-13 17:56','2026-07-13','589900','科创综指ETF博时',1.808,-5.14,47342341.0,255517.0,-3530566.0,-7.46,296346026.0,296346026.0);
INSERT INTO "etf_snapshot" VALUES(288,'2026-07-13 17:56','2026-07-13','589950','科创100ETF富国',1.452,-5.96,10886468.0,72878.0,-1005201.0,-9.23,458647608.0,458647608.0);
INSERT INTO "etf_snapshot" VALUES(289,'2026-07-13 17:56','2026-07-13','589980','科创100ETF汇添富',2.0,-5.97,6938994.0,33712.0,-437240.0,-6.3,246244000.0,246244000.0);
INSERT INTO "etf_snapshot" VALUES(290,'2026-07-13 17:56','2026-07-13','589990','科创综指ETF华泰柏瑞',1.857,-4.77,16667656.0,86855.0,-3582311.0,-21.49,189581130.0,189581130.0);
INSERT INTO "etf_snapshot" VALUES(291,'2026-07-13 17:56','2026-07-13','512000','券商ETF华宝',0.525,-1.32,1179412000.0,22365618.0,-91269952.0,-7.74,39109789286.0,39109789286.0);
INSERT INTO "etf_snapshot" VALUES(292,'2026-07-13 17:56','2026-07-13','512010','医药ETF易方达',0.36,-0.83,503831116.0,13989540.0,-29848351.0,-5.92,17492290191.0,17492290191.0);
INSERT INTO "etf_snapshot" VALUES(293,'2026-07-13 17:56','2026-07-13','515880','通信ETF国泰',0.738,-5.26,4025785595.0,53432032.0,-518377536.0,-12.88,51764630594.0,51764630594.0);
INSERT INTO "etf_snapshot" VALUES(294,'2026-07-13 17:56','2026-07-13','516020','化工ETF华宝',0.804,-4.4,124737720.0,1533262.0,-5195902.0,-4.17,3166414271.0,3166414271.0);
INSERT INTO "etf_snapshot" VALUES(295,'2026-07-13 17:56','2026-07-13','159022','科创创业人工智能ETF富国',1.174,-3.69,28045972.912,234270.0,-3963169.0,-14.13,183884755.0,183884755.0);
INSERT INTO "etf_snapshot" VALUES(296,'2026-07-13 17:56','2026-07-13','159039','机器人ETF华安',0.919,-5.94,73226354.26,783353.0,-12015973.0,-16.41,361591049.0,361591049.0);
INSERT INTO "etf_snapshot" VALUES(297,'2026-07-13 17:56','2026-07-13','159048','机器人ETF大成',0.941,-6.37,33391766.824,347880.0,-6000743.0,-17.97,154139467.0,154139467.0);
INSERT INTO "etf_snapshot" VALUES(298,'2026-07-13 17:56','2026-07-13','159050','机器人ETF广发',0.929,-6.63,83069969.677,874146.0,-18573439.0,-22.36,578491659.0,578491659.0);
INSERT INTO "etf_snapshot" VALUES(299,'2026-07-13 17:56','2026-07-13','159139','科创创业人工智能ETF华泰柏瑞',1.46,-4.01,48674219.1,322937.0,-1824550.0,-3.75,192879447.0,192879447.0);
INSERT INTO "etf_snapshot" VALUES(300,'2026-07-13 17:56','2026-07-13','159140','科创创业人工智能ETF易方达',1.469,-4.3,95624922.986,635228.0,-13062955.0,-13.66,637453206.0,637453206.0);
INSERT INTO "etf_snapshot" VALUES(301,'2026-07-13 17:56','2026-07-13','159141','科创创业人工智能ETF永赢',1.391,-3.6,136216196.913,967898.0,-5581235.0,-4.1,1940529484.0,1940529484.0);
INSERT INTO "etf_snapshot" VALUES(302,'2026-07-13 17:56','2026-07-13','159142','科创创业人工智能ETF景顺',1.42,-3.6,98707189.0,682643.0,-14383879.0,-14.57,1384869404.0,1384869404.0);
INSERT INTO "etf_snapshot" VALUES(303,'2026-07-13 17:56','2026-07-13','159213','机器人ETF汇添富',1.257,-5.7,49312064.3,384872.0,-5952597.0,-12.07,561549123.0,561549123.0);
INSERT INTO "etf_snapshot" VALUES(304,'2026-07-13 17:56','2026-07-13','159242','创业板人工智能ETF大成',2.276,-4.33,198143164.795,849705.0,-1256369.0,-0.63,1311610039.0,1311610039.0);
INSERT INTO "etf_snapshot" VALUES(305,'2026-07-13 17:56','2026-07-13','159243','创业板人工智能ETF招商',1.366,-4.81,63593732.6,452272.0,-2870493.0,-4.51,180353286.0,180353286.0);
INSERT INTO "etf_snapshot" VALUES(306,'2026-07-13 17:56','2026-07-13','159246','创业板人工智能ETF富国',1.272,-4.22,214950129.045,1661898.0,-6933573.0,-3.23,4520249923.0,4520249923.0);
INSERT INTO "etf_snapshot" VALUES(307,'2026-07-13 17:56','2026-07-13','159248','人工智能ETF万家',2.033,-3.19,29535839.6,142695.0,-5686095.0,-19.25,227890461.0,227890461.0);
INSERT INTO "etf_snapshot" VALUES(308,'2026-07-13 17:56','2026-07-13','159258','机器人ETF南方',1.168,-6.03,39541212.7,331256.0,-3074094.0,-7.77,1387310296.0,1387310296.0);
INSERT INTO "etf_snapshot" VALUES(309,'2026-07-13 17:56','2026-07-13','159272','机器人ETF富国',0.879,-6.49,462070026.999,5152339.0,-103773963.0,-22.46,2296971761.0,2296971761.0);
INSERT INTO "etf_snapshot" VALUES(310,'2026-07-13 17:56','2026-07-13','159278','机器人ETF鹏华',1.034,-6.17,250988593.29,2378972.0,-69434755.0,-27.66,1845220415.0,1845220415.0);
INSERT INTO "etf_snapshot" VALUES(311,'2026-07-13 17:56','2026-07-13','159279','创业板人工智能ETF华安',1.523,-4.81,103045762.019,660166.0,2846933.0,2.76,218379214.0,218379214.0);
INSERT INTO "etf_snapshot" VALUES(312,'2026-07-13 17:56','2026-07-13','159310','芯片ETF天弘',3.562,-7.19,63060037.9,172108.0,-22945902.0,-36.39,1652700635.0,1652700635.0);
INSERT INTO "etf_snapshot" VALUES(313,'2026-07-13 17:56','2026-07-13','159325','半导体ETF南方',2.593,-6.29,262079200.4,982861.0,-32804535.0,-12.52,1437716149.0,1437716149.0);
INSERT INTO "etf_snapshot" VALUES(314,'2026-07-13 17:56','2026-07-13','159327','半导体设备ETF万家',4.114,-7.7,505036096.6,1187841.0,-14637462.0,-2.9,2602206632.0,2602206632.0);
INSERT INTO "etf_snapshot" VALUES(315,'2026-07-13 17:56','2026-07-13','159363','创业板人工智能ETF华宝',1.348,-4.53,1980171337.951,14447742.0,-73435136.0,-3.71,7147324966.0,7147324966.0);
INSERT INTO "etf_snapshot" VALUES(316,'2026-07-13 17:56','2026-07-13','159381','创业板人工智能ETF华夏',1.278,-4.41,648212076.6,4968496.0,-28301753.0,-4.37,2087169790.0,2087169790.0);
INSERT INTO "etf_snapshot" VALUES(317,'2026-07-13 17:56','2026-07-13','159382','创业板人工智能ETF南方',2.882,-4.44,560976612.74,1902668.0,-4160916.0,-0.74,2383574562.0,2383574562.0);
INSERT INTO "etf_snapshot" VALUES(318,'2026-07-13 17:56','2026-07-13','159388','创业板人工智能ETF国泰',1.103,-4.42,226600491.05,2002672.0,-10401738.0,-4.59,918508902.0,918508902.0);
INSERT INTO "etf_snapshot" VALUES(319,'2026-07-13 17:56','2026-07-13','159516','半导体设备ETF国泰',0.865,-4.42,8284913306.512,93309690.0,-850928432.0,-10.27,48961906400.0,48961906400.0);
INSERT INTO "etf_snapshot" VALUES(320,'2026-07-13 17:56','2026-07-13','159526','机器人ETF嘉实',1.535,-5.6,42689568.8,273055.0,-7036996.0,-16.48,871823144.0,871823144.0);
INSERT INTO "etf_snapshot" VALUES(321,'2026-07-13 17:56','2026-07-13','159530','机器人ETF易方达',1.456,-6.61,1470395826.988,9848214.0,-370197537.0,-25.18,17474348610.0,17474348610.0);
INSERT INTO "etf_snapshot" VALUES(322,'2026-07-13 17:56','2026-07-13','159551','机器人ETF国泰',1.351,-6.05,38980914.2,284054.0,-828961.0,-2.13,390332174.0,390332174.0);
INSERT INTO "etf_snapshot" VALUES(323,'2026-07-13 17:56','2026-07-13','159558','半导体设备ETF易方达',1.351,-6.51,3018475417.763,21713267.0,-357203856.0,-11.83,19611877921.0,19611877921.0);
INSERT INTO "etf_snapshot" VALUES(324,'2026-07-13 17:56','2026-07-13','159559','机器人ETF景顺',1.308,-6.3,220068509.6,1646597.0,-73893275.0,-33.58,2340766224.0,2340766224.0);
INSERT INTO "etf_snapshot" VALUES(325,'2026-07-13 17:56','2026-07-13','159560','芯片ETF景顺',2.849,-5.29,50055139.8,170621.0,-6375703.0,-12.74,516855495.0,516855495.0);
INSERT INTO "etf_snapshot" VALUES(326,'2026-07-13 17:56','2026-07-13','159582','半导体ETF博时',0.929,-6.91,186960267.9,1969587.0,-41571495.0,-22.24,794859936.0,794859936.0);
INSERT INTO "etf_snapshot" VALUES(327,'2026-07-13 17:56','2026-07-13','159599','芯片ETF东财',3.525,-5.37,357942742.52,989161.0,-28539338.0,-7.97,2447485276.0,2447485276.0);
INSERT INTO "etf_snapshot" VALUES(328,'2026-07-13 17:56','2026-07-13','159665','半导体龙头ETF工银',3.024,-5.59,154356147.3,496888.0,-5506591.0,-3.57,748672425.0,748672425.0);
INSERT INTO "etf_snapshot" VALUES(329,'2026-07-13 17:56','2026-07-13','159770','机器人ETF天弘',1.078,-6.1,269362586.825,2448236.0,-89146605.0,-33.1,6127985623.0,6127985623.0);
INSERT INTO "etf_snapshot" VALUES(330,'2026-07-13 17:56','2026-07-13','159801','芯片ETF广发',1.439,-5.64,540448174.601,3641259.0,-42628223.0,-7.89,6163409933.0,6163409933.0);
INSERT INTO "etf_snapshot" VALUES(331,'2026-07-13 17:56','2026-07-13','159813','半导体ETF鹏华',1.856,-4.43,1169064680.516,6167466.0,-53212960.0,-4.55,7536960644.0,7536960644.0);
INSERT INTO "etf_snapshot" VALUES(332,'2026-07-13 17:56','2026-07-13','159819','人工智能ETF易方达',2.051,-3.07,885645224.663,4237103.0,-125548309.0,-14.18,22674276106.0,22674276106.0);
INSERT INTO "etf_snapshot" VALUES(333,'2026-07-13 17:56','2026-07-13','159995','芯片ETF华夏',1.458,-5.02,2323255988.453,15611359.0,-306312112.0,-13.18,32551491825.0,32551491825.0);
INSERT INTO "etf_snapshot" VALUES(334,'2026-07-13 17:56','2026-07-13','512480','半导体ETF国联安',1.292,-5.62,2174189014.0,16362728.0,-323736192.0,-14.89,23051873426.0,23051873426.0);
INSERT INTO "etf_snapshot" VALUES(335,'2026-07-13 17:56','2026-07-13','512760','芯片ETF国泰',1.381,-4.63,900073593.0,6336674.0,-79773011.0,-8.86,12574620418.0,12574620418.0);
INSERT INTO "etf_snapshot" VALUES(336,'2026-07-13 17:56','2026-07-13','512930','AI人工智能ETF平安',0.729,-3.06,254701119.0,3431369.0,-38075132.0,-14.95,3508327966.0,3508327966.0);
INSERT INTO "etf_snapshot" VALUES(337,'2026-07-13 17:56','2026-07-13','513310','中韩半导体ETF华泰柏瑞',5.598,-6.22,11375164636.0,19898593.0,-352247744.0,-3.1,13000946391.0,13000946391.0);
INSERT INTO "etf_snapshot" VALUES(338,'2026-07-13 17:56','2026-07-13','515070','人工智能ETF华夏',1.296,-3.36,262367655.0,1983894.0,-17378439.0,-6.62,9583842779.0,9583842779.0);
INSERT INTO "etf_snapshot" VALUES(339,'2026-07-13 17:56','2026-07-13','515980','人工智能ETF华富',1.18,-3.44,841798073.0,7044057.0,-90786022.0,-10.78,6632932173.0,6632932173.0);
INSERT INTO "etf_snapshot" VALUES(340,'2026-07-13 17:56','2026-07-13','516350','芯片ETF易方达',2.06,-6.06,334614086.0,1572731.0,-21517547.0,-6.43,2744775510.0,2744775510.0);
INSERT INTO "etf_snapshot" VALUES(341,'2026-07-13 17:56','2026-07-13','516640','芯片ETF富国',1.823,-4.7,413701425.0,2201502.0,-5796795.0,-1.4,2585894144.0,2585894144.0);
INSERT INTO "etf_snapshot" VALUES(342,'2026-07-13 17:56','2026-07-13','516920','芯片ETF汇添富',1.774,-5.89,90996416.0,499741.0,-20870364.0,-22.94,850567376.0,850567376.0);
INSERT INTO "etf_snapshot" VALUES(343,'2026-07-13 17:56','2026-07-13','517800','人工智能50ETF方正富邦',1.1,-2.65,14406243.0,128662.0,-1643513.0,-11.41,237093670.0,237093670.0);
INSERT INTO "etf_snapshot" VALUES(344,'2026-07-13 17:56','2026-07-13','560630','机器人ETF万家',1.172,-6.24,17559354.0,147244.0,-5096725.0,-29.03,175089768.0,175089768.0);
INSERT INTO "etf_snapshot" VALUES(345,'2026-07-13 17:56','2026-07-13','560770','机器人ETF招商',1.032,-5.93,37471253.0,356859.0,-9842770.0,-26.27,1605413264.0,1605413264.0);
INSERT INTO "etf_snapshot" VALUES(346,'2026-07-13 17:56','2026-07-13','560780','半导体设备ETF广发',1.273,-7.01,1763990476.0,13422935.0,-148845184.0,-8.44,13410403305.0,13410403305.0);
INSERT INTO "etf_snapshot" VALUES(347,'2026-07-13 17:56','2026-07-13','561460','人工智能ETF天弘',0.943,-3.68,31215981.0,324900.0,-4241642.0,-13.59,253214360.0,253214360.0);
INSERT INTO "etf_snapshot" VALUES(348,'2026-07-13 17:56','2026-07-13','561980','半导体设备ETF招商',0.842,-3.77,945271088.0,10909504.0,-137648064.0,-14.56,8087873167.0,8087873167.0);
INSERT INTO "etf_snapshot" VALUES(349,'2026-07-13 17:56','2026-07-13','562360','机器人ETF银华',1.128,-5.84,27113739.0,236160.0,-5459887.0,-20.14,303966672.0,303966672.0);
INSERT INTO "etf_snapshot" VALUES(350,'2026-07-13 17:56','2026-07-13','562500','机器人ETF华夏',1.042,-5.96,1092391983.0,10263751.0,-275987775.0,-25.26,17525593062.0,17525593062.0);
INSERT INTO "etf_snapshot" VALUES(351,'2026-07-13 17:56','2026-07-13','562590','半导体设备ETF华夏',1.219,-6.73,989769605.0,7873350.0,-122134959.0,-12.34,9463083659.0,9463083659.0);
INSERT INTO "etf_snapshot" VALUES(352,'2026-07-13 17:56','2026-07-13','588170','科创半导体ETF华夏',1.214,-6.04,7659092283.0,61196725.0,-363903088.0,-4.75,34661456707.0,34661456707.0);
INSERT INTO "etf_snapshot" VALUES(353,'2026-07-13 17:56','2026-07-13','588200','科创芯片ETF嘉实',4.332,-5.1,7448106694.0,16735665.0,-293898176.0,-3.95,59681507927.0,59681507927.0);
INSERT INTO "etf_snapshot" VALUES(354,'2026-07-13 17:56','2026-07-13','588290','科创芯片ETF华安',4.244,-5.16,574243277.0,1312104.0,45999810.0,8.01,5523128902.0,5523128902.0);
INSERT INTO "etf_snapshot" VALUES(355,'2026-07-13 17:56','2026-07-13','588410','科创创业人工智能ETF鹏华',1.404,-3.9,7598022.0,53071.0,-2913748.0,-38.35,147771000.0,147771000.0);
INSERT INTO "etf_snapshot" VALUES(356,'2026-07-13 17:56','2026-07-13','588420','科创创业人工智能ETF摩根',1.402,-4.17,22999222.0,160284.0,-2155868.0,-9.37,178962496.0,178962496.0);
INSERT INTO "etf_snapshot" VALUES(357,'2026-07-13 17:56','2026-07-13','588430','科创创业人工智能ETF工银',1.432,-4.21,18245519.0,124655.0,-1131766.0,-6.2,129535856.0,129535856.0);
INSERT INTO "etf_snapshot" VALUES(358,'2026-07-13 17:56','2026-07-13','588470','科创创业人工智能ETF华安',0.994,-3.96,56216685.0,554977.0,-8394885.0,-14.93,240455558.0,240455558.0);
INSERT INTO "etf_snapshot" VALUES(359,'2026-07-13 17:56','2026-07-13','588480','科创创业人工智能ETF中金',1.059,-3.73,15315995.0,142069.0,-3515826.0,-22.96,183966303.0,183966303.0);
INSERT INTO "etf_snapshot" VALUES(360,'2026-07-13 17:56','2026-07-13','588510','科创创业人工智能ETF华夏',1.005,-3.64,30396924.0,299703.0,-6916493.0,-22.75,252430875.0,252430875.0);
INSERT INTO "etf_snapshot" VALUES(361,'2026-07-13 17:56','2026-07-13','588710','科创半导体设备ETF华泰柏瑞',3.751,-5.85,2053450257.0,5334938.0,-132888832.0,-6.47,7878206575.0,7878206575.0);
INSERT INTO "etf_snapshot" VALUES(362,'2026-07-13 17:56','2026-07-13','588730','科创人工智能ETF易方达',1.743,-4.49,190821742.0,1058333.0,5241713.0,2.75,1095294758.0,1095294758.0);
INSERT INTO "etf_snapshot" VALUES(363,'2026-07-13 17:56','2026-07-13','588750','科创芯片ETF汇添富',2.896,-4.86,578239981.0,1949960.0,-3146446.0,-0.54,9447412288.0,9447412288.0);
INSERT INTO "etf_snapshot" VALUES(364,'2026-07-13 17:56','2026-07-13','588760','科创人工智能ETF广发',0.886,-4.32,441343057.0,4803787.0,-22521161.0,-5.1,1798165352.0,1798165352.0);
INSERT INTO "etf_snapshot" VALUES(365,'2026-07-13 17:56','2026-07-13','588780','科创芯片设计ETF国联安',1.198,-5.67,318028124.0,2552810.0,-22699360.0,-7.14,1126002596.0,1126002596.0);
INSERT INTO "etf_snapshot" VALUES(366,'2026-07-13 17:56','2026-07-13','588790','科创AIETF博时',0.932,-4.61,483679851.0,5011254.0,-29902938.0,-6.18,2486933888.0,2486933888.0);
INSERT INTO "etf_snapshot" VALUES(367,'2026-07-13 17:56','2026-07-13','588810','科创芯片ETF富国',3.081,-4.2,202860073.0,638033.0,-13359360.0,-6.59,1849598244.0,1849598244.0);
INSERT INTO "etf_snapshot" VALUES(368,'2026-07-13 17:56','2026-07-13','588890','科创芯片ETF南方',4.879,-5.35,473333666.0,931796.0,-12779857.0,-2.7,4643880990.0,4643880990.0);
INSERT INTO "etf_snapshot" VALUES(369,'2026-07-13 17:56','2026-07-13','588920','科创芯片ETF鹏华',2.782,-3.9,85161750.0,297716.0,-7850468.0,-9.22,426864516.0,426864516.0);
INSERT INTO "etf_snapshot" VALUES(370,'2026-07-13 17:56','2026-07-13','588930','科创人工智能ETF银华',1.847,-4.05,152204360.0,795277.0,-3748754.0,-2.46,1062632678.0,1062632678.0);
INSERT INTO "etf_snapshot" VALUES(371,'2026-07-13 17:56','2026-07-13','588990','科创芯片ETF博时',4.522,-5.5,111089786.0,237912.0,-4300605.0,-3.87,903248699.0,903248699.0);
INSERT INTO "etf_snapshot" VALUES(372,'2026-07-13 17:56','2026-07-13','589010','科创人工智能ETF华夏',1.66,-3.77,228933784.0,1331453.0,-388722.0,-0.17,1473736393.0,1473736393.0);
INSERT INTO "etf_snapshot" VALUES(373,'2026-07-13 17:56','2026-07-13','589020','科创半导体设备ETF鹏华',2.955,-6.31,1742647337.0,5750086.0,-78151968.0,-4.48,3552557169.0,3552557169.0);
INSERT INTO "etf_snapshot" VALUES(374,'2026-07-13 17:56','2026-07-13','589030','科创芯片设计ETF易方达',1.392,-5.63,97040292.0,669979.0,-7673177.0,-7.91,423275195.0,423275195.0);
INSERT INTO "etf_snapshot" VALUES(375,'2026-07-13 17:56','2026-07-13','589070','科创芯片设计ETF天弘',1.307,-5.63,208644873.0,1531634.0,-4778178.0,-2.29,2356903961.0,2356903961.0);
INSERT INTO "etf_snapshot" VALUES(376,'2026-07-13 17:56','2026-07-13','589090','科创AIETF鹏华',1.251,-4.06,8101648.0,63306.0,-297345.0,-3.67,190065681.0,190065681.0);
INSERT INTO "etf_snapshot" VALUES(377,'2026-07-13 17:56','2026-07-13','589100','科创芯片ETF国泰',1.113,-5.68,103439960.0,903600.0,-17089696.0,-16.52,1001079498.0,1001079498.0);
INSERT INTO "etf_snapshot" VALUES(378,'2026-07-13 17:56','2026-07-13','589110','科创人工智能ETF国泰',1.085,-4.49,9734303.0,87012.0,-153746.0,-1.58,527758114.0,527758114.0);
INSERT INTO "etf_snapshot" VALUES(379,'2026-07-13 17:56','2026-07-13','589130','科创芯片ETF易方达',1.714,-5.62,346236983.0,1955904.0,-44501526.0,-12.85,5115912920.0,5115912920.0);
INSERT INTO "etf_snapshot" VALUES(380,'2026-07-13 17:56','2026-07-13','589160','科创芯片ETF广发',1.565,-6.18,97979398.0,607496.0,-7085426.0,-7.23,416753240.0,416753240.0);
INSERT INTO "etf_snapshot" VALUES(381,'2026-07-13 17:56','2026-07-13','589170','科创芯片设计ETF鹏华',1.313,-5.68,11975957.0,87970.0,-1426108.0,-11.91,166631517.0,166631517.0);
INSERT INTO "etf_snapshot" VALUES(382,'2026-07-13 17:56','2026-07-13','589190','科创芯片ETF华宝',1.577,-3.49,140789404.0,867872.0,1238615.0,0.88,2447158650.0,2447158650.0);
INSERT INTO "etf_snapshot" VALUES(383,'2026-07-13 17:56','2026-07-13','589210','科创芯片设计ETF广发',1.654,-7.55,58888713.0,339760.0,-4696939.0,-7.98,1118879739.0,1118879739.0);
INSERT INTO "etf_snapshot" VALUES(384,'2026-07-13 17:56','2026-07-13','589230','科创人工智能ETF南方',1.012,-4.71,33385556.0,318838.0,-52564.0,-0.16,208525636.0,208525636.0);
INSERT INTO "etf_snapshot" VALUES(385,'2026-07-13 17:56','2026-07-13','589250','科创芯片设计ETF浦银',1.517,-5.95,15791732.0,100634.0,-41394.0,-0.26,107860672.0,107860672.0);
INSERT INTO "etf_snapshot" VALUES(386,'2026-07-13 17:56','2026-07-13','589260','科创芯片设计ETF国泰',1.518,-5.54,11119353.0,70955.0,-776772.0,-6.99,79172808.0,79172808.0);
INSERT INTO "etf_snapshot" VALUES(387,'2026-07-13 17:56','2026-07-13','589290','科创芯片设计ETF汇添富',0.97,-5.64,22198154.0,222644.0,-6523850.0,-29.39,116253433.0,116253433.0);
INSERT INTO "etf_snapshot" VALUES(388,'2026-07-13 17:56','2026-07-13','589310','科创人工智能ETF鑫元',0.975,-4.13,17849903.0,178186.0,-1988627.0,-11.14,276404513.0,276404513.0);
INSERT INTO "etf_snapshot" VALUES(389,'2026-07-13 17:56','2026-07-13','589350','科创芯片设计ETF银华',0.943,-6.91,23737380.0,244138.0,-10298978.0,-43.39,145487455.0,145487455.0);
INSERT INTO "etf_snapshot" VALUES(390,'2026-07-13 17:56','2026-07-13','589380','科创人工智能ETF富国',1.672,-4.18,5879310.0,34325.0,847466.0,14.41,146624870.0,146624870.0);
INSERT INTO "etf_snapshot" VALUES(391,'2026-07-13 17:56','2026-07-13','589390','科创芯片设计ETF招商',0.934,-5.56,215132517.0,2187030.0,-7589126.0,-3.53,1109415003.0,1109415003.0);
INSERT INTO "etf_snapshot" VALUES(392,'2026-07-13 17:56','2026-07-13','589400','科创芯片设计ETF富国',0.937,-5.35,27791347.0,286084.0,-3485237.0,-12.54,265906732.0,265906732.0);
INSERT INTO "etf_snapshot" VALUES(393,'2026-07-13 17:56','2026-07-13','589420','科创芯片设计ETF永赢',0.943,-5.51,20160086.0,207715.0,-3852981.0,-19.11,281468058.0,281468058.0);
INSERT INTO "etf_snapshot" VALUES(394,'2026-07-13 17:56','2026-07-13','589520','科创人工智能ETF华宝',0.708,-4.19,59581451.0,815737.0,-5188250.0,-8.71,448238062.0,448238062.0);
INSERT INTO "etf_snapshot" VALUES(395,'2026-07-13 17:56','2026-07-13','589560','科创人工智能ETF汇添富',1.122,-4.43,13789534.0,120402.0,-2334561.0,-16.93,247238310.0,247238310.0);
INSERT INTO "etf_snapshot" VALUES(396,'2026-07-13 18:57','2026-07-13','159215','A500ETF平安',1.334,-2.41,31161902.075,233079.0,-3011165.0,-9.66,1250735455.0,1250735455.0);
INSERT INTO "etf_snapshot" VALUES(397,'2026-07-13 18:57','2026-07-13','159226','中证A500增强ETF国泰',1.254,-3.32,29099502.4,229303.0,-5091695.0,-17.5,105454929.0,105454929.0);
INSERT INTO "etf_snapshot" VALUES(398,'2026-07-13 18:57','2026-07-13','159238','沪深300增强ETF景顺',1.335,-1.04,6213641.8,46574.0,-267562.0,-4.31,54756608.0,54756608.0);
INSERT INTO "etf_snapshot" VALUES(399,'2026-07-13 18:57','2026-07-13','159240','A500增强ETF天弘',1.31,-3.11,7902611.0,60044.0,-1338439.0,-16.94,19151907.0,19151907.0);
INSERT INTO "etf_snapshot" VALUES(400,'2026-07-13 18:57','2026-07-13','159249','A500增强ETF工银',1.337,-2.69,18332404.5,135717.0,754481.0,4.12,124597601.0,124597601.0);
INSERT INTO "etf_snapshot" VALUES(401,'2026-07-13 18:57','2026-07-13','159300','沪深300ETF富国',5.091,-1.62,519035712.0,1021000.0,-203068263.0,-39.12,912093872.0,912093872.0);
INSERT INTO "etf_snapshot" VALUES(402,'2026-07-13 18:57','2026-07-13','159330','沪深300ETF东财',1.465,-1.74,62464669.3,424453.0,-21604766.0,-34.59,491948477.0,491948477.0);
INSERT INTO "etf_snapshot" VALUES(403,'2026-07-13 18:57','2026-07-13','159337','中证500ETF东财',1.875,-3.15,36377886.7,193418.0,129375.0,0.36,464457396.0,464457396.0);
INSERT INTO "etf_snapshot" VALUES(404,'2026-07-13 18:57','2026-07-13','159338','中证A500ETF国泰',1.248,-2.65,3840034204.0,30473995.0,-250492256.0,-6.52,23563596227.0,23563596227.0);
INSERT INTO "etf_snapshot" VALUES(405,'2026-07-13 18:57','2026-07-13','159339','A500ETF银华',1.26,-2.85,108247119.335,852480.0,-15419149.0,-14.24,2187469428.0,2187469428.0);
INSERT INTO "etf_snapshot" VALUES(406,'2026-07-13 18:57','2026-07-13','159351','A500ETF嘉实',1.253,-2.57,754887152.9,5999048.0,-20203613.0,-2.68,7471793690.0,7471793690.0);
INSERT INTO "etf_snapshot" VALUES(407,'2026-07-13 18:57','2026-07-13','159352','A500ETF南方',1.297,-2.85,3633284820.9,27709491.0,-118125776.0,-3.25,28423886900.0,28423886900.0);
INSERT INTO "etf_snapshot" VALUES(408,'2026-07-13 18:57','2026-07-13','159353','中证A500ETF景顺',1.26,-3.0,196166950.678,1540431.0,-12437346.0,-6.34,3684443878.0,3684443878.0);
INSERT INTO "etf_snapshot" VALUES(409,'2026-07-13 18:57','2026-07-13','159356','A500ETF万家',1.322,-2.29,86012231.3,646476.0,-1251681.0,-1.46,891187486.0,891187486.0);
INSERT INTO "etf_snapshot" VALUES(410,'2026-07-13 18:57','2026-07-13','159357','A500ETF博时',1.315,-2.66,33162127.188,250177.0,-2341452.0,-7.06,1548851500.0,1548851500.0);
INSERT INTO "etf_snapshot" VALUES(411,'2026-07-13 18:57','2026-07-13','159358','中证A500ETF大成',1.338,-2.62,79818969.0,589629.0,-4109919.0,-5.15,797590385.0,797590385.0);
INSERT INTO "etf_snapshot" VALUES(412,'2026-07-13 18:57','2026-07-13','159359','A500ETF华安',1.308,-2.68,48957665.1,370710.0,-381064.0,-0.78,893547685.0,893547685.0);
INSERT INTO "etf_snapshot" VALUES(413,'2026-07-13 18:57','2026-07-13','159360','A500ETF天弘',1.339,-2.55,68880940.2,510618.0,-3122826.0,-4.53,1541436083.0,1541436083.0);
INSERT INTO "etf_snapshot" VALUES(414,'2026-07-13 18:57','2026-07-13','159361','A500ETF易方达',1.274,-2.82,1855242128.25,14427709.0,-58443067.0,-3.15,24425243129.0,24425243129.0);
INSERT INTO "etf_snapshot" VALUES(415,'2026-07-13 18:57','2026-07-13','159362','A500ETF工银',1.33,-2.56,55743308.988,415214.0,-1038328.0,-1.86,1862239655.0,1862239655.0);
INSERT INTO "etf_snapshot" VALUES(416,'2026-07-13 18:57','2026-07-13','159376','A500ETF浦银',1.362,-2.44,14904020.9,108823.0,-1194345.0,-8.01,95234196.0,95234196.0);
INSERT INTO "etf_snapshot" VALUES(417,'2026-07-13 18:57','2026-07-13','159379','A500ETF融通',1.365,-3.05,4232108.5,30404.0,159411.0,3.77,220886308.0,220886308.0);
INSERT INTO "etf_snapshot" VALUES(418,'2026-07-13 18:57','2026-07-13','159380','A500ETF东财',1.383,-3.15,27380172.0,195991.0,-13419253.0,-49.01,168455398.0,168455398.0);
INSERT INTO "etf_snapshot" VALUES(419,'2026-07-13 18:57','2026-07-13','159386','A500ETF永赢',1.312,-2.89,24109762.4,181865.0,-397041.0,-1.65,91668861.0,91668861.0);
INSERT INTO "etf_snapshot" VALUES(420,'2026-07-13 18:57','2026-07-13','159393','沪深300ETF万家',5.01,-1.86,103935999.7,206700.0,-48520191.0,-46.68,282796173.0,282796173.0);
INSERT INTO "etf_snapshot" VALUES(421,'2026-07-13 18:57','2026-07-13','159500','中证500ETF富国',1.232,-2.99,35022229.922,284254.0,-8737810.0,-24.95,173143882.0,173143882.0);
INSERT INTO "etf_snapshot" VALUES(422,'2026-07-13 18:57','2026-07-13','159510','沪深300价值ETF华夏',1.207,-0.9,4048997.9,33509.0,-364501.0,-9.0,73781909.0,73781909.0);
INSERT INTO "etf_snapshot" VALUES(423,'2026-07-13 18:57','2026-07-13','159523','沪深300成长ETF华夏',1.291,-2.05,13839630.5,106291.0,-1916639.0,-13.85,87164896.0,87164896.0);
INSERT INTO "etf_snapshot" VALUES(424,'2026-07-13 18:57','2026-07-13','159606','中证500成长ETF易方达',1.32,-3.01,22661063.112,169288.0,-95244.0,-0.42,497934138.0,497934138.0);
INSERT INTO "etf_snapshot" VALUES(425,'2026-07-13 18:57','2026-07-13','159610','中证500增强ETF景顺',1.298,-3.35,11578358.562,88483.0,-2608180.0,-22.53,204523533.0,204523533.0);
INSERT INTO "etf_snapshot" VALUES(426,'2026-07-13 18:57','2026-07-13','159617','中证500价值ETF华夏',1.302,-1.14,7236360.4,55322.0,-190802.0,-2.64,37000733.0,37000733.0);
INSERT INTO "etf_snapshot" VALUES(427,'2026-07-13 18:57','2026-07-13','159620','中证500成长ETF华夏',1.305,-4.33,6737039.2,50779.0,-316635.0,-4.7,39333919.0,39333919.0);
INSERT INTO "etf_snapshot" VALUES(428,'2026-07-13 18:57','2026-07-13','159629','中证1000ETF富国',3.251,-4.77,510143555.65,1541002.0,-48281751.0,-9.46,1616568385.0,1616568385.0);
INSERT INTO "etf_snapshot" VALUES(429,'2026-07-13 18:57','2026-07-13','159633','中证1000ETF易方达',3.328,-4.91,1400323490.218,4136127.0,-46115681.0,-3.29,2350109319.0,2350109319.0);
INSERT INTO "etf_snapshot" VALUES(430,'2026-07-13 18:57','2026-07-13','159656','沪深300成长ETF万家',1.26,-2.4,30408354.975,239563.0,-2420931.0,-7.96,285060448.0,285060448.0);
INSERT INTO "etf_snapshot" VALUES(431,'2026-07-13 18:57','2026-07-13','159673','沪深300ETF鹏华',1.301,-2.03,97652780.1,746272.0,-4321107.0,-4.42,1776552428.0,1776552428.0);
INSERT INTO "etf_snapshot" VALUES(432,'2026-07-13 18:57','2026-07-13','159677','中证1000增强ETF银华',1.481,-4.2,10262881.3,68284.0,505227.0,4.92,39844959.0,39844959.0);
INSERT INTO "etf_snapshot" VALUES(433,'2026-07-13 18:57','2026-07-13','159679','中证1000增强ETF国泰',1.206,-5.85,9239971.1,75087.0,-2911555.0,-31.51,59925122.0,59925122.0);
INSERT INTO "etf_snapshot" VALUES(434,'2026-07-13 18:57','2026-07-13','159680','中证1000增强ETF招商',1.651,-5.6,115120987.451,685787.0,-12862103.0,-11.17,1333080270.0,1333080270.0);
INSERT INTO "etf_snapshot" VALUES(435,'2026-07-13 18:57','2026-07-13','159820','中证500ETF天弘',1.409,-4.02,17544031.8,122771.0,-3278708.0,-18.69,1798459526.0,1798459526.0);
INSERT INTO "etf_snapshot" VALUES(436,'2026-07-13 18:57','2026-07-13','159845','中证1000ETF华夏',3.242,-4.84,5927633630.277,18057886.0,-267489360.0,-4.51,7094875795.0,7094875795.0);
INSERT INTO "etf_snapshot" VALUES(437,'2026-07-13 18:57','2026-07-13','159919','沪深300ETF嘉实',4.949,-1.77,1727294361.769,3478248.0,-208708752.0,-12.08,26627682585.0,26627682585.0);
INSERT INTO "etf_snapshot" VALUES(438,'2026-07-13 18:57','2026-07-13','159922','中证500ETF嘉实',3.304,-4.37,1125867988.248,3371397.0,-137687987.0,-12.23,7779852041.0,7779852041.0);
INSERT INTO "etf_snapshot" VALUES(439,'2026-07-13 18:57','2026-07-13','159925','沪深300ETF南方',4.805,-1.66,373632716.562,776246.0,-1953760.0,-0.52,2613539752.0,2613539752.0);
INSERT INTO "etf_snapshot" VALUES(440,'2026-07-13 18:57','2026-07-13','159935','中证500ETF景顺',2.576,-3.77,5202853.8,20011.0,639176.0,12.29,63299935.0,63299935.0);
INSERT INTO "etf_snapshot" VALUES(441,'2026-07-13 18:57','2026-07-13','159968','中证500ETF博时',10.685,-3.58,34345875.442,31859.0,-9778869.0,-28.47,650664122.0,650664122.0);
INSERT INTO "etf_snapshot" VALUES(442,'2026-07-13 18:57','2026-07-13','159982','中证500ETF鹏华',2.181,-3.88,30789737.5,139773.0,-3872510.0,-12.58,301438743.0,301438743.0);
INSERT INTO "etf_snapshot" VALUES(443,'2026-07-13 18:57','2026-07-13','510050','上证50ETF华夏',3.011,-1.5,2176640357.0,7193570.0,-316834864.0,-14.56,19296495976.0,19296495976.0);
INSERT INTO "etf_snapshot" VALUES(444,'2026-07-13 18:57','2026-07-13','510100','上证50ETF易方达',2.955,-1.53,418597672.0,1410728.0,-12617058.0,-3.01,2988116094.0,2988116094.0);
INSERT INTO "etf_snapshot" VALUES(445,'2026-07-13 18:57','2026-07-13','510190','上证50ETF华安',4.312,-1.19,2566320.0,5954.0,498906.0,19.44,101982250.0,101982250.0);
INSERT INTO "etf_snapshot" VALUES(446,'2026-07-13 18:57','2026-07-13','510300','沪深300ETF华泰柏瑞',4.744,-1.76,7705111563.0,16190530.0,-1927022048.0,-25.01,81393697898.0,81393697898.0);
INSERT INTO "etf_snapshot" VALUES(447,'2026-07-13 18:57','2026-07-13','510310','沪深300ETF易方达',4.601,-1.83,1492105869.0,3233206.0,-346841365.0,-23.25,42223579297.0,42223579297.0);
INSERT INTO "etf_snapshot" VALUES(448,'2026-07-13 18:57','2026-07-13','510320','沪深300ETF中金',1.278,-1.39,38515675.0,300712.0,-5914508.0,-15.36,768165538.0,768165538.0);
INSERT INTO "etf_snapshot" VALUES(449,'2026-07-13 18:57','2026-07-13','510330','沪深300ETF华夏',4.94,-2.0,1018619624.0,2053857.0,-150712087.0,-14.8,37436553656.0,37436553656.0);
INSERT INTO "etf_snapshot" VALUES(450,'2026-07-13 18:57','2026-07-13','510350','沪深300ETF工银',4.974,-1.68,39378211.0,78877.0,-192264.0,-0.49,3340114138.0,3340114138.0);
INSERT INTO "etf_snapshot" VALUES(451,'2026-07-13 18:57','2026-07-13','510360','沪深300ETF广发',1.805,-1.96,102203687.0,563519.0,-22026404.0,-21.55,2830928066.0,2830928066.0);
INSERT INTO "etf_snapshot" VALUES(452,'2026-07-13 18:57','2026-07-13','510370','沪深300ETF兴业',1.052,-1.77,6447867.0,60883.0,-339571.0,-5.27,88639521.0,88639521.0);
INSERT INTO "etf_snapshot" VALUES(453,'2026-07-13 18:57','2026-07-13','510380','沪深300ETF国寿',1.399,-2.1,3425606.0,24306.0,-436652.0,-12.75,1751271558.0,1751271558.0);
INSERT INTO "etf_snapshot" VALUES(454,'2026-07-13 18:57','2026-07-13','510390','沪深300ETF平安',5.346,-1.78,42548112.0,79598.0,-28344413.0,-66.62,638579700.0,638579700.0);
INSERT INTO "etf_snapshot" VALUES(455,'2026-07-13 18:57','2026-07-13','510500','中证500ETF南方',8.292,-4.67,7517070059.0,8964812.0,-1107343616.0,-14.73,37617226632.0,37617226632.0);
INSERT INTO "etf_snapshot" VALUES(456,'2026-07-13 18:57','2026-07-13','510510','中证500ETF广发',2.627,-4.4,116552780.0,438073.0,-13011911.0,-11.16,2109581625.0,2109581625.0);
INSERT INTO "etf_snapshot" VALUES(457,'2026-07-13 18:57','2026-07-13','510530','中证500ETF工银',9.107,-3.8,21068344.0,22945.0,-3706975.0,-17.6,414180896.0,414180896.0);
INSERT INTO "etf_snapshot" VALUES(458,'2026-07-13 18:57','2026-07-13','510550','中证500ETF方正富邦',2.08,-6.31,2455646.0,11639.0,-968773.0,-39.45,41066064.0,41066064.0);
INSERT INTO "etf_snapshot" VALUES(459,'2026-07-13 18:57','2026-07-13','510560','中证500ETF国寿',2.011,-4.65,2387096.0,11616.0,-476466.0,-19.96,121300906.0,121300906.0);
INSERT INTO "etf_snapshot" VALUES(460,'2026-07-13 18:57','2026-07-13','510570','中证500ETF兴业',1.285,-4.46,4269680.0,32608.0,-947054.0,-22.18,39270371.0,39270371.0);
INSERT INTO "etf_snapshot" VALUES(461,'2026-07-13 18:57','2026-07-13','510580','中证500ETF易方达',4.275,-4.26,339256871.0,780916.0,-21704286.0,-6.4,4055129500.0,4055129500.0);
INSERT INTO "etf_snapshot" VALUES(462,'2026-07-13 18:57','2026-07-13','510590','中证500ETF平安',8.754,-4.94,62274549.0,70590.0,4731685.0,7.6,1211431919.0,1211431919.0);
INSERT INTO "etf_snapshot" VALUES(463,'2026-07-13 18:57','2026-07-13','510600','上证50ETF申万菱信',3.868,-1.28,5240702.0,13517.0,-502960.0,-9.6,48021607.0,48021607.0);
INSERT INTO "etf_snapshot" VALUES(464,'2026-07-13 18:57','2026-07-13','510680','上证50ETF万家',3.187,-1.39,14990197.0,46913.0,-2525193.0,-16.85,58719519.0,58719519.0);
INSERT INTO "etf_snapshot" VALUES(465,'2026-07-13 18:57','2026-07-13','510710','上证50ETF博时',4.279,-1.52,4170211.0,9714.0,607085.0,14.56,439962073.0,439962073.0);
INSERT INTO "etf_snapshot" VALUES(466,'2026-07-13 18:57','2026-07-13','510800','上证50ETF建信',1.392,-1.56,4698476.0,33617.0,-370879.0,-7.89,249969792.0,249969792.0);
INSERT INTO "etf_snapshot" VALUES(467,'2026-07-13 18:57','2026-07-13','510850','上证50ETF工银',3.554,-1.22,14216126.0,39837.0,1614437.0,11.36,176629891.0,176629891.0);
INSERT INTO "etf_snapshot" VALUES(468,'2026-07-13 18:57','2026-07-13','510950','上证50ETF广发',0.988,-1.3,18464492.0,186957.0,-3416084.0,-18.5,106032950.0,106032950.0);
INSERT INTO "etf_snapshot" VALUES(469,'2026-07-13 18:57','2026-07-13','512020','A500ETF鹏华',1.315,-2.59,79629280.0,598684.0,-2929954.0,-3.68,1300551706.0,1300551706.0);
INSERT INTO "etf_snapshot" VALUES(470,'2026-07-13 18:57','2026-07-13','512050','A500ETF华夏',1.241,-2.74,2540673485.0,20257868.0,-89227152.0,-3.51,17042643390.0,17042643390.0);
INSERT INTO "etf_snapshot" VALUES(471,'2026-07-13 18:57','2026-07-13','512080','A500ETF中金',1.338,-2.26,26337460.0,195228.0,-230668.0,-0.88,797696996.0,797696996.0);
INSERT INTO "etf_snapshot" VALUES(472,'2026-07-13 18:57','2026-07-13','512100','中证1000ETF南方',3.158,-4.65,7324695009.0,22877471.0,-444410752.0,-6.07,16608609383.0,16608609383.0);
INSERT INTO "etf_snapshot" VALUES(473,'2026-07-13 18:57','2026-07-13','512370','A500增强ETF华夏',1.188,-2.3,4538978.0,38005.0,-2052529.0,-45.22,373403854.0,373403854.0);
INSERT INTO "etf_snapshot" VALUES(474,'2026-07-13 18:57','2026-07-13','512500','中证500ETF华夏',4.609,-4.38,956142033.0,2053205.0,-94019362.0,-9.83,7599359759.0,7599359759.0);
INSERT INTO "etf_snapshot" VALUES(475,'2026-07-13 18:57','2026-07-13','512510','中证500ETF华泰柏瑞',2.425,-4.15,31593102.0,128511.0,-4821052.0,-15.26,956492284.0,956492284.0);
INSERT INTO "etf_snapshot" VALUES(476,'2026-07-13 18:57','2026-07-13','515130','沪深300ETF博时',1.565,-1.82,47750681.0,304392.0,-3636498.0,-7.62,124359908.0,124359908.0);
INSERT INTO "etf_snapshot" VALUES(477,'2026-07-13 18:57','2026-07-13','515310','沪深300ETF汇添富',1.413,-1.81,58487001.0,413332.0,-11699063.0,-20.0,345635626.0,345635626.0);
INSERT INTO "etf_snapshot" VALUES(478,'2026-07-13 18:57','2026-07-13','515330','沪深300ETF天弘',1.362,-1.8,34277024.0,250096.0,-5206535.0,-15.19,7362576432.0,7362576432.0);
INSERT INTO "etf_snapshot" VALUES(479,'2026-07-13 18:57','2026-07-13','515350','沪深300ETF民生加银',6.35,-1.78,8184676.0,12830.0,305955.0,3.74,74289920.0,74289920.0);
INSERT INTO "etf_snapshot" VALUES(480,'2026-07-13 18:57','2026-07-13','515360','沪深300ETF方正富邦',6.802,-1.92,1860573.0,2716.0,324995.0,17.47,256974799.0,256974799.0);
INSERT INTO "etf_snapshot" VALUES(481,'2026-07-13 18:57','2026-07-13','515380','沪深300ETF泰康',5.497,-1.47,45504193.0,82642.0,-1005630.0,-2.21,3527973545.0,3527973545.0);
INSERT INTO "etf_snapshot" VALUES(482,'2026-07-13 18:57','2026-07-13','515390','沪深300ETF华安',1.378,-1.92,524083085.0,3791586.0,-2427335.0,-0.46,1563593185.0,1563593185.0);
INSERT INTO "etf_snapshot" VALUES(483,'2026-07-13 18:57','2026-07-13','515530','中证500ETF泰康',4.485,-4.13,7143079.0,15689.0,-1324002.0,-18.54,54908510.0,54908510.0);
INSERT INTO "etf_snapshot" VALUES(484,'2026-07-13 18:57','2026-07-13','515550','中证500ETF国联',1.841,-3.76,1200960.0,6418.0,122097.0,10.17,31933434.0,31933434.0);
INSERT INTO "etf_snapshot" VALUES(485,'2026-07-13 18:57','2026-07-13','515660','沪深300ETF国联安',5.892,-1.91,6793787.0,11476.0,-1210527.0,-17.82,2528223074.0,2528223074.0);
INSERT INTO "etf_snapshot" VALUES(486,'2026-07-13 18:57','2026-07-13','516300','中证1000ETF华泰柏瑞',3.253,-4.86,23081199.0,70262.0,-4952090.0,-21.46,87871988.0,87871988.0);
INSERT INTO "etf_snapshot" VALUES(487,'2026-07-13 18:57','2026-07-13','516830','沪深300ESGETF富国',1.061,-1.58,8870014.0,83379.0,628091.0,7.08,92494691.0,92494691.0);
INSERT INTO "etf_snapshot" VALUES(488,'2026-07-13 18:57','2026-07-13','530000','上证50ETF天弘',1.372,-1.51,5552652.0,40389.0,-374021.0,-6.74,1299324348.0,1299324348.0);
INSERT INTO "etf_snapshot" VALUES(489,'2026-07-13 18:57','2026-07-13','530050','上证50ETF东财',1.179,-1.09,7984025.0,67717.0,-1192917.0,-14.94,153049527.0,153049527.0);
INSERT INTO "etf_snapshot" VALUES(490,'2026-07-13 18:57','2026-07-13','560010','中证1000ETF广发',3.227,-5.09,1215655793.0,3682476.0,-42800400.0,-3.52,5229746213.0,5229746213.0);
INSERT INTO "etf_snapshot" VALUES(491,'2026-07-13 18:57','2026-07-13','560100','中证500增强ETF南方',1.367,-4.07,26403889.0,189552.0,160859.0,0.61,83496770.0,83496770.0);
INSERT INTO "etf_snapshot" VALUES(492,'2026-07-13 18:57','2026-07-13','560110','中证1000ETF汇添富',1.165,-5.13,72170438.0,608648.0,-10838828.0,-15.02,264342578.0,264342578.0);
INSERT INTO "etf_snapshot" VALUES(493,'2026-07-13 18:57','2026-07-13','560180','沪深300ESGETF南方',1.204,-2.11,9214453.0,75970.0,-466460.0,-5.06,18786012.0,18786012.0);
INSERT INTO "etf_snapshot" VALUES(494,'2026-07-13 18:57','2026-07-13','560330','沪深300价值ETF申万菱信',1.18,0.85,4744690.0,40387.0,-1076951.0,-22.7,20213400.0,20213400.0);
INSERT INTO "etf_snapshot" VALUES(495,'2026-07-13 18:57','2026-07-13','560510','中证A500ETF泰康',1.223,-2.55,91575329.0,742029.0,-12969469.0,-14.16,3036741894.0,3036741894.0);
INSERT INTO "etf_snapshot" VALUES(496,'2026-07-13 18:57','2026-07-13','560530','中证A500ETF摩根',1.258,-2.63,106927815.0,841859.0,-7862924.0,-7.35,2885378610.0,2885378610.0);
INSERT INTO "etf_snapshot" VALUES(497,'2026-07-13 18:57','2026-07-13','560590','中证1000增强ETF鹏华',1.474,-4.53,5123417.0,34416.0,-425706.0,-8.31,20208540.0,20208540.0);
INSERT INTO "etf_snapshot" VALUES(498,'2026-07-13 18:57','2026-07-13','560610','A500ETF招商',1.226,-2.62,132890703.0,1077127.0,-12454314.0,-9.37,5670235798.0,5670235798.0);
INSERT INTO "etf_snapshot" VALUES(499,'2026-07-13 18:57','2026-07-13','560750','A500ETF申万菱信',1.369,-2.42,19517360.0,141634.0,-162898.0,-0.83,95220521.0,95220521.0);
INSERT INTO "etf_snapshot" VALUES(500,'2026-07-13 18:57','2026-07-13','560950','中证500增强ETF汇添富',1.391,-3.67,1428980.0,10099.0,-357937.0,-25.05,18754853.0,18754853.0);
INSERT INTO "etf_snapshot" VALUES(501,'2026-07-13 18:57','2026-07-13','561000','沪深300增强ETF华安',1.317,-1.13,6487042.0,48962.0,-1705376.0,-26.29,62452140.0,62452140.0);
INSERT INTO "etf_snapshot" VALUES(502,'2026-07-13 18:57','2026-07-13','561090','A500增强ETF华安',1.263,-3.22,20183909.0,157778.0,-4708317.0,-23.33,261408162.0,261408162.0);
INSERT INTO "etf_snapshot" VALUES(503,'2026-07-13 18:57','2026-07-13','561280','中证1000增强ETF工银',1.6,-5.33,11331512.0,69325.0,-1837705.0,-16.22,116556320.0,116556320.0);
INSERT INTO "etf_snapshot" VALUES(504,'2026-07-13 18:57','2026-07-13','561300','沪深300增强ETF国泰',1.021,-2.48,49438163.0,479421.0,-5146203.0,-10.41,381818273.0,381818273.0);
INSERT INTO "etf_snapshot" VALUES(505,'2026-07-13 18:57','2026-07-13','561350','中证500ETF国泰',1.291,-4.37,30845218.0,234912.0,-1823351.0,-5.91,79654700.0,79654700.0);
INSERT INTO "etf_snapshot" VALUES(506,'2026-07-13 18:57','2026-07-13','561550','中证500增强ETF华泰柏瑞',1.45,-4.86,105091961.0,718692.0,-7193544.0,-6.85,1411559920.0,1411559920.0);
INSERT INTO "etf_snapshot" VALUES(507,'2026-07-13 18:57','2026-07-13','561590','中证1000增强ETF华泰柏瑞',1.531,-3.53,10442275.0,67419.0,-802896.0,-7.69,117120888.0,117120888.0);
INSERT INTO "etf_snapshot" VALUES(508,'2026-07-13 18:57','2026-07-13','561900','沪深300ESGETF招商',1.003,-1.47,6078792.0,60146.0,-546971.0,-9.0,23404403.0,23404403.0);
INSERT INTO "etf_snapshot" VALUES(509,'2026-07-13 18:57','2026-07-13','561930','沪深300ETF招商',1.588,-1.67,79573039.0,501298.0,-17171274.0,-21.58,254493833.0,254493833.0);
INSERT INTO "etf_snapshot" VALUES(510,'2026-07-13 18:57','2026-07-13','561950','中证500增强ETF招商',1.392,-3.67,6857455.0,48898.0,69325.0,1.01,102529152.0,102529152.0);
INSERT INTO "etf_snapshot" VALUES(511,'2026-07-13 18:57','2026-07-13','561990','沪深300增强ETF招商',0.994,-2.26,42540998.0,425280.0,-2420440.0,-5.69,332641305.0,332641305.0);
INSERT INTO "etf_snapshot" VALUES(512,'2026-07-13 18:57','2026-07-13','562070','沪深300指增ETF华宝',1.039,-1.33,11494921.0,109938.0,55714.0,0.48,458762138.0,458762138.0);
INSERT INTO "etf_snapshot" VALUES(513,'2026-07-13 18:57','2026-07-13','562310','沪深300成长ETF银华',1.112,-2.54,38302692.0,339757.0,-4735538.0,-12.36,547740402.0,547740402.0);
INSERT INTO "etf_snapshot" VALUES(514,'2026-07-13 18:57','2026-07-13','562320','沪深300价值ETF银华',1.271,0.39,15511815.0,122247.0,-66792.0,-0.43,74093581.0,74093581.0);
INSERT INTO "etf_snapshot" VALUES(515,'2026-07-13 18:57','2026-07-13','562330','中证500价值ETF银华',1.181,-1.25,290202.0,2449.0,-52741.0,-18.17,11832321.0,11832321.0);
INSERT INTO "etf_snapshot" VALUES(516,'2026-07-13 18:57','2026-07-13','562340','中证500成长ETF银华',1.418,-2.94,2797529.0,19457.0,-154889.0,-5.54,11548617.0,11548617.0);
INSERT INTO "etf_snapshot" VALUES(517,'2026-07-13 18:57','2026-07-13','562520','中证1000成长ETF华夏',1.378,-4.44,9015890.0,64234.0,-396366.0,-4.4,28342704.0,28342704.0);
INSERT INTO "etf_snapshot" VALUES(518,'2026-07-13 18:57','2026-07-13','562530','中证1000价值ETF华夏',1.18,-0.92,4943790.0,41695.0,-25303.0,-0.51,47369920.0,47369920.0);
INSERT INTO "etf_snapshot" VALUES(519,'2026-07-13 18:57','2026-07-13','563030','中证500增强ETF易方达',1.617,-3.98,11371994.0,69898.0,-2430198.0,-21.37,161973273.0,161973273.0);
INSERT INTO "etf_snapshot" VALUES(520,'2026-07-13 18:57','2026-07-13','563090','上证50增强ETF易方达',1.363,-2.29,12752393.0,93104.0,423452.0,3.32,76120824.0,76120824.0);
INSERT INTO "etf_snapshot" VALUES(521,'2026-07-13 18:57','2026-07-13','563220','A500ETF富国',1.298,-2.7,506597933.0,3874765.0,-16094906.0,-3.18,7074117777.0,7074117777.0);
INSERT INTO "etf_snapshot" VALUES(522,'2026-07-13 18:57','2026-07-13','563360','A500ETF华泰柏瑞',1.318,-2.66,4277554390.0,32176056.0,-146131424.0,-3.42,30851727467.0,30851727467.0);
INSERT INTO "etf_snapshot" VALUES(523,'2026-07-13 18:57','2026-07-13','563500','A500ETF华宝',0.655,-2.67,36109793.0,545012.0,-1429431.0,-3.96,446682951.0,446682951.0);
INSERT INTO "etf_snapshot" VALUES(524,'2026-07-13 18:57','2026-07-13','563520','沪深300ETF永赢',1.215,-1.78,33055059.0,271086.0,866414.0,2.62,456918985.0,456918985.0);
INSERT INTO "etf_snapshot" VALUES(525,'2026-07-13 18:57','2026-07-13','563550','A500增强ETF摩根',1.287,-3.16,26247392.0,202354.0,-2390890.0,-9.11,102392433.0,102392433.0);
INSERT INTO "etf_snapshot" VALUES(526,'2026-07-13 18:57','2026-07-13','563600','A500增强ETF易方达',1.068,-3.0,10589618.0,98251.0,-1352979.0,-12.78,51779844.0,51779844.0);
INSERT INTO "etf_snapshot" VALUES(527,'2026-07-13 18:57','2026-07-13','563630','A500增强ETF国联安',1.301,-2.62,1475848.0,11223.0,-150175.0,-10.18,51971177.0,51971177.0);
INSERT INTO "etf_snapshot" VALUES(528,'2026-07-13 18:57','2026-07-13','563650','中证A500ETF兴业',1.319,-2.3,13244654.0,100043.0,-697441.0,-5.27,170030971.0,170030971.0);
INSERT INTO "etf_snapshot" VALUES(529,'2026-07-13 18:57','2026-07-13','563660','A500ETF银河',1.284,-2.65,2472888.0,19199.0,-195088.0,-7.89,77149397.0,77149397.0);
INSERT INTO "etf_snapshot" VALUES(530,'2026-07-13 18:57','2026-07-13','563750','中证500ETF汇添富',1.137,-4.05,31131905.0,268596.0,-5749766.0,-18.47,397650978.0,397650978.0);
INSERT INTO "etf_snapshot" VALUES(531,'2026-07-13 18:57','2026-07-13','563800','A500ETF广发',1.244,-2.74,609363054.0,4851986.0,-32103731.0,-5.27,9145860612.0,9145860612.0);
INSERT INTO "etf_snapshot" VALUES(532,'2026-07-13 18:57','2026-07-13','563860','中证A500ETF海富通',1.32,-2.94,31967558.0,238612.0,-1718774.0,-5.38,217594476.0,217594476.0);
INSERT INTO "etf_snapshot" VALUES(533,'2026-07-13 18:57','2026-07-13','563880','A500ETF汇添富',1.288,-2.5,120588198.0,925611.0,-4715544.0,-3.91,1405203363.0,1405203363.0);
INSERT INTO "etf_snapshot" VALUES(534,'2026-07-13 18:57','2026-07-13','512890','红利低波ETF华泰柏瑞',1.126,1.17,1007280128.0,8977096.0,-218077401.0,-21.65,33763234743.0,33763234743.0);
INSERT INTO "etf_snapshot" VALUES(535,'2026-07-13 18:57','2026-07-13','159012','科创创业50ETF鹏华',1.043,-2.98,11208991.263,105488.0,-1238922.0,-11.05,84359037.0,84359037.0);
INSERT INTO "etf_snapshot" VALUES(536,'2026-07-13 18:57','2026-07-13','159107','创业板软件ETF富国',0.761,-4.04,34403354.37,443024.0,-4618990.0,-13.43,483100309.0,483100309.0);
INSERT INTO "etf_snapshot" VALUES(537,'2026-07-13 18:57','2026-07-13','159205','创业板ETF东财',1.83,-3.07,148932400.9,805184.0,-41802412.0,-28.07,711972597.0,711972597.0);
INSERT INTO "etf_snapshot" VALUES(538,'2026-07-13 18:57','2026-07-13','159247','创业板ETF汇添富',1.121,-3.61,60898305.305,537807.0,-17277386.0,-28.37,289201147.0,289201147.0);
INSERT INTO "etf_snapshot" VALUES(539,'2026-07-13 18:57','2026-07-13','159256','创业板软件ETF华夏',0.838,-4.12,77269075.1,909611.0,-3634078.0,-4.7,365521991.0,365521991.0);
INSERT INTO "etf_snapshot" VALUES(540,'2026-07-13 18:57','2026-07-13','159270','创业板200ETF南方',1.155,-6.4,14920733.1,126152.0,-513128.0,-3.44,95592015.0,95592015.0);
INSERT INTO "etf_snapshot" VALUES(541,'2026-07-13 18:57','2026-07-13','159287','创业板综ETF博时',1.183,-2.55,5949882.376,50090.0,-393414.0,-6.61,110691835.0,110691835.0);
INSERT INTO "etf_snapshot" VALUES(542,'2026-07-13 18:57','2026-07-13','159288','创业板综ETF银华',1.042,-4.05,967625.09,9203.0,-216216.0,-22.35,87710278.0,87710278.0);
INSERT INTO "etf_snapshot" VALUES(543,'2026-07-13 18:57','2026-07-13','159289','创业板综指ETF鹏华',1.132,-4.15,4062918.801,35331.0,1099603.0,27.06,32717788.0,32717788.0);
INSERT INTO "etf_snapshot" VALUES(544,'2026-07-13 18:57','2026-07-13','159290','创业板综指增强ETF东财',1.216,-4.1,5807003.6,47005.0,157708.0,2.72,47546082.0,47546082.0);
INSERT INTO "etf_snapshot" VALUES(545,'2026-07-13 18:57','2026-07-13','159291','创业板综增强ETF招商',1.221,-4.61,2823961.6,22719.0,-323813.0,-11.47,23757471.0,23757471.0);
INSERT INTO "etf_snapshot" VALUES(546,'2026-07-13 18:57','2026-07-13','159292','创业板综增强ETF华宝',1.188,-4.12,5615200.4,46691.0,287905.0,5.13,222381163.0,222381163.0);
INSERT INTO "etf_snapshot" VALUES(547,'2026-07-13 18:57','2026-07-13','159293','创业板综增强ETF建信',1.097,-4.36,6896006.318,61822.0,307529.0,4.46,23211859.0,23211859.0);
INSERT INTO "etf_snapshot" VALUES(548,'2026-07-13 18:57','2026-07-13','159298','创业板50ETF大成',1.318,-2.8,14616433.7,109661.0,-1948881.0,-13.33,186208466.0,186208466.0);
INSERT INTO "etf_snapshot" VALUES(549,'2026-07-13 18:57','2026-07-13','159335','央企科创ETF融通',1.526,-5.57,2594707.2,16702.0,-364006.0,-14.03,89856509.0,89856509.0);
INSERT INTO "etf_snapshot" VALUES(550,'2026-07-13 18:57','2026-07-13','159367','创业板50ETF华夏',1.861,-3.53,21977831.1,116488.0,-263776.0,-1.2,230911073.0,230911073.0);
INSERT INTO "etf_snapshot" VALUES(551,'2026-07-13 18:57','2026-07-13','159369','创业板50ETF易方达',1.52,-3.25,19138579.1,124366.0,-4933069.0,-25.78,466265302.0,466265302.0);
INSERT INTO "etf_snapshot" VALUES(552,'2026-07-13 18:57','2026-07-13','159371','创业板50ETF富国',1.859,-3.63,9485828.3,50436.0,-2171048.0,-22.89,312723159.0,312723159.0);
INSERT INTO "etf_snapshot" VALUES(553,'2026-07-13 18:57','2026-07-13','159372','创业板50ETF万家',1.985,-4.57,4157495.7,20642.0,-1526781.0,-36.72,110071402.0,110071402.0);
INSERT INTO "etf_snapshot" VALUES(554,'2026-07-13 18:57','2026-07-13','159373','创业板50ETF嘉实',1.905,-2.76,70902694.4,366681.0,-1817580.0,-2.56,258237026.0,258237026.0);
INSERT INTO "etf_snapshot" VALUES(555,'2026-07-13 18:57','2026-07-13','159375','创业板50ETF国泰',0.795,-2.93,16578527.5,205376.0,-843450.0,-5.09,230228298.0,230228298.0);
INSERT INTO "etf_snapshot" VALUES(556,'2026-07-13 18:57','2026-07-13','159383','创业板50ETF华泰柏瑞',1.85,-3.14,8202236.4,43805.0,-2403440.0,-29.3,66771099.0,66771099.0);
INSERT INTO "etf_snapshot" VALUES(557,'2026-07-13 18:57','2026-07-13','159541','创业板综ETF万家',1.583,-4.52,12001438.7,74978.0,2174678.0,18.12,95127735.0,95127735.0);
INSERT INTO "etf_snapshot" VALUES(558,'2026-07-13 18:57','2026-07-13','159563','创业板综ETF华夏',1.944,-1.27,6735343.6,35643.0,-2538087.0,-37.68,45413343.0,45413343.0);
INSERT INTO "etf_snapshot" VALUES(559,'2026-07-13 18:57','2026-07-13','159571','创业板200ETF富国',1.482,-6.2,794638.8,5252.0,-53498.0,-6.73,26649048.0,26649048.0);
INSERT INTO "etf_snapshot" VALUES(560,'2026-07-13 18:57','2026-07-13','159572','创业板200ETF易方达',1.49,-5.64,22544474.2,149047.0,-1848899.0,-8.2,252926169.0,252926169.0);
INSERT INTO "etf_snapshot" VALUES(561,'2026-07-13 18:57','2026-07-13','159573','创业板200ETF华夏',1.495,-5.97,25556603.8,167709.0,-1518791.0,-5.94,106827164.0,106827164.0);
INSERT INTO "etf_snapshot" VALUES(562,'2026-07-13 18:57','2026-07-13','159575','创业板200ETF银华',1.453,-6.08,3549514.1,24388.0,-190298.0,-5.36,13673348.0,13673348.0);
INSERT INTO "etf_snapshot" VALUES(563,'2026-07-13 18:57','2026-07-13','159597','创业板成长ETF易方达',0.871,-4.7,29570441.9,333001.0,-2448058.0,-8.28,719234465.0,719234465.0);
INSERT INTO "etf_snapshot" VALUES(564,'2026-07-13 18:57','2026-07-13','159603','科创创业ETF天弘',1.955,-4.73,20008362.1,100151.0,-6852841.0,-34.25,4707780604.0,4707780604.0);
INSERT INTO "etf_snapshot" VALUES(565,'2026-07-13 18:57','2026-07-13','159675','创业板增强ETF嘉实',1.534,-3.52,10518646.7,67572.0,-463135.0,-4.4,79532824.0,79532824.0);
INSERT INTO "etf_snapshot" VALUES(566,'2026-07-13 18:57','2026-07-13','159676','创业板增强ETF富国',1.681,-4.22,28377837.886,167379.0,-6699036.0,-23.61,172410392.0,172410392.0);
INSERT INTO "etf_snapshot" VALUES(567,'2026-07-13 18:57','2026-07-13','159681','创业板50ETF鹏华',1.745,-3.16,155797127.5,878027.0,-25486799.0,-16.36,1737622726.0,1737622726.0);
INSERT INTO "etf_snapshot" VALUES(568,'2026-07-13 18:57','2026-07-13','159682','创业板50ETF景顺',1.726,-3.03,347635832.8,1988296.0,-39275227.0,-11.3,4874755028.0,4874755028.0);
INSERT INTO "etf_snapshot" VALUES(569,'2026-07-13 18:57','2026-07-13','159773','创业板科技ETF华泰柏瑞',1.368,-3.8,6863906.3,49530.0,3455.0,0.05,195217868.0,195217868.0);
INSERT INTO "etf_snapshot" VALUES(570,'2026-07-13 18:57','2026-07-13','159780','科创创业50ETF南方',1.262,-2.77,206403601.402,1606102.0,-9009628.0,-4.37,4311053303.0,4311053303.0);
INSERT INTO "etf_snapshot" VALUES(571,'2026-07-13 18:57','2026-07-13','159781','科创创业ETF易方达',1.266,-3.8,696714887.039,5415622.0,51134862.0,7.34,15927369287.0,15927369287.0);
INSERT INTO "etf_snapshot" VALUES(572,'2026-07-13 18:57','2026-07-13','159782','双创50ETF银华',1.267,-3.87,51470156.871,399872.0,-6500237.0,-12.63,711028075.0,711028075.0);
INSERT INTO "etf_snapshot" VALUES(573,'2026-07-13 18:57','2026-07-13','159783','科创创业50ETF华夏',1.269,-4.59,298275877.03,2305417.0,-36584503.0,-12.27,5694332168.0,5694332168.0);
INSERT INTO "etf_snapshot" VALUES(574,'2026-07-13 18:57','2026-07-13','159810','创业板ETF浦银',1.493,-3.74,4850466.0,31901.0,-424977.0,-8.76,72373859.0,72373859.0);
INSERT INTO "etf_snapshot" VALUES(575,'2026-07-13 18:57','2026-07-13','159836','创业板300ETF天弘',1.353,-4.11,5472001.5,40107.0,-212110.0,-3.88,134957844.0,134957844.0);
INSERT INTO "etf_snapshot" VALUES(576,'2026-07-13 18:57','2026-07-13','159908','创业板ETF博时',3.48,-3.44,36034201.7,102507.0,1250162.0,3.47,1114397004.0,1114397004.0);
INSERT INTO "etf_snapshot" VALUES(577,'2026-07-13 18:57','2026-07-13','159915','创业板ETF易方达',3.751,-2.87,7214651859.377,19042355.0,-1080751776.0,-14.98,44267257135.0,44267257135.0);
INSERT INTO "etf_snapshot" VALUES(578,'2026-07-13 18:57','2026-07-13','159948','创业板ETF南方',4.134,-3.07,173465967.824,413447.0,-8413164.0,-4.85,4422130408.0,4422130408.0);
INSERT INTO "etf_snapshot" VALUES(579,'2026-07-13 18:57','2026-07-13','159949','创业板50ETF华安',1.773,-2.9,2600135551.085,14472834.0,107064480.0,4.12,20603652074.0,20603652074.0);
INSERT INTO "etf_snapshot" VALUES(580,'2026-07-13 18:57','2026-07-13','159952','创业板ETF广发',2.267,-3.28,594493036.222,2584123.0,-70651113.0,-11.88,8816555532.0,8816555532.0);
INSERT INTO "etf_snapshot" VALUES(581,'2026-07-13 18:57','2026-07-13','159956','创业板ETF建信',2.366,-3.27,10999989.1,45966.0,-222800.0,-2.03,99321543.0,99321543.0);
INSERT INTO "etf_snapshot" VALUES(582,'2026-07-13 18:57','2026-07-13','159957','创业板ETF华夏',2.459,-3.11,255585713.4,1028466.0,-35708629.0,-13.97,2096997233.0,2096997233.0);
INSERT INTO "etf_snapshot" VALUES(583,'2026-07-13 18:57','2026-07-13','159958','创业板ETF工银',2.258,-3.3,15524111.2,67915.0,1343885.0,8.66,492721450.0,492721450.0);
INSERT INTO "etf_snapshot" VALUES(584,'2026-07-13 18:57','2026-07-13','159964','创业板ETF平安',2.436,-3.49,9980052.5,40351.0,-597014.0,-5.98,471321862.0,471321862.0);
INSERT INTO "etf_snapshot" VALUES(585,'2026-07-13 18:57','2026-07-13','159966','创业板价值ETF华夏',0.556,-2.8,10335401.81,184091.0,-1147172.0,-11.1,329429733.0,329429733.0);
INSERT INTO "etf_snapshot" VALUES(586,'2026-07-13 18:57','2026-07-13','159967','创业板成长ETF华夏',0.882,-4.34,1173170648.99,13011137.0,-81399712.0,-6.94,4963107309.0,4963107309.0);
INSERT INTO "etf_snapshot" VALUES(587,'2026-07-13 18:57','2026-07-13','159971','创业板ETF富国',1.311,-2.53,130108393.5,987579.0,-19021273.0,-14.62,1782986598.0,1782986598.0);
INSERT INTO "etf_snapshot" VALUES(588,'2026-07-13 18:57','2026-07-13','159977','创业板ETF天弘',1.943,-3.04,313829502.904,1590386.0,-11419827.0,-3.64,5964762881.0,5964762881.0);
INSERT INTO "etf_snapshot" VALUES(589,'2026-07-13 18:57','2026-07-13','159991','创业板大盘ETF招商',0.882,-4.23,11524575.8,128935.0,-783501.0,-6.8,85609718.0,85609718.0);
INSERT INTO "etf_snapshot" VALUES(590,'2026-07-13 18:57','2026-07-13','588000','科创50ETF华夏',2.1,-4.93,9118631347.0,42418236.0,-1519325264.0,-16.66,66640703002.0,66640703002.0);
INSERT INTO "etf_snapshot" VALUES(591,'2026-07-13 18:57','2026-07-13','588010','科创新材料ETF博时',1.228,-6.47,256099931.0,2015227.0,-4982941.0,-1.95,1182472892.0,1182472892.0);
INSERT INTO "etf_snapshot" VALUES(592,'2026-07-13 18:57','2026-07-13','588020','科创成长ETF易方达',0.983,-5.93,356983060.0,3525989.0,-7827387.0,-2.19,1485679667.0,1485679667.0);
INSERT INTO "etf_snapshot" VALUES(593,'2026-07-13 18:57','2026-07-13','588030','科创100ETF博时',1.953,-5.92,353548601.0,1755881.0,4772025.0,1.35,4657588801.0,4657588801.0);
INSERT INTO "etf_snapshot" VALUES(594,'2026-07-13 18:57','2026-07-13','588040','科创50ETF鹏华',2.037,-3.6,62123579.0,298213.0,-17127101.0,-27.57,179029893.0,179029893.0);
INSERT INTO "etf_snapshot" VALUES(595,'2026-07-13 18:57','2026-07-13','588050','科创50ETF工银',2.044,-4.13,550485145.0,2624406.0,-72586793.0,-13.19,10287945307.0,10287945307.0);
INSERT INTO "etf_snapshot" VALUES(596,'2026-07-13 18:57','2026-07-13','588060','科创50ETF广发',1.267,-4.67,717280975.0,5547088.0,-120572242.0,-16.81,6782428339.0,6782428339.0);
INSERT INTO "etf_snapshot" VALUES(597,'2026-07-13 18:57','2026-07-13','588070','科创成长ETF万家',2.519,-6.46,8427934.0,32682.0,243818.0,2.89,66594803.0,66594803.0);
INSERT INTO "etf_snapshot" VALUES(598,'2026-07-13 18:57','2026-07-13','588080','科创50ETF易方达',2.036,-4.9,3070297020.0,14755260.0,-26755680.0,-0.87,41525498673.0,41525498673.0);
INSERT INTO "etf_snapshot" VALUES(599,'2026-07-13 18:57','2026-07-13','588090','科创50ETF华泰柏瑞',2.043,-4.67,268189618.0,1277861.0,-23430581.0,-8.74,5099476730.0,5099476730.0);
INSERT INTO "etf_snapshot" VALUES(600,'2026-07-13 18:57','2026-07-13','588100','科创信息ETF嘉实',3.157,-4.71,42525465.0,130404.0,-3133470.0,-7.37,212304146.0,212304146.0);
INSERT INTO "etf_snapshot" VALUES(601,'2026-07-13 18:57','2026-07-13','588110','科创成长ETF广发',2.871,-6.63,73267745.0,245792.0,8607925.0,11.75,495988218.0,495988218.0);
INSERT INTO "etf_snapshot" VALUES(602,'2026-07-13 18:57','2026-07-13','588120','科创100ETF国泰',0.983,-6.29,138884545.0,1362263.0,4119044.0,2.97,1104520426.0,1104520426.0);
INSERT INTO "etf_snapshot" VALUES(603,'2026-07-13 18:57','2026-07-13','588140','科创200ETF广发',1.331,-6.27,6406769.0,46877.0,462897.0,7.23,277847581.0,277847581.0);
INSERT INTO "etf_snapshot" VALUES(604,'2026-07-13 18:57','2026-07-13','588150','科创50ETF南方',1.409,-5.31,69605361.0,483525.0,-4225031.0,-6.07,412742045.0,412742045.0);
INSERT INTO "etf_snapshot" VALUES(605,'2026-07-13 18:57','2026-07-13','588160','科创新材料ETF南方',1.255,-6.62,247099327.0,1893716.0,-2989560.0,-1.21,786252480.0,786252480.0);
INSERT INTO "etf_snapshot" VALUES(606,'2026-07-13 18:57','2026-07-13','588180','科创50ETF国联安',1.289,-5.64,38733704.0,293272.0,-7024073.0,-18.13,838950414.0,838950414.0);
INSERT INTO "etf_snapshot" VALUES(607,'2026-07-13 18:57','2026-07-13','588190','科创100ETF银华',1.939,-5.55,174759392.0,872155.0,-1965514.0,-1.12,2870918891.0,2870918891.0);
INSERT INTO "etf_snapshot" VALUES(608,'2026-07-13 18:57','2026-07-13','588210','科创100ETF易方达',1.951,-5.75,19560580.0,97335.0,657001.0,3.36,338018554.0,338018554.0);
INSERT INTO "etf_snapshot" VALUES(609,'2026-07-13 18:57','2026-07-13','588220','科创100ETF鹏华',1.941,-6.19,891074529.0,4494973.0,13752922.0,1.54,6762828132.0,6762828132.0);
INSERT INTO "etf_snapshot" VALUES(610,'2026-07-13 18:57','2026-07-13','588230','科创200ETF华泰柏瑞',1.987,-5.83,126790360.0,620568.0,-23917850.0,-18.86,840379809.0,840379809.0);
INSERT INTO "etf_snapshot" VALUES(611,'2026-07-13 18:57','2026-07-13','588240','科创200ETF鹏华',1.835,-5.95,41232909.0,216764.0,-1718741.0,-4.17,180991555.0,180991555.0);
INSERT INTO "etf_snapshot" VALUES(612,'2026-07-13 18:57','2026-07-13','588260','科创信息ETF华安',3.061,-5.52,15091862.0,48258.0,-2706533.0,-17.93,143089506.0,143089506.0);
INSERT INTO "etf_snapshot" VALUES(613,'2026-07-13 18:57','2026-07-13','588270','科创200ETF易方达',1.86,-6.11,29569073.0,153691.0,-2311966.0,-7.82,482502600.0,482502600.0);
INSERT INTO "etf_snapshot" VALUES(614,'2026-07-13 18:57','2026-07-13','588280','科创50ETF华安',1.435,-5.03,54308661.0,368946.0,-7639560.0,-14.07,401973646.0,401973646.0);
INSERT INTO "etf_snapshot" VALUES(615,'2026-07-13 18:57','2026-07-13','588300','科创创业50ETF招商',1.302,-3.13,88003821.0,663918.0,-6835454.0,-7.77,1829584066.0,1829584066.0);
INSERT INTO "etf_snapshot" VALUES(616,'2026-07-13 18:57','2026-07-13','588310','科创创业ETF方正富邦',1.359,-3.21,5812961.0,41936.0,-917924.0,-15.79,41636363.0,41636363.0);
INSERT INTO "etf_snapshot" VALUES(617,'2026-07-13 18:57','2026-07-13','588320','双创50增强ETF广发',1.999,-3.71,15876353.0,78334.0,-507136.0,-3.19,113592375.0,113592375.0);
INSERT INTO "etf_snapshot" VALUES(618,'2026-07-13 18:57','2026-07-13','588330','双创50ETF华宝',1.285,-3.31,111370174.0,849528.0,-4851570.0,-4.36,1302653083.0,1302653083.0);
INSERT INTO "etf_snapshot" VALUES(619,'2026-07-13 18:57','2026-07-13','588350','科创创业50ETF鹏扬',1.956,-4.59,13459297.0,67070.0,-3372592.0,-25.06,1237259976.0,1237259976.0);
INSERT INTO "etf_snapshot" VALUES(620,'2026-07-13 18:57','2026-07-13','588360','科创创业ETF国泰',1.371,-3.38,35507712.0,253168.0,-415286.0,-1.17,288844748.0,288844748.0);
INSERT INTO "etf_snapshot" VALUES(621,'2026-07-13 18:57','2026-07-13','588370','科创50增强ETF南方',2.058,-6.5,17698485.0,83936.0,-1896400.0,-10.72,130213776.0,130213776.0);
INSERT INTO "etf_snapshot" VALUES(622,'2026-07-13 18:57','2026-07-13','588380','科创创业ETF富国',1.289,-3.3,216228274.0,1647482.0,-14436931.0,-6.68,3220914530.0,3220914530.0);
INSERT INTO "etf_snapshot" VALUES(623,'2026-07-13 18:57','2026-07-13','588390','科创创业ETF博时',1.378,-3.97,13652229.0,97762.0,-2212953.0,-16.21,194209670.0,194209670.0);
INSERT INTO "etf_snapshot" VALUES(624,'2026-07-13 18:57','2026-07-13','588400','科创创业ETF嘉实',1.278,-4.27,41119024.0,315568.0,-4519656.0,-10.99,1526699577.0,1526699577.0);
INSERT INTO "etf_snapshot" VALUES(625,'2026-07-13 18:57','2026-07-13','588450','科创50增强ETF招商',2.486,-4.13,24610343.0,97529.0,-3732480.0,-15.17,120741788.0,120741788.0);
INSERT INTO "etf_snapshot" VALUES(626,'2026-07-13 18:57','2026-07-13','588460','科创50增强ETF鹏华',2.429,-4.29,143367607.0,574820.0,-20107396.0,-14.03,1428286006.0,1428286006.0);
INSERT INTO "etf_snapshot" VALUES(627,'2026-07-13 18:57','2026-07-13','588500','科创100增强ETF易方达',2.83,-6.04,10609378.0,36496.0,-1627816.0,-15.34,89561010.0,89561010.0);
INSERT INTO "etf_snapshot" VALUES(628,'2026-07-13 18:57','2026-07-13','588520','科创增强ETF永赢',1.547,-4.62,756071.0,4836.0,2698.0,0.36,13856479.0,13856479.0);
INSERT INTO "etf_snapshot" VALUES(629,'2026-07-13 18:57','2026-07-13','588550','科创综指增强ETF易方达',1.567,-4.74,4184427.0,25993.0,-127636.0,-3.05,86639430.0,86639430.0);
INSERT INTO "etf_snapshot" VALUES(630,'2026-07-13 18:57','2026-07-13','588660','科创创业50ETF兴银',2.104,-2.91,8365868.0,39104.0,-1855546.0,-22.18,65947776.0,65947776.0);
INSERT INTO "etf_snapshot" VALUES(631,'2026-07-13 18:57','2026-07-13','588670','科创综指增强ETF嘉实',2.017,-4.54,9248793.0,44807.0,2374.0,0.03,76226464.0,76226464.0);
INSERT INTO "etf_snapshot" VALUES(632,'2026-07-13 18:57','2026-07-13','588680','科创100增强ETF广发',2.746,-5.18,5715508.0,20462.0,-1940279.0,-33.95,88863306.0,88863306.0);
INSERT INTO "etf_snapshot" VALUES(633,'2026-07-13 18:57','2026-07-13','588690','科创增强ETF银华',1.366,-4.48,2039288.0,14554.0,-196961.0,-9.66,65070776.0,65070776.0);
INSERT INTO "etf_snapshot" VALUES(634,'2026-07-13 18:57','2026-07-13','588720','科创50ETF中银',1.999,-3.85,22032936.0,106486.0,-3093438.0,-14.04,189388858.0,189388858.0);
INSERT INTO "etf_snapshot" VALUES(635,'2026-07-13 18:57','2026-07-13','588770','科创信息ETF摩根',2.24,-3.95,43349551.0,188534.0,3362371.0,7.76,758457513.0,758457513.0);
INSERT INTO "etf_snapshot" VALUES(636,'2026-07-13 18:57','2026-07-13','588800','科创100ETF华夏',1.923,-5.92,331988024.0,1672857.0,-17484220.0,-5.27,2985220986.0,2985220986.0);
INSERT INTO "etf_snapshot" VALUES(637,'2026-07-13 18:57','2026-07-13','588820','科创200ETF华夏',2.119,-6.45,38574010.0,175299.0,-1089586.0,-2.82,308102600.0,308102600.0);
INSERT INTO "etf_snapshot" VALUES(638,'2026-07-13 18:57','2026-07-13','588840','科创50ETF万家',1.845,-6.87,29052295.0,154892.0,-7110373.0,-24.47,85305420.0,85305420.0);
INSERT INTO "etf_snapshot" VALUES(639,'2026-07-13 18:57','2026-07-13','588850','科创机械ETF嘉实',1.917,-7.03,25301698.0,128138.0,-414894.0,-1.64,162521343.0,162521343.0);
INSERT INTO "etf_snapshot" VALUES(640,'2026-07-13 18:57','2026-07-13','588870','科创50ETF汇添富',2.025,-5.59,165961824.0,804425.0,-31325610.0,-18.88,673417800.0,673417800.0);
INSERT INTO "etf_snapshot" VALUES(641,'2026-07-13 18:57','2026-07-13','588880','科创100ETF华泰柏瑞',1.919,-6.07,17287854.0,88110.0,-1531019.0,-8.86,190687192.0,190687192.0);
INSERT INTO "etf_snapshot" VALUES(642,'2026-07-13 18:57','2026-07-13','588900','科创100ETF南方',1.986,-6.23,16889658.0,81381.0,-245955.0,-1.46,641047054.0,641047054.0);
INSERT INTO "etf_snapshot" VALUES(643,'2026-07-13 18:57','2026-07-13','588910','科创价值ETF建信',1.598,-5.22,15280264.0,93145.0,-557252.0,-3.65,164672462.0,164672462.0);
INSERT INTO "etf_snapshot" VALUES(644,'2026-07-13 18:57','2026-07-13','588940','科创50ETF富国',2.062,-4.14,220265799.0,1046192.0,-45664299.0,-20.73,1264872040.0,1264872040.0);
INSERT INTO "etf_snapshot" VALUES(645,'2026-07-13 18:57','2026-07-13','588950','科创50ETF景顺',2.073,-5.0,121639229.0,575576.0,-30577159.0,-25.14,820347660.0,820347660.0);
INSERT INTO "etf_snapshot" VALUES(646,'2026-07-13 18:57','2026-07-13','588980','科创100ETF广发',1.767,-5.71,3476983.0,19263.0,-450297.0,-12.95,21062640.0,21062640.0);
INSERT INTO "etf_snapshot" VALUES(647,'2026-07-13 18:57','2026-07-13','589000','科创综指ETF华夏',1.796,-4.67,172307268.0,931262.0,-5073748.0,-2.94,1443100023.0,1443100023.0);
INSERT INTO "etf_snapshot" VALUES(648,'2026-07-13 18:57','2026-07-13','589050','科创综指ETF兴业',1.58,-5.28,5233063.0,32779.0,-351642.0,-6.72,80529440.0,80529440.0);
INSERT INTO "etf_snapshot" VALUES(649,'2026-07-13 18:57','2026-07-13','589060','科创综指ETF东财',1.9,-6.36,7015404.0,36067.0,-393965.0,-5.62,118062010.0,118062010.0);
INSERT INTO "etf_snapshot" VALUES(650,'2026-07-13 18:57','2026-07-13','589080','科创综指ETF汇添富',1.786,-4.7,48929786.0,267131.0,-3659129.0,-7.48,264436946.0,264436946.0);
INSERT INTO "etf_snapshot" VALUES(651,'2026-07-13 18:57','2026-07-13','589120','科创创新药ETF汇添富',0.855,-2.4,226803912.0,2631597.0,-40559491.0,-17.88,975230100.0,975230100.0);
INSERT INTO "etf_snapshot" VALUES(652,'2026-07-13 18:57','2026-07-13','589150','科创50ETF平安',1.433,-5.1,25739642.0,175627.0,-2608512.0,-10.13,913447508.0,913447508.0);
INSERT INTO "etf_snapshot" VALUES(653,'2026-07-13 18:57','2026-07-13','589180','科创新材料ETF汇添富',2.017,-6.4,66952215.0,319267.0,-8877844.0,-13.26,283021406.0,283021406.0);
INSERT INTO "etf_snapshot" VALUES(654,'2026-07-13 18:57','2026-07-13','589200','科创200ETF工银',1.524,-6.04,8400491.0,53888.0,3914.0,0.05,29728668.0,29728668.0);
INSERT INTO "etf_snapshot" VALUES(655,'2026-07-13 18:57','2026-07-13','589220','科创200ETF国泰',1.122,-6.03,39586655.0,343259.0,-837257.0,-2.11,334912297.0,334912297.0);
INSERT INTO "etf_snapshot" VALUES(656,'2026-07-13 18:57','2026-07-13','589270','科创100ETF前海开源',1.247,-4.81,4230389.0,33172.0,80683.0,1.91,34313200.0,34313200.0);
INSERT INTO "etf_snapshot" VALUES(657,'2026-07-13 18:57','2026-07-13','589280','科创增强ETF华宝',1.0,-4.85,16243015.0,159335.0,-2105467.0,-12.96,149069000.0,149069000.0);
INSERT INTO "etf_snapshot" VALUES(658,'2026-07-13 18:57','2026-07-13','589300','科创综指ETF嘉实',1.951,-4.78,6632821.0,32719.0,263239.0,3.97,73323458.0,73323458.0);
INSERT INTO "etf_snapshot" VALUES(659,'2026-07-13 18:57','2026-07-13','589320','科创200ETF嘉实',0.948,-6.14,33101361.0,339702.0,-3016041.0,-9.11,105278244.0,105278244.0);
INSERT INTO "etf_snapshot" VALUES(660,'2026-07-13 18:57','2026-07-13','589330','科创200ETF东财',0.964,-5.86,7894148.0,79880.0,-1282993.0,-16.25,82809528.0,82809528.0);
INSERT INTO "etf_snapshot" VALUES(661,'2026-07-13 18:57','2026-07-13','589360','科创50ETF国泰',1.028,-5.69,57137044.0,546286.0,-14260543.0,-24.96,289046872.0,289046872.0);
INSERT INTO "etf_snapshot" VALUES(662,'2026-07-13 18:57','2026-07-13','589500','科创综指ETF工银',1.812,-4.93,17141206.0,92091.0,1168104.0,6.81,154135968.0,154135968.0);
INSERT INTO "etf_snapshot" VALUES(663,'2026-07-13 18:57','2026-07-13','589550','科创价值ETF华夏',1.398,-3.25,7639738.0,53895.0,-831638.0,-10.89,35363109.0,35363109.0);
INSERT INTO "etf_snapshot" VALUES(664,'2026-07-13 18:57','2026-07-13','589580','科创综指ETF兴银',1.795,-6.36,456923.0,2406.0,-170417.0,-37.3,18586866.0,18586866.0);
INSERT INTO "etf_snapshot" VALUES(665,'2026-07-13 18:57','2026-07-13','589600','科创综指ETF富国',1.792,-4.68,23447537.0,128263.0,-2194640.0,-9.36,396990720.0,396990720.0);
INSERT INTO "etf_snapshot" VALUES(666,'2026-07-13 18:57','2026-07-13','589630','科创综指ETF国泰',0.891,-4.91,50782322.0,554284.0,-356330.0,-0.7,295150878.0,295150878.0);
INSERT INTO "etf_snapshot" VALUES(667,'2026-07-13 18:57','2026-07-13','589660','科创综指ETF南方',1.811,-5.03,56205338.0,302117.0,-1465916.0,-2.61,437410830.0,437410830.0);
INSERT INTO "etf_snapshot" VALUES(668,'2026-07-13 18:57','2026-07-13','589680','科创综指ETF鹏华',1.751,-4.58,172836697.0,954018.0,-9583131.0,-5.54,1742146412.0,1742146412.0);
INSERT INTO "etf_snapshot" VALUES(669,'2026-07-13 18:57','2026-07-13','589700','科创成长ETF南方',2.457,-6.33,7986431.0,31918.0,-264676.0,-3.31,35112987.0,35112987.0);
INSERT INTO "etf_snapshot" VALUES(670,'2026-07-13 18:57','2026-07-13','589720','科创创新药ETF国泰',0.926,-2.63,1111610682.0,11886272.0,-110218512.0,-9.92,3457520105.0,3457520105.0);
INSERT INTO "etf_snapshot" VALUES(671,'2026-07-13 18:57','2026-07-13','589770','科创综指ETF招商',1.808,-4.94,20972792.0,113135.0,1882467.0,8.98,277653114.0,277653114.0);
INSERT INTO "etf_snapshot" VALUES(672,'2026-07-13 18:57','2026-07-13','589780','科创200ETF富国',1.351,-5.98,3970928.0,28472.0,-70145.0,-1.77,73244465.0,73244465.0);
INSERT INTO "etf_snapshot" VALUES(673,'2026-07-13 18:57','2026-07-13','589800','科创综指ETF易方达',1.798,-5.07,218956889.0,1185175.0,14031021.0,6.41,1682906798.0,1682906798.0);
INSERT INTO "etf_snapshot" VALUES(674,'2026-07-13 18:57','2026-07-13','589820','科创200ETF建信',1.381,-6.56,11132096.0,77558.0,-1054419.0,-9.47,166714596.0,166714596.0);
INSERT INTO "etf_snapshot" VALUES(675,'2026-07-13 18:57','2026-07-13','589850','科创50ETF东财',1.911,-3.53,204524024.0,1051595.0,-29082147.0,-14.22,930765942.0,930765942.0);
INSERT INTO "etf_snapshot" VALUES(676,'2026-07-13 18:57','2026-07-13','589860','科创综指ETF天弘',1.783,-5.01,37692086.0,205145.0,1696231.0,4.5,296377392.0,296377392.0);
INSERT INTO "etf_snapshot" VALUES(677,'2026-07-13 18:57','2026-07-13','589880','科创综指ETF建信',1.782,-5.01,37564543.0,206617.0,-1698796.0,-4.52,828622872.0,828622872.0);
INSERT INTO "etf_snapshot" VALUES(678,'2026-07-13 18:57','2026-07-13','589890','科创综指ETF景顺',1.776,-4.98,8997384.0,49012.0,-42097.0,-0.47,142056912.0,142056912.0);
INSERT INTO "etf_snapshot" VALUES(679,'2026-07-13 18:57','2026-07-13','589900','科创综指ETF博时',1.808,-5.14,47342341.0,255517.0,-3530566.0,-7.46,296346026.0,296346026.0);
INSERT INTO "etf_snapshot" VALUES(680,'2026-07-13 18:57','2026-07-13','589950','科创100ETF富国',1.452,-5.96,10886468.0,72878.0,-1005201.0,-9.23,458647608.0,458647608.0);
INSERT INTO "etf_snapshot" VALUES(681,'2026-07-13 18:57','2026-07-13','589980','科创100ETF汇添富',2.0,-5.97,6938994.0,33712.0,-437240.0,-6.3,246244000.0,246244000.0);
INSERT INTO "etf_snapshot" VALUES(682,'2026-07-13 18:57','2026-07-13','589990','科创综指ETF华泰柏瑞',1.857,-4.77,16667656.0,86855.0,-3582311.0,-21.49,189581130.0,189581130.0);
INSERT INTO "etf_snapshot" VALUES(683,'2026-07-13 18:57','2026-07-13','512000','券商ETF华宝',0.525,-1.32,1179412000.0,22365618.0,-91269952.0,-7.74,39109789286.0,39109789286.0);
INSERT INTO "etf_snapshot" VALUES(684,'2026-07-13 18:57','2026-07-13','512010','医药ETF易方达',0.36,-0.83,503831116.0,13989540.0,-29848351.0,-5.92,17492290191.0,17492290191.0);
INSERT INTO "etf_snapshot" VALUES(685,'2026-07-13 18:57','2026-07-13','515880','通信ETF国泰',0.738,-5.26,4025785595.0,53432032.0,-518377536.0,-12.88,51764630594.0,51764630594.0);
INSERT INTO "etf_snapshot" VALUES(686,'2026-07-13 18:57','2026-07-13','516020','化工ETF华宝',0.804,-4.4,124737720.0,1533262.0,-5195902.0,-4.17,3166414271.0,3166414271.0);
INSERT INTO "etf_snapshot" VALUES(687,'2026-07-13 18:57','2026-07-13','159022','科创创业人工智能ETF富国',1.174,-3.69,28045972.912,234270.0,-3963169.0,-14.13,183884755.0,183884755.0);
INSERT INTO "etf_snapshot" VALUES(688,'2026-07-13 18:57','2026-07-13','159039','机器人ETF华安',0.919,-5.94,73226354.26,783353.0,-12015973.0,-16.41,361591049.0,361591049.0);
INSERT INTO "etf_snapshot" VALUES(689,'2026-07-13 18:57','2026-07-13','159048','机器人ETF大成',0.941,-6.37,33391766.824,347880.0,-6000743.0,-17.97,154139467.0,154139467.0);
INSERT INTO "etf_snapshot" VALUES(690,'2026-07-13 18:57','2026-07-13','159050','机器人ETF广发',0.929,-6.63,83069969.677,874146.0,-18573439.0,-22.36,578491659.0,578491659.0);
INSERT INTO "etf_snapshot" VALUES(691,'2026-07-13 18:57','2026-07-13','159139','科创创业人工智能ETF华泰柏瑞',1.46,-4.01,48674219.1,322937.0,-1824550.0,-3.75,192879447.0,192879447.0);
INSERT INTO "etf_snapshot" VALUES(692,'2026-07-13 18:57','2026-07-13','159140','科创创业人工智能ETF易方达',1.469,-4.3,95624922.986,635228.0,-13062955.0,-13.66,637453206.0,637453206.0);
INSERT INTO "etf_snapshot" VALUES(693,'2026-07-13 18:57','2026-07-13','159141','科创创业人工智能ETF永赢',1.391,-3.6,136216196.913,967898.0,-5581235.0,-4.1,1940529484.0,1940529484.0);
INSERT INTO "etf_snapshot" VALUES(694,'2026-07-13 18:57','2026-07-13','159142','科创创业人工智能ETF景顺',1.42,-3.6,98707189.0,682643.0,-14383879.0,-14.57,1384869404.0,1384869404.0);
INSERT INTO "etf_snapshot" VALUES(695,'2026-07-13 18:57','2026-07-13','159213','机器人ETF汇添富',1.257,-5.7,49312064.3,384872.0,-5952597.0,-12.07,561549123.0,561549123.0);
INSERT INTO "etf_snapshot" VALUES(696,'2026-07-13 18:57','2026-07-13','159242','创业板人工智能ETF大成',2.276,-4.33,198143164.795,849705.0,-1256369.0,-0.63,1311610039.0,1311610039.0);
INSERT INTO "etf_snapshot" VALUES(697,'2026-07-13 18:57','2026-07-13','159243','创业板人工智能ETF招商',1.366,-4.81,63593732.6,452272.0,-2870493.0,-4.51,180353286.0,180353286.0);
INSERT INTO "etf_snapshot" VALUES(698,'2026-07-13 18:57','2026-07-13','159246','创业板人工智能ETF富国',1.272,-4.22,214950129.045,1661898.0,-6933573.0,-3.23,4520249923.0,4520249923.0);
INSERT INTO "etf_snapshot" VALUES(699,'2026-07-13 18:57','2026-07-13','159248','人工智能ETF万家',2.033,-3.19,29535839.6,142695.0,-5686095.0,-19.25,227890461.0,227890461.0);
INSERT INTO "etf_snapshot" VALUES(700,'2026-07-13 18:57','2026-07-13','159258','机器人ETF南方',1.168,-6.03,39541212.7,331256.0,-3074094.0,-7.77,1387310296.0,1387310296.0);
INSERT INTO "etf_snapshot" VALUES(701,'2026-07-13 18:57','2026-07-13','159272','机器人ETF富国',0.879,-6.49,462070026.999,5152339.0,-103773963.0,-22.46,2296971761.0,2296971761.0);
INSERT INTO "etf_snapshot" VALUES(702,'2026-07-13 18:57','2026-07-13','159278','机器人ETF鹏华',1.034,-6.17,250988593.29,2378972.0,-69434755.0,-27.66,1845220415.0,1845220415.0);
INSERT INTO "etf_snapshot" VALUES(703,'2026-07-13 18:57','2026-07-13','159279','创业板人工智能ETF华安',1.523,-4.81,103045762.019,660166.0,2846933.0,2.76,218379214.0,218379214.0);
INSERT INTO "etf_snapshot" VALUES(704,'2026-07-13 18:57','2026-07-13','159310','芯片ETF天弘',3.562,-7.19,63060037.9,172108.0,-22945902.0,-36.39,1652700635.0,1652700635.0);
INSERT INTO "etf_snapshot" VALUES(705,'2026-07-13 18:57','2026-07-13','159325','半导体ETF南方',2.593,-6.29,262079200.4,982861.0,-32804535.0,-12.52,1437716149.0,1437716149.0);
INSERT INTO "etf_snapshot" VALUES(706,'2026-07-13 18:57','2026-07-13','159327','半导体设备ETF万家',4.114,-7.7,505036096.6,1187841.0,-14637462.0,-2.9,2602206632.0,2602206632.0);
INSERT INTO "etf_snapshot" VALUES(707,'2026-07-13 18:57','2026-07-13','159363','创业板人工智能ETF华宝',1.348,-4.53,1980171337.951,14447742.0,-73435136.0,-3.71,7147324966.0,7147324966.0);
INSERT INTO "etf_snapshot" VALUES(708,'2026-07-13 18:57','2026-07-13','159381','创业板人工智能ETF华夏',1.278,-4.41,648212076.6,4968496.0,-28301753.0,-4.37,2087169790.0,2087169790.0);
INSERT INTO "etf_snapshot" VALUES(709,'2026-07-13 18:57','2026-07-13','159382','创业板人工智能ETF南方',2.882,-4.44,560976612.74,1902668.0,-4160916.0,-0.74,2383574562.0,2383574562.0);
INSERT INTO "etf_snapshot" VALUES(710,'2026-07-13 18:57','2026-07-13','159388','创业板人工智能ETF国泰',1.103,-4.42,226600491.05,2002672.0,-10401738.0,-4.59,918508902.0,918508902.0);
INSERT INTO "etf_snapshot" VALUES(711,'2026-07-13 18:57','2026-07-13','159516','半导体设备ETF国泰',0.865,-4.42,8284913306.512,93309690.0,-850928432.0,-10.27,48961906400.0,48961906400.0);
INSERT INTO "etf_snapshot" VALUES(712,'2026-07-13 18:57','2026-07-13','159526','机器人ETF嘉实',1.535,-5.6,42689568.8,273055.0,-7036996.0,-16.48,871823144.0,871823144.0);
INSERT INTO "etf_snapshot" VALUES(713,'2026-07-13 18:57','2026-07-13','159530','机器人ETF易方达',1.456,-6.61,1470395826.988,9848214.0,-370197537.0,-25.18,17474348610.0,17474348610.0);
INSERT INTO "etf_snapshot" VALUES(714,'2026-07-13 18:57','2026-07-13','159551','机器人ETF国泰',1.351,-6.05,38980914.2,284054.0,-828961.0,-2.13,390332174.0,390332174.0);
INSERT INTO "etf_snapshot" VALUES(715,'2026-07-13 18:57','2026-07-13','159558','半导体设备ETF易方达',1.351,-6.51,3018475417.763,21713267.0,-357203856.0,-11.83,19611877921.0,19611877921.0);
INSERT INTO "etf_snapshot" VALUES(716,'2026-07-13 18:57','2026-07-13','159559','机器人ETF景顺',1.308,-6.3,220068509.6,1646597.0,-73893275.0,-33.58,2340766224.0,2340766224.0);
INSERT INTO "etf_snapshot" VALUES(717,'2026-07-13 18:57','2026-07-13','159560','芯片ETF景顺',2.849,-5.29,50055139.8,170621.0,-6375703.0,-12.74,516855495.0,516855495.0);
INSERT INTO "etf_snapshot" VALUES(718,'2026-07-13 18:57','2026-07-13','159582','半导体ETF博时',0.929,-6.91,186960267.9,1969587.0,-41571495.0,-22.24,794859936.0,794859936.0);
INSERT INTO "etf_snapshot" VALUES(719,'2026-07-13 18:57','2026-07-13','159599','芯片ETF东财',3.525,-5.37,357942742.52,989161.0,-28539338.0,-7.97,2447485276.0,2447485276.0);
INSERT INTO "etf_snapshot" VALUES(720,'2026-07-13 18:57','2026-07-13','159665','半导体龙头ETF工银',3.024,-5.59,154356147.3,496888.0,-5506591.0,-3.57,748672425.0,748672425.0);
INSERT INTO "etf_snapshot" VALUES(721,'2026-07-13 18:57','2026-07-13','159770','机器人ETF天弘',1.078,-6.1,269362586.825,2448236.0,-89146605.0,-33.1,6127985623.0,6127985623.0);
INSERT INTO "etf_snapshot" VALUES(722,'2026-07-13 18:57','2026-07-13','159801','芯片ETF广发',1.439,-5.64,540448174.601,3641259.0,-42628223.0,-7.89,6163409933.0,6163409933.0);
INSERT INTO "etf_snapshot" VALUES(723,'2026-07-13 18:57','2026-07-13','159813','半导体ETF鹏华',1.856,-4.43,1169064680.516,6167466.0,-53212960.0,-4.55,7536960644.0,7536960644.0);
INSERT INTO "etf_snapshot" VALUES(724,'2026-07-13 18:57','2026-07-13','159819','人工智能ETF易方达',2.051,-3.07,885645224.663,4237103.0,-125548309.0,-14.18,22674276106.0,22674276106.0);
INSERT INTO "etf_snapshot" VALUES(725,'2026-07-13 18:57','2026-07-13','159995','芯片ETF华夏',1.458,-5.02,2323255988.453,15611359.0,-306312112.0,-13.18,32551491825.0,32551491825.0);
INSERT INTO "etf_snapshot" VALUES(726,'2026-07-13 18:57','2026-07-13','512480','半导体ETF国联安',1.292,-5.62,2174189014.0,16362728.0,-323736192.0,-14.89,23051873426.0,23051873426.0);
INSERT INTO "etf_snapshot" VALUES(727,'2026-07-13 18:57','2026-07-13','512760','芯片ETF国泰',1.381,-4.63,900073593.0,6336674.0,-79773011.0,-8.86,12574620418.0,12574620418.0);
INSERT INTO "etf_snapshot" VALUES(728,'2026-07-13 18:57','2026-07-13','512930','AI人工智能ETF平安',0.729,-3.06,254701119.0,3431369.0,-38075132.0,-14.95,3508327966.0,3508327966.0);
INSERT INTO "etf_snapshot" VALUES(729,'2026-07-13 18:57','2026-07-13','513310','中韩半导体ETF华泰柏瑞',5.598,-6.22,11375164636.0,19898593.0,-352247744.0,-3.1,13000946391.0,13000946391.0);
INSERT INTO "etf_snapshot" VALUES(730,'2026-07-13 18:57','2026-07-13','515070','人工智能ETF华夏',1.296,-3.36,262367655.0,1983894.0,-17378439.0,-6.62,9583842779.0,9583842779.0);
INSERT INTO "etf_snapshot" VALUES(731,'2026-07-13 18:57','2026-07-13','515980','人工智能ETF华富',1.18,-3.44,841798073.0,7044057.0,-90786022.0,-10.78,6632932173.0,6632932173.0);
INSERT INTO "etf_snapshot" VALUES(732,'2026-07-13 18:57','2026-07-13','516350','芯片ETF易方达',2.06,-6.06,334614086.0,1572731.0,-21517547.0,-6.43,2744775510.0,2744775510.0);
INSERT INTO "etf_snapshot" VALUES(733,'2026-07-13 18:57','2026-07-13','516640','芯片ETF富国',1.823,-4.7,413701425.0,2201502.0,-5796795.0,-1.4,2585894144.0,2585894144.0);
INSERT INTO "etf_snapshot" VALUES(734,'2026-07-13 18:57','2026-07-13','516920','芯片ETF汇添富',1.774,-5.89,90996416.0,499741.0,-20870364.0,-22.94,850567376.0,850567376.0);
INSERT INTO "etf_snapshot" VALUES(735,'2026-07-13 18:57','2026-07-13','517800','人工智能50ETF方正富邦',1.1,-2.65,14406243.0,128662.0,-1643513.0,-11.41,237093670.0,237093670.0);
INSERT INTO "etf_snapshot" VALUES(736,'2026-07-13 18:57','2026-07-13','560630','机器人ETF万家',1.172,-6.24,17559354.0,147244.0,-5096725.0,-29.03,175089768.0,175089768.0);
INSERT INTO "etf_snapshot" VALUES(737,'2026-07-13 18:57','2026-07-13','560770','机器人ETF招商',1.032,-5.93,37471253.0,356859.0,-9842770.0,-26.27,1605413264.0,1605413264.0);
INSERT INTO "etf_snapshot" VALUES(738,'2026-07-13 18:57','2026-07-13','560780','半导体设备ETF广发',1.273,-7.01,1763990476.0,13422935.0,-148845184.0,-8.44,13410403305.0,13410403305.0);
INSERT INTO "etf_snapshot" VALUES(739,'2026-07-13 18:57','2026-07-13','561460','人工智能ETF天弘',0.943,-3.68,31215981.0,324900.0,-4241642.0,-13.59,253214360.0,253214360.0);
INSERT INTO "etf_snapshot" VALUES(740,'2026-07-13 18:57','2026-07-13','561980','半导体设备ETF招商',0.842,-3.77,945271088.0,10909504.0,-137648064.0,-14.56,8087873167.0,8087873167.0);
INSERT INTO "etf_snapshot" VALUES(741,'2026-07-13 18:57','2026-07-13','562360','机器人ETF银华',1.128,-5.84,27113739.0,236160.0,-5459887.0,-20.14,303966672.0,303966672.0);
INSERT INTO "etf_snapshot" VALUES(742,'2026-07-13 18:57','2026-07-13','562500','机器人ETF华夏',1.042,-5.96,1092391983.0,10263751.0,-275987775.0,-25.26,17525593062.0,17525593062.0);
INSERT INTO "etf_snapshot" VALUES(743,'2026-07-13 18:57','2026-07-13','562590','半导体设备ETF华夏',1.219,-6.73,989769605.0,7873350.0,-122134959.0,-12.34,9463083659.0,9463083659.0);
INSERT INTO "etf_snapshot" VALUES(744,'2026-07-13 18:57','2026-07-13','588170','科创半导体ETF华夏',1.214,-6.04,7659092283.0,61196725.0,-363903088.0,-4.75,34661456707.0,34661456707.0);
INSERT INTO "etf_snapshot" VALUES(745,'2026-07-13 18:57','2026-07-13','588200','科创芯片ETF嘉实',4.332,-5.1,7448106694.0,16735665.0,-293898176.0,-3.95,59681507927.0,59681507927.0);
INSERT INTO "etf_snapshot" VALUES(746,'2026-07-13 18:57','2026-07-13','588290','科创芯片ETF华安',4.244,-5.16,574243277.0,1312104.0,45999810.0,8.01,5523128902.0,5523128902.0);
INSERT INTO "etf_snapshot" VALUES(747,'2026-07-13 18:57','2026-07-13','588410','科创创业人工智能ETF鹏华',1.404,-3.9,7598022.0,53071.0,-2913748.0,-38.35,147771000.0,147771000.0);
INSERT INTO "etf_snapshot" VALUES(748,'2026-07-13 18:57','2026-07-13','588420','科创创业人工智能ETF摩根',1.402,-4.17,22999222.0,160284.0,-2155868.0,-9.37,178962496.0,178962496.0);
INSERT INTO "etf_snapshot" VALUES(749,'2026-07-13 18:57','2026-07-13','588430','科创创业人工智能ETF工银',1.432,-4.21,18245519.0,124655.0,-1131766.0,-6.2,129535856.0,129535856.0);
INSERT INTO "etf_snapshot" VALUES(750,'2026-07-13 18:57','2026-07-13','588470','科创创业人工智能ETF华安',0.994,-3.96,56216685.0,554977.0,-8394885.0,-14.93,240455558.0,240455558.0);
INSERT INTO "etf_snapshot" VALUES(751,'2026-07-13 18:57','2026-07-13','588480','科创创业人工智能ETF中金',1.059,-3.73,15315995.0,142069.0,-3515826.0,-22.96,183966303.0,183966303.0);
INSERT INTO "etf_snapshot" VALUES(752,'2026-07-13 18:57','2026-07-13','588510','科创创业人工智能ETF华夏',1.005,-3.64,30396924.0,299703.0,-6916493.0,-22.75,252430875.0,252430875.0);
INSERT INTO "etf_snapshot" VALUES(753,'2026-07-13 18:57','2026-07-13','588710','科创半导体设备ETF华泰柏瑞',3.751,-5.85,2053450257.0,5334938.0,-132888832.0,-6.47,7878206575.0,7878206575.0);
INSERT INTO "etf_snapshot" VALUES(754,'2026-07-13 18:57','2026-07-13','588730','科创人工智能ETF易方达',1.743,-4.49,190821742.0,1058333.0,5241713.0,2.75,1095294758.0,1095294758.0);
INSERT INTO "etf_snapshot" VALUES(755,'2026-07-13 18:57','2026-07-13','588750','科创芯片ETF汇添富',2.896,-4.86,578239981.0,1949960.0,-3146446.0,-0.54,9447412288.0,9447412288.0);
INSERT INTO "etf_snapshot" VALUES(756,'2026-07-13 18:57','2026-07-13','588760','科创人工智能ETF广发',0.886,-4.32,441343057.0,4803787.0,-22521161.0,-5.1,1798165352.0,1798165352.0);
INSERT INTO "etf_snapshot" VALUES(757,'2026-07-13 18:57','2026-07-13','588780','科创芯片设计ETF国联安',1.198,-5.67,318028124.0,2552810.0,-22699360.0,-7.14,1126002596.0,1126002596.0);
INSERT INTO "etf_snapshot" VALUES(758,'2026-07-13 18:57','2026-07-13','588790','科创AIETF博时',0.932,-4.61,483679851.0,5011254.0,-29902938.0,-6.18,2486933888.0,2486933888.0);
INSERT INTO "etf_snapshot" VALUES(759,'2026-07-13 18:57','2026-07-13','588810','科创芯片ETF富国',3.081,-4.2,202860073.0,638033.0,-13359360.0,-6.59,1849598244.0,1849598244.0);
INSERT INTO "etf_snapshot" VALUES(760,'2026-07-13 18:57','2026-07-13','588890','科创芯片ETF南方',4.879,-5.35,473333666.0,931796.0,-12779857.0,-2.7,4643880990.0,4643880990.0);
INSERT INTO "etf_snapshot" VALUES(761,'2026-07-13 18:57','2026-07-13','588920','科创芯片ETF鹏华',2.782,-3.9,85161750.0,297716.0,-7850468.0,-9.22,426864516.0,426864516.0);
INSERT INTO "etf_snapshot" VALUES(762,'2026-07-13 18:57','2026-07-13','588930','科创人工智能ETF银华',1.847,-4.05,152204360.0,795277.0,-3748754.0,-2.46,1062632678.0,1062632678.0);
INSERT INTO "etf_snapshot" VALUES(763,'2026-07-13 18:57','2026-07-13','588990','科创芯片ETF博时',4.522,-5.5,111089786.0,237912.0,-4300605.0,-3.87,903248699.0,903248699.0);
INSERT INTO "etf_snapshot" VALUES(764,'2026-07-13 18:57','2026-07-13','589010','科创人工智能ETF华夏',1.66,-3.77,228933784.0,1331453.0,-388722.0,-0.17,1473736393.0,1473736393.0);
INSERT INTO "etf_snapshot" VALUES(765,'2026-07-13 18:57','2026-07-13','589020','科创半导体设备ETF鹏华',2.955,-6.31,1742647337.0,5750086.0,-78151968.0,-4.48,3552557169.0,3552557169.0);
INSERT INTO "etf_snapshot" VALUES(766,'2026-07-13 18:57','2026-07-13','589030','科创芯片设计ETF易方达',1.392,-5.63,97040292.0,669979.0,-7673177.0,-7.91,423275195.0,423275195.0);
INSERT INTO "etf_snapshot" VALUES(767,'2026-07-13 18:57','2026-07-13','589070','科创芯片设计ETF天弘',1.307,-5.63,208644873.0,1531634.0,-4778178.0,-2.29,2356903961.0,2356903961.0);
INSERT INTO "etf_snapshot" VALUES(768,'2026-07-13 18:57','2026-07-13','589090','科创AIETF鹏华',1.251,-4.06,8101648.0,63306.0,-297345.0,-3.67,190065681.0,190065681.0);
INSERT INTO "etf_snapshot" VALUES(769,'2026-07-13 18:57','2026-07-13','589100','科创芯片ETF国泰',1.113,-5.68,103439960.0,903600.0,-17089696.0,-16.52,1001079498.0,1001079498.0);
INSERT INTO "etf_snapshot" VALUES(770,'2026-07-13 18:57','2026-07-13','589110','科创人工智能ETF国泰',1.085,-4.49,9734303.0,87012.0,-153746.0,-1.58,527758114.0,527758114.0);
INSERT INTO "etf_snapshot" VALUES(771,'2026-07-13 18:57','2026-07-13','589130','科创芯片ETF易方达',1.714,-5.62,346236983.0,1955904.0,-44501526.0,-12.85,5115912920.0,5115912920.0);
INSERT INTO "etf_snapshot" VALUES(772,'2026-07-13 18:57','2026-07-13','589160','科创芯片ETF广发',1.565,-6.18,97979398.0,607496.0,-7085426.0,-7.23,416753240.0,416753240.0);
INSERT INTO "etf_snapshot" VALUES(773,'2026-07-13 18:57','2026-07-13','589170','科创芯片设计ETF鹏华',1.313,-5.68,11975957.0,87970.0,-1426108.0,-11.91,166631517.0,166631517.0);
INSERT INTO "etf_snapshot" VALUES(774,'2026-07-13 18:57','2026-07-13','589190','科创芯片ETF华宝',1.577,-3.49,140789404.0,867872.0,1238615.0,0.88,2447158650.0,2447158650.0);
INSERT INTO "etf_snapshot" VALUES(775,'2026-07-13 18:57','2026-07-13','589210','科创芯片设计ETF广发',1.654,-7.55,58888713.0,339760.0,-4696939.0,-7.98,1118879739.0,1118879739.0);
INSERT INTO "etf_snapshot" VALUES(776,'2026-07-13 18:57','2026-07-13','589230','科创人工智能ETF南方',1.012,-4.71,33385556.0,318838.0,-52564.0,-0.16,208525636.0,208525636.0);
INSERT INTO "etf_snapshot" VALUES(777,'2026-07-13 18:57','2026-07-13','589250','科创芯片设计ETF浦银',1.517,-5.95,15791732.0,100634.0,-41394.0,-0.26,107860672.0,107860672.0);
INSERT INTO "etf_snapshot" VALUES(778,'2026-07-13 18:57','2026-07-13','589260','科创芯片设计ETF国泰',1.518,-5.54,11119353.0,70955.0,-776772.0,-6.99,79172808.0,79172808.0);
INSERT INTO "etf_snapshot" VALUES(779,'2026-07-13 18:57','2026-07-13','589290','科创芯片设计ETF汇添富',0.97,-5.64,22198154.0,222644.0,-6523850.0,-29.39,116253433.0,116253433.0);
INSERT INTO "etf_snapshot" VALUES(780,'2026-07-13 18:57','2026-07-13','589310','科创人工智能ETF鑫元',0.975,-4.13,17849903.0,178186.0,-1988627.0,-11.14,276404513.0,276404513.0);
INSERT INTO "etf_snapshot" VALUES(781,'2026-07-13 18:57','2026-07-13','589350','科创芯片设计ETF银华',0.943,-6.91,23737380.0,244138.0,-10298978.0,-43.39,145487455.0,145487455.0);
INSERT INTO "etf_snapshot" VALUES(782,'2026-07-13 18:57','2026-07-13','589380','科创人工智能ETF富国',1.672,-4.18,5879310.0,34325.0,847466.0,14.41,146624870.0,146624870.0);
INSERT INTO "etf_snapshot" VALUES(783,'2026-07-13 18:57','2026-07-13','589390','科创芯片设计ETF招商',0.934,-5.56,215132517.0,2187030.0,-7589126.0,-3.53,1109415003.0,1109415003.0);
INSERT INTO "etf_snapshot" VALUES(784,'2026-07-13 18:57','2026-07-13','589400','科创芯片设计ETF富国',0.937,-5.35,27791347.0,286084.0,-3485237.0,-12.54,265906732.0,265906732.0);
INSERT INTO "etf_snapshot" VALUES(785,'2026-07-13 18:57','2026-07-13','589420','科创芯片设计ETF永赢',0.943,-5.51,20160086.0,207715.0,-3852981.0,-19.11,281468058.0,281468058.0);
INSERT INTO "etf_snapshot" VALUES(786,'2026-07-13 18:57','2026-07-13','589520','科创人工智能ETF华宝',0.708,-4.19,59581451.0,815737.0,-5188250.0,-8.71,448238062.0,448238062.0);
INSERT INTO "etf_snapshot" VALUES(787,'2026-07-13 18:57','2026-07-13','589560','科创人工智能ETF汇添富',1.122,-4.43,13789534.0,120402.0,-2334561.0,-16.93,247238310.0,247238310.0);
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
INSERT INTO "llm_decision" VALUES(2,'2026-07-13 18:02','1520','{"summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "regime": {"trade_date": "2026-07-13", "above_ma20_ratio": 0.06451612903225806, "ma20_slope_positive_ratio": 0.5725806451612904, "inflow_positive_ratio": 0.12755102040816327, "regime": "TREND_DOWN"}, "train_rules": {"theme_enabled": true, "max_total_exposure_pct": 0.4}, "workflow_note": "rule-only workflow executed.", "focus_watch": [{"id": 171, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "512010", "name": "医药ETF", "group_name": "SECTOR", "score": 6.27, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 181, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "512890", "name": "红利低波ETF", "group_name": "DEFENSE", "score": 1.33, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 374, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "589720", "name": "科创创新药ETF国泰", "group_name": "GROWTH", "score": 0.18, "rule_result": "wait", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}], "wait": [{"id": 351, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "589190", "name": "科创芯片ETF华宝", "group_name": "THEME", "score": -2.19, "rule_result": "wait", "reason": "主力流入强度不足；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 127, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "159925", "name": "沪深300ETF南方", "group_name": "CORE", "score": -3.02, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}], "exclude": [{"id": 234, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "562320", "name": "沪深300价值ETF银华", "group_name": "CORE", "score": 8.98, "rule_result": "exclude", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 146, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "510190", "name": "上证50ETF华安", "group_name": "CORE", "score": 7.0, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 189, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "515360", "name": "沪深300ETF方正富邦", "group_name": "CORE", "score": 4.64, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 166, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "510710", "name": "上证50ETF博时", "group_name": "CORE", "score": 4.32, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 168, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "510850", "name": "上证50ETF工银", "group_name": "CORE", "score": 3.28, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 33, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "159289", "name": "创业板综指ETF鹏华", "group_name": "GROWTH", "score": 1.69, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 363, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "589380", "name": "科创人工智能ETF富国", "group_name": "THEME", "score": 1.41, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 210, "ts": "2026-07-13 18:02", "trade_date": "2026-07-13", "session_name": "1520", "code": "560330", "name": "沪深300价值ETF申万菱信", "group_name": "CORE", "score": 0.96, "rule_result": "exclude", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}], "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"]}','1520 short-flow

v0.1规则引擎输出，大模型判断将在v0.2接入。

可观察：
1. 512010 医药ETF：主力资金未转正；OBSERVE_ONLY
2. 512890 红利低波ETF：主力资金未转正；OBSERVE_ONLY
3. 589720 科创创新药ETF国泰：主力资金未转正；B_PLATFORM_BREAKOUT_WATCH

等待：
1. 589190 科创芯片ETF华宝：主力流入强度不足；OBSERVE_ONLY
2. 159925 沪深300ETF南方：主力资金未转正；OBSERVE_ONLY

今日不碰：
1. 562320 沪深300价值ETF银华：成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH
2. 510190 上证50ETF华安：成交额低于阈值；OBSERVE_ONLY
3. 515360 沪深300ETF方正富邦：成交额低于阈值；OBSERVE_ONLY
4. 510710 上证50ETF博时：成交额低于阈值；OBSERVE_ONLY
5. 510850 上证50ETF工银：成交额低于阈值；OBSERVE_ONLY
6. 159289 创业板综指ETF鹏华：成交额低于阈值；OBSERVE_ONLY
7. 589380 科创人工智能ETF富国：成交额低于阈值；OBSERVE_ONLY
8. 560330 沪深300价值ETF申万菱信：成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH
');
INSERT INTO "llm_decision" VALUES(3,'2026-07-13 19:05','1520','{"summary": "v0.1规则引擎输出，大模型判断将在v0.2接入。", "regime": {"trade_date": "2026-07-13", "above_ma20_ratio": 0.06451612903225806, "ma20_slope_positive_ratio": 0.5725806451612904, "inflow_positive_ratio": 0.12755102040816327, "regime": "TREND_DOWN"}, "train_rules": {"theme_enabled": true, "max_total_exposure_pct": 0.4}, "workflow_note": "rule-only workflow executed.", "focus_watch": [{"id": 554, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "512010", "name": "医药ETF", "group_name": "SECTOR", "score": 6.27, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 564, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "512890", "name": "红利低波ETF", "group_name": "DEFENSE", "score": 1.33, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 757, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "589720", "name": "科创创新药ETF国泰", "group_name": "GROWTH", "score": 0.18, "rule_result": "wait", "reason": "主力资金未转正；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}], "wait": [{"id": 734, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "589190", "name": "科创芯片ETF华宝", "group_name": "THEME", "score": -2.19, "rule_result": "wait", "reason": "主力流入强度不足；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}, {"id": 510, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "159925", "name": "沪深300ETF南方", "group_name": "CORE", "score": -3.04, "rule_result": "wait", "reason": "主力资金未转正；OBSERVE_ONLY", "entry_trigger": "等待资金转正并站回MA5", "failure_condition": "继续跌破MA10或放量长阴"}], "exclude": [{"id": 617, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "562320", "name": "沪深300价值ETF银华", "group_name": "CORE", "score": 8.98, "rule_result": "exclude", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 529, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "510190", "name": "上证50ETF华安", "group_name": "CORE", "score": 7.0, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 572, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "515360", "name": "沪深300ETF方正富邦", "group_name": "CORE", "score": 4.64, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 549, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "510710", "name": "上证50ETF博时", "group_name": "CORE", "score": 4.32, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 551, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "510850", "name": "上证50ETF工银", "group_name": "CORE", "score": 3.28, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 416, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "159289", "name": "创业板综指ETF鹏华", "group_name": "GROWTH", "score": 1.69, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 746, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "589380", "name": "科创人工智能ETF富国", "group_name": "THEME", "score": 1.41, "rule_result": "exclude", "reason": "成交额低于阈值；OBSERVE_ONLY", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}, {"id": 593, "ts": "2026-07-13 19:05", "trade_date": "2026-07-13", "session_name": "1520", "code": "560330", "name": "沪深300价值ETF申万菱信", "group_name": "CORE", "score": 0.96, "rule_result": "exclude", "reason": "成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH", "entry_trigger": "不触发", "failure_condition": "今日不碰，盘后重新评估"}], "risk_notes": ["不自动下单", "首笔不超过计划仓位1/3", "主题ETF已启用"]}','1520 short-flow

v0.1规则引擎输出，大模型判断将在v0.2接入。

可观察：
1. 512010 医药ETF：主力资金未转正；OBSERVE_ONLY
2. 512890 红利低波ETF：主力资金未转正；OBSERVE_ONLY
3. 589720 科创创新药ETF国泰：主力资金未转正；B_PLATFORM_BREAKOUT_WATCH

等待：
1. 589190 科创芯片ETF华宝：主力流入强度不足；OBSERVE_ONLY
2. 159925 沪深300ETF南方：主力资金未转正；OBSERVE_ONLY

今日不碰：
1. 562320 沪深300价值ETF银华：成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH
2. 510190 上证50ETF华安：成交额低于阈值；OBSERVE_ONLY
3. 515360 沪深300ETF方正富邦：成交额低于阈值；OBSERVE_ONLY
4. 510710 上证50ETF博时：成交额低于阈值；OBSERVE_ONLY
5. 510850 上证50ETF工银：成交额低于阈值；OBSERVE_ONLY
6. 159289 创业板综指ETF鹏华：成交额低于阈值；OBSERVE_ONLY
7. 589380 科创人工智能ETF富国：成交额低于阈值；OBSERVE_ONLY
8. 560330 沪深300价值ETF申万菱信：成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH
');
CREATE TABLE market_regime (
  trade_date TEXT PRIMARY KEY,
  above_ma20_ratio REAL,
  ma20_slope_positive_ratio REAL,
  inflow_positive_ratio REAL,
  regime TEXT
);
INSERT INTO "market_regime" VALUES('2026-07-13',6.45161290322580627e-02,5.72580645161290369e-01,1.27551020408163268e-01,'TREND_DOWN');
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
INSERT INTO "signal_result" VALUES(387,'2026-07-13 19:05','2026-07-13','1520','159012','科创创业50ETF鹏华','GROWTH',-9.33,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(388,'2026-07-13 19:05','2026-07-13','1520','159022','科创创业人工智能ETF富国','THEME',-10.79,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(389,'2026-07-13 19:05','2026-07-13','1520','159048','机器人ETF大成','THEME',-18.88,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(390,'2026-07-13 19:05','2026-07-13','1520','159050','机器人ETF广发','THEME',-20.26,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(391,'2026-07-13 19:05','2026-07-13','1520','159107','创业板软件ETF富国','GROWTH',-12.29,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(392,'2026-07-13 19:05','2026-07-13','1520','159139','科创创业人工智能ETF华泰柏瑞','THEME',-6.67,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(393,'2026-07-13 19:05','2026-07-13','1520','159140','科创创业人工智能ETF易方达','THEME',-11.51,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(394,'2026-07-13 19:05','2026-07-13','1520','159141','科创创业人工智能ETF永赢','THEME',-6.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(395,'2026-07-13 19:05','2026-07-13','1520','159142','科创创业人工智能ETF景顺','THEME',-10.71,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(396,'2026-07-13 19:05','2026-07-13','1520','159205','创业板ETF东财','GROWTH',-14.3,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(397,'2026-07-13 19:05','2026-07-13','1520','159213','机器人ETF汇添富','THEME',-15.06,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(398,'2026-07-13 19:05','2026-07-13','1520','159215','A500ETF平安','CORE',-8.28,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(399,'2026-07-13 19:05','2026-07-13','1520','159226','中证A500增强ETF国泰','CORE',-13.61,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(400,'2026-07-13 19:05','2026-07-13','1520','159238','沪深300增强ETF景顺','CORE',-3.57,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(401,'2026-07-13 19:05','2026-07-13','1520','159240','A500增强ETF天弘','CORE',-12.79,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(402,'2026-07-13 19:05','2026-07-13','1520','159242','创业板人工智能ETF大成','THEME',-7.07,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(403,'2026-07-13 19:05','2026-07-13','1520','159243','创业板人工智能ETF招商','THEME',-9.61,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(404,'2026-07-13 19:05','2026-07-13','1520','159246','创业板人工智能ETF富国','THEME',-8.05,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(405,'2026-07-13 19:05','2026-07-13','1520','159247','创业板ETF汇添富','GROWTH',-15.19,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(406,'2026-07-13 19:05','2026-07-13','1520','159248','人工智能ETF万家','THEME',-12.08,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(407,'2026-07-13 19:05','2026-07-13','1520','159249','A500增强ETF工银','CORE',-2.79,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(408,'2026-07-13 19:05','2026-07-13','1520','159256','创业板软件ETF华夏','GROWTH',-8.53,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(409,'2026-07-13 19:05','2026-07-13','1520','159258','机器人ETF南方','THEME',-13.69,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(410,'2026-07-13 19:05','2026-07-13','1520','159270','创业板200ETF南方','GROWTH',-12.36,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(411,'2026-07-13 19:05','2026-07-13','1520','159272','机器人ETF富国','THEME',-19.97,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(412,'2026-07-13 19:05','2026-07-13','1520','159278','机器人ETF鹏华','THEME',-19.47,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(413,'2026-07-13 19:05','2026-07-13','1520','159279','创业板人工智能ETF华安','THEME',-6.41,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(414,'2026-07-13 19:05','2026-07-13','1520','159287','创业板综ETF博时','GROWTH',-7.47,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(415,'2026-07-13 19:05','2026-07-13','1520','159288','创业板综ETF银华','GROWTH',-16.01,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(416,'2026-07-13 19:05','2026-07-13','1520','159289','创业板综指ETF鹏华','GROWTH',1.69,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(417,'2026-07-13 19:05','2026-07-13','1520','159290','创业板综指增强ETF东财','GROWTH',-6.17,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(418,'2026-07-13 19:05','2026-07-13','1520','159291','创业板综增强ETF招商','GROWTH',-13.14,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(419,'2026-07-13 19:05','2026-07-13','1520','159292','创业板综增强ETF华宝','GROWTH',-4.95,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(420,'2026-07-13 19:05','2026-07-13','1520','159293','创业板综增强ETF建信','GROWTH',-5.38,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(421,'2026-07-13 19:05','2026-07-13','1520','159298','创业板50ETF大成','GROWTH',-11.08,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(422,'2026-07-13 19:05','2026-07-13','1520','159300','沪深300ETF富国','CORE',-11.71,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(423,'2026-07-13 19:05','2026-07-13','1520','159310','芯片ETF天弘','THEME',-17.5,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(424,'2026-07-13 19:05','2026-07-13','1520','159325','半导体ETF南方','THEME',-12.7,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(425,'2026-07-13 19:05','2026-07-13','1520','159327','半导体设备ETF万家','THEME',-7.62,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(426,'2026-07-13 19:05','2026-07-13','1520','159330','沪深300ETF东财','CORE',-12.02,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(427,'2026-07-13 19:05','2026-07-13','1520','159335','央企科创ETF融通','GROWTH',-15.67,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(428,'2026-07-13 19:05','2026-07-13','1520','159337','中证500ETF东财','CORE',-4.6,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(429,'2026-07-13 19:05','2026-07-13','1520','159338','中证A500ETF国泰','CORE',-7.36,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(430,'2026-07-13 19:05','2026-07-13','1520','159339','A500ETF银华','CORE',-11.11,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(431,'2026-07-13 19:05','2026-07-13','1520','159351','A500ETF嘉实','CORE',-5.47,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(432,'2026-07-13 19:05','2026-07-13','1520','159352','A500ETF南方','CORE',-6.17,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(433,'2026-07-13 19:05','2026-07-13','1520','159353','中证A500ETF景顺','CORE',-7.86,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(434,'2026-07-13 19:05','2026-07-13','1520','159356','A500ETF万家','CORE',-4.41,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(435,'2026-07-13 19:05','2026-07-13','1520','159357','A500ETF博时','CORE',-7.58,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(436,'2026-07-13 19:05','2026-07-13','1520','159358','中证A500ETF大成','CORE',-6.66,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(437,'2026-07-13 19:05','2026-07-13','1520','159359','A500ETF华安','CORE',-4.83,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(438,'2026-07-13 19:05','2026-07-13','1520','159360','A500ETF天弘','CORE',-6.25,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(439,'2026-07-13 19:05','2026-07-13','1520','159361','A500ETF易方达','CORE',-6.07,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(440,'2026-07-13 19:05','2026-07-13','1520','159362','A500ETF工银','CORE',-5.07,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(441,'2026-07-13 19:05','2026-07-13','1520','159363','创业板人工智能ETF华宝','THEME',-8.78,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(442,'2026-07-13 19:05','2026-07-13','1520','159367','创业板50ETF华夏','GROWTH',-6.9,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(443,'2026-07-13 19:05','2026-07-13','1520','159369','创业板50ETF易方达','GROWTH',-14.81,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(444,'2026-07-13 19:05','2026-07-13','1520','159371','创业板50ETF富国','GROWTH',-15.48,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(445,'2026-07-13 19:05','2026-07-13','1520','159372','创业板50ETF万家','GROWTH',-16.95,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(446,'2026-07-13 19:05','2026-07-13','1520','159373','创业板50ETF嘉实','GROWTH',-6.19,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(447,'2026-07-13 19:05','2026-07-13','1520','159375','创业板50ETF国泰','GROWTH',-7.59,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(448,'2026-07-13 19:05','2026-07-13','1520','159376','A500ETF浦银','CORE',-7.64,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(449,'2026-07-13 19:05','2026-07-13','1520','159379','A500ETF融通','CORE',-3.45,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(450,'2026-07-13 19:05','2026-07-13','1520','159380','A500ETF东财','CORE',-14.21,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(451,'2026-07-13 19:05','2026-07-13','1520','159381','创业板人工智能ETF华夏','THEME',-8.84,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(452,'2026-07-13 19:05','2026-07-13','1520','159382','创业板人工智能ETF南方','THEME',-7.28,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(453,'2026-07-13 19:05','2026-07-13','1520','159383','创业板50ETF华泰柏瑞','GROWTH',-14.67,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(454,'2026-07-13 19:05','2026-07-13','1520','159386','A500ETF永赢','CORE',-5.6,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(455,'2026-07-13 19:05','2026-07-13','1520','159388','创业板人工智能ETF国泰','THEME',-9.0,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(456,'2026-07-13 19:05','2026-07-13','1520','159393','沪深300ETF万家','CORE',-12.14,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(457,'2026-07-13 19:05','2026-07-13','1520','159500','中证500ETF富国','CORE',-13.46,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(458,'2026-07-13 19:05','2026-07-13','1520','159510','沪深300价值ETF华夏','CORE',-5.82,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(459,'2026-07-13 19:05','2026-07-13','1520','159516','半导体设备ETF国泰','THEME',-5.69,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(460,'2026-07-13 19:05','2026-07-13','1520','159523','沪深300成长ETF华夏','CORE',-9.44,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(461,'2026-07-13 19:05','2026-07-13','1520','159526','机器人ETF嘉实','THEME',-16.87,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(462,'2026-07-13 19:05','2026-07-13','1520','159530','机器人ETF易方达','THEME',-20.24,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(463,'2026-07-13 19:05','2026-07-13','1520','159541','创业板综ETF万家','GROWTH',0.37,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(464,'2026-07-13 19:05','2026-07-13','1520','159551','机器人ETF国泰','THEME',-11.16,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(465,'2026-07-13 19:05','2026-07-13','1520','159558','半导体设备ETF易方达','THEME',-9.74,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(466,'2026-07-13 19:05','2026-07-13','1520','159559','机器人ETF景顺','THEME',-19.74,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(467,'2026-07-13 19:05','2026-07-13','1520','159560','芯片ETF景顺','THEME',-11.2,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(468,'2026-07-13 19:05','2026-07-13','1520','159563','创业板综ETF华夏','GROWTH',-11.18,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(469,'2026-07-13 19:05','2026-07-13','1520','159571','创业板200ETF富国','GROWTH',-13.34,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(470,'2026-07-13 19:05','2026-07-13','1520','159572','创业板200ETF易方达','GROWTH',-13.25,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(471,'2026-07-13 19:05','2026-07-13','1520','159573','创业板200ETF华夏','GROWTH',-12.79,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(472,'2026-07-13 19:05','2026-07-13','1520','159575','创业板200ETF银华','GROWTH',-12.7,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(473,'2026-07-13 19:05','2026-07-13','1520','159582','半导体ETF博时','THEME',-14.06,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(474,'2026-07-13 19:05','2026-07-13','1520','159597','创业板成长ETF易方达','GROWTH',-11.5,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(475,'2026-07-13 19:05','2026-07-13','1520','159599','芯片ETF东财','THEME',-9.18,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(476,'2026-07-13 19:05','2026-07-13','1520','159603','科创创业ETF天弘','GROWTH',-16.04,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(477,'2026-07-13 19:05','2026-07-13','1520','159606','中证500成长ETF易方达','CORE',-4.91,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(478,'2026-07-13 19:05','2026-07-13','1520','159610','中证500增强ETF景顺','CORE',-13.91,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(479,'2026-07-13 19:05','2026-07-13','1520','159617','中证500价值ETF华夏','CORE',-3.47,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(480,'2026-07-13 19:05','2026-07-13','1520','159620','中证500成长ETF华夏','CORE',-8.42,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(481,'2026-07-13 19:05','2026-07-13','1520','159629','中证1000ETF富国','CORE',-12.55,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(482,'2026-07-13 19:05','2026-07-13','1520','159633','中证1000ETF易方达','CORE',-10.02,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(483,'2026-07-13 19:05','2026-07-13','1520','159656','沪深300成长ETF万家','CORE',-7.4,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(484,'2026-07-13 19:05','2026-07-13','1520','159665','半导体龙头ETF工银','THEME',-7.55,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(485,'2026-07-13 19:05','2026-07-13','1520','159673','沪深300ETF鹏华','CORE',-5.44,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(486,'2026-07-13 19:05','2026-07-13','1520','159675','创业板增强ETF嘉实','GROWTH',-8.19,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(487,'2026-07-13 19:05','2026-07-13','1520','159676','创业板增强ETF富国','GROWTH',-15.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(488,'2026-07-13 19:05','2026-07-13','1520','159677','中证1000增强ETF银华','CORE',-4.93,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(489,'2026-07-13 19:05','2026-07-13','1520','159679','中证1000增强ETF国泰','CORE',-19.51,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(490,'2026-07-13 19:05','2026-07-13','1520','159680','中证1000增强ETF招商','CORE',-14.75,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(491,'2026-07-13 19:05','2026-07-13','1520','159681','创业板50ETF鹏华','GROWTH',-13.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(492,'2026-07-13 19:05','2026-07-13','1520','159682','创业板50ETF景顺','GROWTH',-10.55,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(493,'2026-07-13 19:05','2026-07-13','1520','159770','机器人ETF天弘','THEME',-19.32,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(494,'2026-07-13 19:05','2026-07-13','1520','159773','创业板科技ETF华泰柏瑞','GROWTH',-6.41,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(495,'2026-07-13 19:05','2026-07-13','1520','159780','科创创业50ETF南方','GROWTH',-5.84,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(496,'2026-07-13 19:05','2026-07-13','1520','159781','科创创业ETF易方达','GROWTH',-2.22,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(497,'2026-07-13 19:05','2026-07-13','1520','159782','双创50ETF银华','GROWTH',-11.31,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(498,'2026-07-13 19:05','2026-07-13','1520','159783','科创创业50ETF华夏','GROWTH',-12.34,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(499,'2026-07-13 19:05','2026-07-13','1520','159801','芯片ETF广发','THEME',-9.57,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(500,'2026-07-13 19:05','2026-07-13','1520','159810','创业板ETF浦银','GROWTH',-10.43,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(501,'2026-07-13 19:05','2026-07-13','1520','159813','半导体ETF鹏华','THEME',-6.14,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(502,'2026-07-13 19:05','2026-07-13','1520','159819','人工智能ETF易方达','THEME',-9.67,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(503,'2026-07-13 19:05','2026-07-13','1520','159820','中证500ETF天弘','CORE',-14.69,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(504,'2026-07-13 19:05','2026-07-13','1520','159836','创业板300ETF天弘','GROWTH',-8.79,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(505,'2026-07-13 19:05','2026-07-13','1520','159845','中证1000ETF华夏','CORE',-10.45,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(506,'2026-07-13 19:05','2026-07-13','1520','159908','创业板ETF博时','GROWTH',-4.34,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(507,'2026-07-13 19:05','2026-07-13','1520','159915','创业板ETF','GROWTH',-11.71,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(508,'2026-07-13 19:05','2026-07-13','1520','159919','沪深300ETF嘉实','CORE',-8.46,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(509,'2026-07-13 19:05','2026-07-13','1520','159922','中证500ETF嘉实','CORE',-12.38,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(510,'2026-07-13 19:05','2026-07-13','1520','159925','沪深300ETF南方','CORE',-3.04,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(511,'2026-07-13 19:05','2026-07-13','1520','159935','中证500ETF景顺','CORE',-0.35,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(512,'2026-07-13 19:05','2026-07-13','1520','159948','创业板ETF南方','GROWTH',-7.46,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(513,'2026-07-13 19:05','2026-07-13','1520','159949','创业板50ETF华安','GROWTH',-3.45,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(514,'2026-07-13 19:05','2026-07-13','1520','159952','创业板ETF广发','GROWTH',-11.04,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(515,'2026-07-13 19:05','2026-07-13','1520','159956','创业板ETF建信','GROWTH',-6.59,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(516,'2026-07-13 19:05','2026-07-13','1520','159957','创业板ETF华夏','GROWTH',-11.64,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(517,'2026-07-13 19:05','2026-07-13','1520','159958','创业板ETF工银','GROWTH',-1.82,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(518,'2026-07-13 19:05','2026-07-13','1520','159964','创业板ETF平安','GROWTH',-8.68,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(519,'2026-07-13 19:05','2026-07-13','1520','159966','创业板价值ETF华夏','GROWTH',-10.39,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(520,'2026-07-13 19:05','2026-07-13','1520','159967','创业板成长ETF华夏','GROWTH',-10.33,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(521,'2026-07-13 19:05','2026-07-13','1520','159968','中证500ETF博时','CORE',-14.46,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(522,'2026-07-13 19:05','2026-07-13','1520','159971','创业板ETF富国','GROWTH',-10.93,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(523,'2026-07-13 19:05','2026-07-13','1520','159977','创业板ETF天弘','GROWTH',-6.94,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(524,'2026-07-13 19:05','2026-07-13','1520','159982','中证500ETF鹏华','CORE',-11.72,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(525,'2026-07-13 19:05','2026-07-13','1520','159991','创业板大盘ETF招商','GROWTH',-10.43,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(526,'2026-07-13 19:05','2026-07-13','1520','159995','芯片ETF华夏','THEME',-10.96,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(527,'2026-07-13 19:05','2026-07-13','1520','510050','上证50ETF','CORE',-8.81,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(528,'2026-07-13 19:05','2026-07-13','1520','510100','上证50ETF易方达','CORE',-3.64,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(529,'2026-07-13 19:05','2026-07-13','1520','510190','上证50ETF华安','CORE',7.0,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(530,'2026-07-13 19:05','2026-07-13','1520','510300','沪深300ETF','CORE',-12.06,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(531,'2026-07-13 19:05','2026-07-13','1520','510310','沪深300ETF易方达','CORE',-12.14,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(532,'2026-07-13 19:05','2026-07-13','1520','510320','沪深300ETF中金','CORE',-9.33,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(533,'2026-07-13 19:05','2026-07-13','1520','510330','沪深300ETF华夏','CORE',-10.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(534,'2026-07-13 19:05','2026-07-13','1520','510350','沪深300ETF工银','CORE',-3.1,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(535,'2026-07-13 19:05','2026-07-13','1520','510360','沪深300ETF广发','CORE',-12.35,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(536,'2026-07-13 19:05','2026-07-13','1520','510370','沪深300ETF兴业','CORE',-5.39,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(537,'2026-07-13 19:05','2026-07-13','1520','510380','沪深300ETF国寿','CORE',-9.32,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(538,'2026-07-13 19:05','2026-07-13','1520','510390','沪深300ETF平安','CORE',-12.0,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(539,'2026-07-13 19:05','2026-07-13','1520','510500','中证500ETF','CORE',-14.01,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(540,'2026-07-13 19:05','2026-07-13','1520','510510','中证500ETF广发','CORE',-11.94,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(541,'2026-07-13 19:05','2026-07-13','1520','510530','中证500ETF工银','CORE',-13.78,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(542,'2026-07-13 19:05','2026-07-13','1520','510550','中证500ETF方正富邦','CORE',-19.04,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(543,'2026-07-13 19:05','2026-07-13','1520','510560','中证500ETF国寿','CORE',-16.32,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(544,'2026-07-13 19:05','2026-07-13','1520','510570','中证500ETF兴业','CORE',-16.09,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(545,'2026-07-13 19:05','2026-07-13','1520','510580','中证500ETF易方达','CORE',-9.54,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(546,'2026-07-13 19:05','2026-07-13','1520','510590','中证500ETF平安','CORE',-4.42,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(547,'2026-07-13 19:05','2026-07-13','1520','510600','上证50ETF申万菱信','CORE',-6.17,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(548,'2026-07-13 19:05','2026-07-13','1520','510680','上证50ETF万家','CORE',-9.64,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(549,'2026-07-13 19:05','2026-07-13','1520','510710','上证50ETF博时','CORE',4.32,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(550,'2026-07-13 19:05','2026-07-13','1520','510800','上证50ETF建信','CORE',-5.92,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(551,'2026-07-13 19:05','2026-07-13','1520','510850','上证50ETF工银','CORE',3.28,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(552,'2026-07-13 19:05','2026-07-13','1520','510950','上证50ETF广发','CORE',-10.17,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(553,'2026-07-13 19:05','2026-07-13','1520','512000','券商ETF','SECTOR',-4.66,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(554,'2026-07-13 19:05','2026-07-13','1520','512010','医药ETF','SECTOR',6.27,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(555,'2026-07-13 19:05','2026-07-13','1520','512020','A500ETF鹏华','CORE',-5.98,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(556,'2026-07-13 19:05','2026-07-13','1520','512050','A500ETF华夏','CORE',-6.14,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(557,'2026-07-13 19:05','2026-07-13','1520','512080','A500ETF中金','CORE',-4.1,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(558,'2026-07-13 19:05','2026-07-13','1520','512100','中证1000ETF','CORE',-10.85,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(559,'2026-07-13 19:05','2026-07-13','1520','512370','A500增强ETF华夏','CORE',-12.92,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(560,'2026-07-13 19:05','2026-07-13','1520','512480','半导体ETF国联安','THEME',-12.69,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(561,'2026-07-13 19:05','2026-07-13','1520','512500','中证500ETF华夏','CORE',-11.28,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(562,'2026-07-13 19:05','2026-07-13','1520','512510','中证500ETF华泰柏瑞','CORE',-13.31,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(563,'2026-07-13 19:05','2026-07-13','1520','512760','半导体ETF','THEME',-8.39,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(564,'2026-07-13 19:05','2026-07-13','1520','512890','红利低波ETF','DEFENSE',1.33,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(565,'2026-07-13 19:05','2026-07-13','1520','512930','AI人工智能ETF平安','THEME',-10.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(566,'2026-07-13 19:05','2026-07-13','1520','513310','中韩半导体ETF华泰柏瑞','THEME',-11.46,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(567,'2026-07-13 19:05','2026-07-13','1520','515070','AI ETF','THEME',-6.81,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(568,'2026-07-13 19:05','2026-07-13','1520','515130','沪深300ETF博时','CORE',-6.54,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(569,'2026-07-13 19:05','2026-07-13','1520','515310','沪深300ETF汇添富','CORE',-12.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(570,'2026-07-13 19:05','2026-07-13','1520','515330','沪深300ETF天弘','CORE',-9.91,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(571,'2026-07-13 19:05','2026-07-13','1520','515350','沪深300ETF民生加银','CORE',-1.38,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(572,'2026-07-13 19:05','2026-07-13','1520','515360','沪深300ETF方正富邦','CORE',4.64,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(573,'2026-07-13 19:05','2026-07-13','1520','515380','沪深300ETF泰康','CORE',-3.53,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(574,'2026-07-13 19:05','2026-07-13','1520','515390','沪深300ETF华安','CORE',-3.48,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(575,'2026-07-13 19:05','2026-07-13','1520','515530','中证500ETF泰康','CORE',-14.77,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(576,'2026-07-13 19:05','2026-07-13','1520','515550','中证500ETF国联','CORE',-1.14,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(577,'2026-07-13 19:05','2026-07-13','1520','515660','沪深300ETF国联安','CORE',-11.27,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(578,'2026-07-13 19:05','2026-07-13','1520','515880','通信ETF','SECTOR',-15.2,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(579,'2026-07-13 19:05','2026-07-13','1520','515980','人工智能ETF华富','THEME',-8.83,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(580,'2026-07-13 19:05','2026-07-13','1520','516020','化工ETF','SECTOR',-10.52,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(581,'2026-07-13 19:05','2026-07-13','1520','516300','中证1000ETF华泰柏瑞','CORE',-17.49,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(582,'2026-07-13 19:05','2026-07-13','1520','516350','芯片ETF易方达','THEME',-9.59,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(583,'2026-07-13 19:05','2026-07-13','1520','516640','芯片ETF富国','THEME',-5.15,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(584,'2026-07-13 19:05','2026-07-13','1520','516830','沪深300ESGETF富国','CORE',0.57,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(585,'2026-07-13 19:05','2026-07-13','1520','516920','芯片ETF汇添富','THEME',-15.42,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(586,'2026-07-13 19:05','2026-07-13','1520','517800','人工智能50ETF方正富邦','THEME',-8.52,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(587,'2026-07-13 19:05','2026-07-13','1520','530000','上证50ETF天弘','CORE',-5.27,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(588,'2026-07-13 19:05','2026-07-13','1520','530050','上证50ETF东财','CORE',-8.25,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(589,'2026-07-13 19:05','2026-07-13','1520','560010','中证1000ETF广发','CORE',-10.47,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(590,'2026-07-13 19:05','2026-07-13','1520','560100','中证500增强ETF南方','CORE',-6.4,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(591,'2026-07-13 19:05','2026-07-13','1520','560110','中证1000ETF汇添富','CORE',-15.72,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(592,'2026-07-13 19:05','2026-07-13','1520','560180','沪深300ESGETF南方','CORE',-5.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(593,'2026-07-13 19:05','2026-07-13','1520','560330','沪深300价值ETF申万菱信','CORE',0.96,'exclude','成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(594,'2026-07-13 19:05','2026-07-13','1520','560510','中证A500ETF泰康','CORE',-10.6,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(595,'2026-07-13 19:05','2026-07-13','1520','560530','中证A500ETF摩根','CORE',-7.68,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(596,'2026-07-13 19:05','2026-07-13','1520','560590','中证1000增强ETF鹏华','CORE',-11.36,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(597,'2026-07-13 19:05','2026-07-13','1520','560610','A500ETF招商','CORE',-8.48,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(598,'2026-07-13 19:05','2026-07-13','1520','560630','机器人ETF万家','THEME',-19.5,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(599,'2026-07-13 19:05','2026-07-13','1520','560750','A500ETF申万菱信','CORE',-4.42,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(600,'2026-07-13 19:05','2026-07-13','1520','560770','机器人ETF招商','THEME',-19.06,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(601,'2026-07-13 19:05','2026-07-13','1520','560780','半导体设备ETF广发','THEME',-9.01,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(602,'2026-07-13 19:05','2026-07-13','1520','560950','中证500增强ETF汇添富','CORE',-14.95,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(603,'2026-07-13 19:05','2026-07-13','1520','561000','沪深300增强ETF华安','CORE',-10.8,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(604,'2026-07-13 19:05','2026-07-13','1520','561090','A500增强ETF华安','CORE',-14.22,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(605,'2026-07-13 19:05','2026-07-13','1520','561280','中证1000增强ETF工银','CORE',-16.64,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(606,'2026-07-13 19:05','2026-07-13','1520','561300','沪深300增强ETF国泰','CORE',-8.93,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(607,'2026-07-13 19:05','2026-07-13','1520','561350','中证500ETF国泰','CORE',-9.55,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(608,'2026-07-13 19:05','2026-07-13','1520','561550','中证500增强ETF华泰柏瑞','CORE',-10.78,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(609,'2026-07-13 19:05','2026-07-13','1520','561590','中证1000增强ETF华泰柏瑞','CORE',-9.51,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(610,'2026-07-13 19:05','2026-07-13','1520','561900','沪深300ESGETF招商','CORE',-6.56,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(611,'2026-07-13 19:05','2026-07-13','1520','561930','沪深300ETF招商','CORE',-11.82,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(612,'2026-07-13 19:05','2026-07-13','1520','561950','中证500增强ETF招商','CORE',-5.52,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(613,'2026-07-13 19:05','2026-07-13','1520','561980','半导体设备ETF招商','THEME',-6.58,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(614,'2026-07-13 19:05','2026-07-13','1520','561990','沪深300增强ETF招商','CORE',-6.71,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(615,'2026-07-13 19:05','2026-07-13','1520','562070','沪深300指增ETF华宝','CORE',-2.11,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(616,'2026-07-13 19:05','2026-07-13','1520','562310','沪深300成长ETF银华','CORE',-9.72,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(617,'2026-07-13 19:05','2026-07-13','1520','562320','沪深300价值ETF银华','CORE',8.98,'exclude','成交额低于阈值；B_PLATFORM_BREAKOUT_WATCH','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(618,'2026-07-13 19:05','2026-07-13','1520','562330','中证500价值ETF银华','CORE',-11.08,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(619,'2026-07-13 19:05','2026-07-13','1520','562340','中证500成长ETF银华','CORE',-7.04,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(620,'2026-07-13 19:05','2026-07-13','1520','562360','机器人ETF银华','THEME',-18.94,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(621,'2026-07-13 19:05','2026-07-13','1520','562500','机器人ETF','THEME',-19.16,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(622,'2026-07-13 19:05','2026-07-13','1520','562520','中证1000成长ETF华夏','CORE',-9.43,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(623,'2026-07-13 19:05','2026-07-13','1520','562530','中证1000价值ETF华夏','CORE',-2.36,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(624,'2026-07-13 19:05','2026-07-13','1520','562590','半导体设备ETF华夏','THEME',-10.32,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(625,'2026-07-13 19:05','2026-07-13','1520','563030','中证500增强ETF易方达','CORE',-15.2,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(626,'2026-07-13 19:05','2026-07-13','1520','563090','上证50增强ETF易方达','CORE',-1.62,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(627,'2026-07-13 19:05','2026-07-13','1520','563220','A500ETF富国','CORE',-5.91,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(628,'2026-07-13 19:05','2026-07-13','1520','563360','A500ETF华泰柏瑞','CORE',-5.96,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(629,'2026-07-13 19:05','2026-07-13','1520','563500','A500ETF华宝','CORE',-6.19,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(630,'2026-07-13 19:05','2026-07-13','1520','563520','沪深300ETF永赢','CORE',-1.86,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(631,'2026-07-13 19:05','2026-07-13','1520','563550','A500增强ETF摩根','CORE',-9.11,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(632,'2026-07-13 19:05','2026-07-13','1520','563600','A500增强ETF易方达','CORE',-10.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(633,'2026-07-13 19:05','2026-07-13','1520','563630','A500增强ETF国联安','CORE',-8.93,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(634,'2026-07-13 19:05','2026-07-13','1520','563650','中证A500ETF兴业','CORE',-6.18,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(635,'2026-07-13 19:05','2026-07-13','1520','563660','A500ETF银河','CORE',-8.02,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(636,'2026-07-13 19:05','2026-07-13','1520','563750','中证500ETF汇添富','CORE',-14.63,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(637,'2026-07-13 19:05','2026-07-13','1520','563800','A500ETF广发','CORE',-6.93,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(638,'2026-07-13 19:05','2026-07-13','1520','563860','中证A500ETF海富通','CORE',-7.29,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(639,'2026-07-13 19:05','2026-07-13','1520','563880','A500ETF汇添富','CORE',-5.9,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(640,'2026-07-13 19:05','2026-07-13','1520','588000','科创50ETF华夏','GROWTH',-12.45,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(641,'2026-07-13 19:05','2026-07-13','1520','588010','科创新材料ETF博时','GROWTH',-10.84,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(642,'2026-07-13 19:05','2026-07-13','1520','588020','科创成长ETF易方达','GROWTH',-9.52,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(643,'2026-07-13 19:05','2026-07-13','1520','588030','科创100ETF博时','GROWTH',-7.53,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(644,'2026-07-13 19:05','2026-07-13','1520','588040','科创50ETF鹏华','GROWTH',-11.77,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(645,'2026-07-13 19:05','2026-07-13','1520','588050','科创50ETF工银','GROWTH',-9.6,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(646,'2026-07-13 19:05','2026-07-13','1520','588060','科创50ETF广发','GROWTH',-12.09,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(647,'2026-07-13 19:05','2026-07-13','1520','588070','科创成长ETF万家','GROWTH',-8.15,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(648,'2026-07-13 19:05','2026-07-13','1520','588080','科创50ETF易方达','GROWTH',-5.28,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(649,'2026-07-13 19:05','2026-07-13','1520','588090','科创50ETF华泰柏瑞','GROWTH',-8.52,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(650,'2026-07-13 19:05','2026-07-13','1520','588100','科创信息ETF嘉实','GROWTH',-7.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(651,'2026-07-13 19:05','2026-07-13','1520','588110','科创成长ETF广发','GROWTH',-4.42,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(652,'2026-07-13 19:05','2026-07-13','1520','588120','科创100ETF国泰','GROWTH',-7.43,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(653,'2026-07-13 19:05','2026-07-13','1520','588140','科创200ETF广发','GROWTH',-6.6,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(654,'2026-07-13 19:05','2026-07-13','1520','588150','科创50ETF南方','GROWTH',-8.24,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(655,'2026-07-13 19:05','2026-07-13','1520','588160','科创新材料ETF南方','GROWTH',-10.76,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(656,'2026-07-13 19:05','2026-07-13','1520','588170','科创半导体ETF华夏','THEME',-5.8,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(657,'2026-07-13 19:05','2026-07-13','1520','588180','科创50ETF国联安','GROWTH',-14.28,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(658,'2026-07-13 19:05','2026-07-13','1520','588190','科创100ETF银华','GROWTH',-8.1,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(659,'2026-07-13 19:05','2026-07-13','1520','588200','科创芯片ETF嘉实','THEME',-6.94,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(660,'2026-07-13 19:05','2026-07-13','1520','588210','科创100ETF易方达','GROWTH',-6.35,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(661,'2026-07-13 19:05','2026-07-13','1520','588220','科创100F','GROWTH',-7.94,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(662,'2026-07-13 19:05','2026-07-13','1520','588230','科创200ETF华泰柏瑞','GROWTH',-17.56,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(663,'2026-07-13 19:05','2026-07-13','1520','588240','科创200ETF鹏华','GROWTH',-11.09,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(664,'2026-07-13 19:05','2026-07-13','1520','588260','科创信息ETF华安','GROWTH',-13.9,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(665,'2026-07-13 19:05','2026-07-13','1520','588270','科创200ETF易方达','GROWTH',-13.02,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(666,'2026-07-13 19:05','2026-07-13','1520','588280','科创50ETF华安','GROWTH',-11.49,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(667,'2026-07-13 19:05','2026-07-13','1520','588290','科创芯片ETF华安','THEME',-1.65,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(668,'2026-07-13 19:05','2026-07-13','1520','588300','科创创业50ETF招商','GROWTH',-8.0,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(669,'2026-07-13 19:05','2026-07-13','1520','588310','科创创业ETF方正富邦','GROWTH',-11.82,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(670,'2026-07-13 19:05','2026-07-13','1520','588320','双创50增强ETF广发','GROWTH',-6.8,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(671,'2026-07-13 19:05','2026-07-13','1520','588330','双创50ETF华宝','GROWTH',-6.71,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(672,'2026-07-13 19:05','2026-07-13','1520','588350','科创创业50ETF鹏扬','GROWTH',-15.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(673,'2026-07-13 19:05','2026-07-13','1520','588360','科创创业ETF国泰','GROWTH',-5.46,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(674,'2026-07-13 19:05','2026-07-13','1520','588370','科创50增强ETF南方','GROWTH',-12.83,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(675,'2026-07-13 19:05','2026-07-13','1520','588380','科创创业ETF富国','GROWTH',-7.78,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(676,'2026-07-13 19:05','2026-07-13','1520','588390','科创创业ETF博时','GROWTH',-13.07,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(677,'2026-07-13 19:05','2026-07-13','1520','588400','科创创业ETF嘉实','GROWTH',-11.27,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(678,'2026-07-13 19:05','2026-07-13','1520','588410','科创创业人工智能ETF鹏华','THEME',-13.81,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(679,'2026-07-13 19:05','2026-07-13','1520','588420','科创创业人工智能ETF摩根','THEME',-9.5,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(680,'2026-07-13 19:05','2026-07-13','1520','588430','科创创业人工智能ETF工银','THEME',-8.1,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(681,'2026-07-13 19:05','2026-07-13','1520','588450','科创50增强ETF招商','GROWTH',-11.4,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(682,'2026-07-13 19:05','2026-07-13','1520','588460','科创50增强ETF鹏华','GROWTH',-10.6,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(683,'2026-07-13 19:05','2026-07-13','1520','588470','科创创业人工智能ETF华安','THEME',-11.62,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(684,'2026-07-13 19:05','2026-07-13','1520','588480','科创创业人工智能ETF中金','THEME',-13.57,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(685,'2026-07-13 19:05','2026-07-13','1520','588500','科创100增强ETF易方达','GROWTH',-15.31,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(686,'2026-07-13 19:05','2026-07-13','1520','588510','科创创业人工智能ETF华夏','THEME',-13.33,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(687,'2026-07-13 19:05','2026-07-13','1520','588520','科创增强ETF永赢','GROWTH',-6.04,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(688,'2026-07-13 19:05','2026-07-13','1520','588550','科创综指增强ETF易方达','GROWTH',-7.63,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(689,'2026-07-13 19:05','2026-07-13','1520','588660','科创创业50ETF兴银','GROWTH',-13.19,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(690,'2026-07-13 19:05','2026-07-13','1520','588670','科创综指增强ETF嘉实','GROWTH',-5.39,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(691,'2026-07-13 19:05','2026-07-13','1520','588680','科创100增强ETF广发','GROWTH',-15.98,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(692,'2026-07-13 19:05','2026-07-13','1520','588690','科创增强ETF银华','GROWTH',-10.34,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(693,'2026-07-13 19:05','2026-07-13','1520','588710','科创半导体设备ETF华泰柏瑞','THEME',-6.27,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(694,'2026-07-13 19:05','2026-07-13','1520','588720','科创50ETF中银','GROWTH',-9.63,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(695,'2026-07-13 19:05','2026-07-13','1520','588730','科创人工智能ETF易方达','THEME',-4.38,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(696,'2026-07-13 19:05','2026-07-13','1520','588750','科创芯片ETF汇添富','THEME',-5.02,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(697,'2026-07-13 19:05','2026-07-13','1520','588760','科创人工智能ETF广发','THEME',-7.68,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(698,'2026-07-13 19:05','2026-07-13','1520','588770','科创信息ETF摩根','GROWTH',0.17,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(699,'2026-07-13 19:05','2026-07-13','1520','588780','科创芯片设计ETF国联安','THEME',-9.87,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(700,'2026-07-13 19:05','2026-07-13','1520','588790','科创AIETF博时','THEME',-8.67,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(701,'2026-07-13 19:05','2026-07-13','1520','588800','科创100ETF华夏','GROWTH',-10.5,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(702,'2026-07-13 19:05','2026-07-13','1520','588810','科创芯片ETF富国','THEME',-6.69,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(703,'2026-07-13 19:05','2026-07-13','1520','588820','科创200ETF华夏','GROWTH',-11.43,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(704,'2026-07-13 19:05','2026-07-13','1520','588840','科创50ETF万家','GROWTH',-17.08,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(705,'2026-07-13 19:05','2026-07-13','1520','588850','科创机械ETF嘉实','GROWTH',-12.01,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(706,'2026-07-13 19:05','2026-07-13','1520','588870','科创50ETF汇添富','GROWTH',-14.47,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(707,'2026-07-13 19:05','2026-07-13','1520','588880','科创100ETF华泰柏瑞','GROWTH',-12.37,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(708,'2026-07-13 19:05','2026-07-13','1520','588890','科创芯片ETF南方','THEME',-6.78,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(709,'2026-07-13 19:05','2026-07-13','1520','588900','科创100ETF南方','GROWTH',-9.3,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(710,'2026-07-13 19:05','2026-07-13','1520','588910','科创价值ETF建信','GROWTH',-9.53,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(711,'2026-07-13 19:05','2026-07-13','1520','588920','科创芯片ETF鹏华','THEME',-7.39,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(712,'2026-07-13 19:05','2026-07-13','1520','588930','科创人工智能ETF银华','THEME',-6.02,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(713,'2026-07-13 19:05','2026-07-13','1520','588940','科创50ETF富国','GROWTH',-12.67,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(714,'2026-07-13 19:05','2026-07-13','1520','588950','科创50ETF景顺','GROWTH',-14.05,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(715,'2026-07-13 19:05','2026-07-13','1520','588980','科创100ETF广发','GROWTH',-13.61,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(716,'2026-07-13 19:05','2026-07-13','1520','588990','科创芯片ETF博时','THEME',-7.54,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(717,'2026-07-13 19:05','2026-07-13','1520','589000','科创综指ETF华夏','GROWTH',-7.19,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(718,'2026-07-13 19:05','2026-07-13','1520','589010','科创人工智能ETF华夏','THEME',-4.5,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(719,'2026-07-13 19:05','2026-07-13','1520','589020','KC半导体','THEME',-6.11,'wait','主力资金未转正；A_PULLBACK_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(720,'2026-07-13 19:05','2026-07-13','1520','589030','科创芯片设计ETF易方达','THEME',-10.12,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(721,'2026-07-13 19:05','2026-07-13','1520','589050','科创综指ETF兴业','GROWTH',-9.85,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(722,'2026-07-13 19:05','2026-07-13','1520','589060','科创综指ETF东财','GROWTH',-10.92,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(723,'2026-07-13 19:05','2026-07-13','1520','589070','科创芯片设计ETF天弘','THEME',-7.6,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(724,'2026-07-13 19:05','2026-07-13','1520','589080','科创综指ETF汇添富','GROWTH',-9.28,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(725,'2026-07-13 19:05','2026-07-13','1520','589090','科创AIETF鹏华','THEME',-6.57,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(726,'2026-07-13 19:05','2026-07-13','1520','589100','科创芯片ETF国泰','THEME',-13.52,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(727,'2026-07-13 19:05','2026-07-13','1520','589110','科创人工智能ETF国泰','THEME',-6.32,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(728,'2026-07-13 19:05','2026-07-13','1520','589120','科创创新药ETF汇添富','GROWTH',-3.05,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(729,'2026-07-13 19:05','2026-07-13','1520','589130','科创芯片ETF易方达','THEME',-11.77,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(730,'2026-07-13 19:05','2026-07-13','1520','589150','科创50ETF平安','GROWTH',-9.95,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(731,'2026-07-13 19:05','2026-07-13','1520','589160','科创芯片ETF广发','THEME',-10.14,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(732,'2026-07-13 19:05','2026-07-13','1520','589170','科创芯片设计ETF鹏华','THEME',-12.13,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(733,'2026-07-13 19:05','2026-07-13','1520','589180','科创新材料ETF汇添富','GROWTH',-15.89,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(734,'2026-07-13 19:05','2026-07-13','1520','589190','科创芯片ETF华宝','THEME',-2.19,'wait','主力流入强度不足；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(735,'2026-07-13 19:05','2026-07-13','1520','589200','科创200ETF工银','GROWTH',-9.28,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(736,'2026-07-13 19:05','2026-07-13','1520','589210','科创芯片设计ETF广发','THEME',-13.22,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(737,'2026-07-13 19:05','2026-07-13','1520','589220','科创200ETF国泰','GROWTH',-10.37,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(738,'2026-07-13 19:05','2026-07-13','1520','589230','科创人工智能ETF南方','THEME',-6.07,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(739,'2026-07-13 19:05','2026-07-13','1520','589250','科创芯片设计ETF浦银','THEME',-7.19,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(740,'2026-07-13 19:05','2026-07-13','1520','589260','科创芯片设计ETF国泰','THEME',-9.6,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(741,'2026-07-13 19:05','2026-07-13','1520','589270','科创100ETF前海开源','GROWTH',-5.2,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(742,'2026-07-13 19:05','2026-07-13','1520','589280','科创增强ETF华宝','GROWTH',-12.69,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(743,'2026-07-13 19:05','2026-07-13','1520','589300','科创综指ETF嘉实','GROWTH',-4.35,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(744,'2026-07-13 19:05','2026-07-13','1520','589320','科创200ETF嘉实','GROWTH',-13.68,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(745,'2026-07-13 19:05','2026-07-13','1520','589330','科创200ETF东财','GROWTH',-16.35,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(746,'2026-07-13 19:05','2026-07-13','1520','589380','科创人工智能ETF富国','THEME',1.41,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(747,'2026-07-13 19:05','2026-07-13','1520','589500','科创综指ETF工银','GROWTH',-3.21,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(748,'2026-07-13 19:05','2026-07-13','1520','589520','科创人工智能ETF华宝','THEME',-9.08,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(749,'2026-07-13 19:05','2026-07-13','1520','589550','科创价值ETF华夏','GROWTH',-8.82,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(750,'2026-07-13 19:05','2026-07-13','1520','589560','科创人工智能ETF汇添富','THEME',-13.17,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(751,'2026-07-13 19:05','2026-07-13','1520','589580','科创综指ETF兴银','GROWTH',-17.5,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(752,'2026-07-13 19:05','2026-07-13','1520','589600','科创综指ETF富国','GROWTH',-10.07,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(753,'2026-07-13 19:05','2026-07-13','1520','589630','科创综指ETF国泰','GROWTH',-6.83,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(754,'2026-07-13 19:05','2026-07-13','1520','589660','科创综指ETF南方','GROWTH',-7.6,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(755,'2026-07-13 19:05','2026-07-13','1520','589680','科创综指ETF鹏华','GROWTH',-8.3,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(756,'2026-07-13 19:05','2026-07-13','1520','589700','科创成长ETF南方','GROWTH',-10.63,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(757,'2026-07-13 19:05','2026-07-13','1520','589720','科创创新药ETF国泰','GROWTH',0.18,'wait','主力资金未转正；B_PLATFORM_BREAKOUT_WATCH','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(758,'2026-07-13 19:05','2026-07-13','1520','589770','科创综指ETF招商','GROWTH',-2.29,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(759,'2026-07-13 19:05','2026-07-13','1520','589780','科创200ETF富国','GROWTH',-10.13,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(760,'2026-07-13 19:05','2026-07-13','1520','589800','科创综指ETF易方达','GROWTH',-3.68,'exclude','跌破MA10；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(761,'2026-07-13 19:05','2026-07-13','1520','589820','科创200ETF建信','GROWTH',-14.5,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(762,'2026-07-13 19:05','2026-07-13','1520','589850','科创50ETF东财','GROWTH',-9.13,'wait','主力资金未转正；OBSERVE_ONLY','等待资金转正并站回MA5','继续跌破MA10或放量长阴');
INSERT INTO "signal_result" VALUES(763,'2026-07-13 19:05','2026-07-13','1520','589860','科创综指ETF天弘','GROWTH',-4.43,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(764,'2026-07-13 19:05','2026-07-13','1520','589880','科创综指ETF建信','GROWTH',-8.48,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(765,'2026-07-13 19:05','2026-07-13','1520','589890','科创综指ETF景顺','GROWTH',-6.61,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(766,'2026-07-13 19:05','2026-07-13','1520','589900','科创综指ETF博时','GROWTH',-9.96,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(767,'2026-07-13 19:05','2026-07-13','1520','589950','科创100ETF富国','GROWTH',-12.31,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(768,'2026-07-13 19:05','2026-07-13','1520','589980','科创100ETF汇添富','GROWTH',-11.06,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
INSERT INTO "signal_result" VALUES(769,'2026-07-13 19:05','2026-07-13','1520','589990','科创综指ETF华泰柏瑞','GROWTH',-15.07,'exclude','成交额低于阈值；OBSERVE_ONLY','不触发','今日不碰，盘后重新评估');
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
INSERT INTO "sqlite_sequence" VALUES('etf_snapshot',787);
INSERT INTO "sqlite_sequence" VALUES('etf_indicator',769);
INSERT INTO "sqlite_sequence" VALUES('signal_result',769);
INSERT INTO "sqlite_sequence" VALUES('llm_decision',3);
INSERT INTO "sqlite_sequence" VALUES('analysis_run',3);
INSERT INTO "sqlite_sequence" VALUES('alert_log',3);
COMMIT;
