"""两段漏斗的短名单加载。

流程：T-1 盘后（1520 场次）全市场粗筛产出 candidate/wait 名单；
T 日盘中场次（0850/0940/1130/1430）只跟踪该短名单，不重扫全市场。

盘中实际需要行情的代码集合 = 短名单 ∪ 未平仓持仓 ∪ 基准ETF：
- 持仓必须监控（止损检查依赖当日快照），即使已跌出短名单；
- 基准ETF用于盘中崩盘降级判断（regime 复用 T-1 值，但指数大跌时强制降级）。
"""

INTRADAY_SESSIONS = {"0850", "0940", "1130", "1430"}


def is_intraday(session):
    return session in INTRADAY_SESSIONS


def load_shortlist(conn, before_date, max_size=15):
    """T-1 短名单：早于 before_date 的最近一个交易日、最后一个场次的
    candidate+wait，candidate 优先、按 score 降序，截断到 max_size。"""
    prev = conn.execute(
        """
        SELECT trade_date, session_name FROM signal_result
        WHERE trade_date < ?
        ORDER BY trade_date DESC, ts DESC LIMIT 1
        """,
        (before_date,),
    ).fetchone()
    if not prev:
        return []
    result = conn.execute(
        """
        SELECT code FROM signal_result
        WHERE trade_date=? AND session_name=? AND rule_result IN ('candidate','wait')
        ORDER BY CASE rule_result WHEN 'candidate' THEN 0 ELSE 1 END, score DESC
        LIMIT ?
        """,
        (prev["trade_date"], prev["session_name"], int(max_size)),
    ).fetchall()
    return [row["code"] for row in result]


def open_position_codes(conn):
    result = conn.execute(
        "SELECT DISTINCT code FROM trade_log WHERE exit_date IS NULL"
    ).fetchall()
    return [row["code"] for row in result]


def benchmark_codes(config):
    raw = str(config.get("shortlist", {}).get("benchmark_codes", "")).strip()
    return [code.strip() for code in raw.split(",") if code.strip()]


def monitor_codes(conn, before_date, config):
    """盘中需要拉取行情/指标的全部代码（去重、保序：短名单→持仓→基准）。"""
    max_size = config.get("shortlist", {}).get("max_size", 15)
    seen = []
    for code in (
        load_shortlist(conn, before_date, max_size)
        + open_position_codes(conn)
        + benchmark_codes(config)
    ):
        if code not in seen:
            seen.append(code)
    return seen
