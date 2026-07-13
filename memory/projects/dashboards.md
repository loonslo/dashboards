# 看板项目（本仓库）

私有仓库，公开部署在 Vercel。静态 HTML/JS 前端 + Python 后端 + SQLite。

- **index-decision**：投资观察看板（指数、自选、告警、数据缺口）
- **short-flow**：A股短线资金看板，两条独立数据路径：
  1. short_flow_dashboard.py — 东财资金流 → dashboard_latest.json
  2. daily_job.py — 8步 ETF 训练管道，SQLite 驱动，产出 etf_pool_latest.json

## 关键需求
- 看板数据要根据不同市场的频率更新：
  - A股：交易时段场次制（0850/0940/1130/1430/1520）
  - 美股：美东收盘后 / 盘中另行安排
  - 数字币：7×24

## v0.2 策略修复（2026-07-09，待提交）
- 回踩模式独立过滤通道（+MA20斜率向上）；盘中场次成交额用前一完整日
- 五级个股止损（exit_rules）；regime 滞回+按跟踪指数去重
- backtest.py：信号前瞻收益 + score 五分位分层（验证追涨偏差）
- index-decision cost 信号：σ 锚定90日，放量=1.2×20日均量
- 已知限制：主力资金因子对ETF弱、score追涨偏差、trailing 5%固定、tracking_index 名称启发式
- quintile 判定已上线（已推送）：2×SE 显著 / ≥0.5pct 弱显著 / inconclusive / 样本不足，六态；以 5d 为准
- 待办：样本翻几倍后按 regime 分层跑 quintile（RANGE vs TREND_UP，预期结论不同，已记在 commit message）
