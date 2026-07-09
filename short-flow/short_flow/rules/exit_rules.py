"""Exit rules: regime-level exit queue + position-level stop checks.

v0.2: Added individual position stop-loss logic (MA5/MA10 breach, flow
reversal, time stop, trailing stop). Previously only TREND_DOWN
portfolio-wide exit existed — individual stops were text-only in
failure_condition strings with no code tracking them.
"""

import datetime as dt


def build_exit_queue(regime, open_trades, config):
    """TREND_DOWN whole-portfolio exit: all positions must exit within N days."""
    if regime != "TREND_DOWN":
        return []
    exit_days = config["regime"].get("trend_down_exit_days", 3)
    return [
        {
            "code": trade.get("code"),
            "name": trade.get("name"),
            "plan": f"{exit_days}个交易日内有序退出",
            "expected_exit_price": trade.get("entry_price"),
            "actual_exit_price": trade.get("exit_price"),
            "slippage": None,
        }
        for trade in open_trades
    ]


def check_position_stops(open_trades, indicators, snapshots, config, trade_date=None):
    """Check each open position against individual stop conditions.

    Returns a list of stop alerts. Does NOT modify the database — the
    caller decides whether to update trade_log.

    Stop conditions (checked in order, first hit wins):
      1. 跌破MA10 — hard stop, structural damage
      2. 跌破MA5 — soft stop, short-term momentum lost
      3. 主力资金连续流出 — flow reversal
      4. 持仓时间止损 — held too long without follow-through
      5. 移动止盈回撤 — trailing stop from peak (if implemented)
    """
    trade_date = trade_date or dt.date.today().isoformat()
    stops = []
    max_hold_days = config.get("exit_params", {}).get("max_hold_days", 20)
    trailing_pct = config.get("exit_params", {}).get("trailing_stop_pct", 5.0)

    for trade in open_trades:
        code = trade.get("code")
        name = trade.get("name") or code
        entry_price = trade.get("entry_price")
        entry_date = trade.get("entry_date")

        ind = indicators.get(code) or {}
        snap = snapshots.get(code) or {}

        close = snap.get("price")
        ma5 = ind.get("ma5")
        ma10 = ind.get("ma10")
        ma20 = ind.get("ma20")
        main_inflow = snap.get("main_inflow")

        if close is None:
            continue

        # 1. Hard stop: below MA10
        if ma10 is not None and close < ma10:
            stops.append({
                "code": code,
                "name": name,
                "level": "hard_stop",
                "reason": f"跌破MA10({ma10:.2f})，当前{close:.2f}，结构破坏",
                "action": "exit_full",
                "entry_price": entry_price,
                "exit_price": close,
                "pnl_pct": round((close / entry_price - 1) * 100, 2) if entry_price else None,
            })
            continue

        # 2. Soft stop: below MA5
        if ma5 is not None and close < ma5:
            stops.append({
                "code": code,
                "name": name,
                "level": "soft_stop",
                "reason": f"跌破MA5({ma5:.2f})，当前{close:.2f}，短线动量丧失",
                "action": "reduce_half_or_exit",
                "entry_price": entry_price,
                "exit_price": close,
                "pnl_pct": round((close / entry_price - 1) * 100, 2) if entry_price else None,
            })
            continue

        # 3. Flow reversal: main_inflow turns negative
        if main_inflow is not None and main_inflow < 0:
            stops.append({
                "code": code,
                "name": name,
                "level": "flow_warning",
                "reason": f"主力资金转负({main_inflow:.0f})，关注持续性",
                "action": "monitor_close",
                "entry_price": entry_price,
                "exit_price": close,
                "pnl_pct": round((close / entry_price - 1) * 100, 2) if entry_price else None,
            })
            continue

        # 4. Time stop: held too long
        if entry_date:
            try:
                held_days = (dt.date.fromisoformat(str(trade_date))
                             - dt.date.fromisoformat(str(entry_date))).days
            except (ValueError, TypeError):
                held_days = None
            if held_days is not None and held_days >= max_hold_days:
                stops.append({
                    "code": code,
                    "name": name,
                    "level": "time_stop",
                    "reason": f"持仓{held_days}天超过上限{max_hold_days}天，未走出趋势则退出",
                    "action": "exit_full",
                    "entry_price": entry_price,
                    "exit_price": close,
                    "pnl_pct": round((close / entry_price - 1) * 100, 2) if entry_price else None,
                })
                continue

        # 5. Trailing stop: drawdown from position peak
        mfe = trade.get("mfe")
        if mfe is not None and mfe > 0 and close < mfe * (1 - trailing_pct / 100):
            stops.append({
                "code": code,
                "name": name,
                "level": "trailing_stop",
                "reason": f"从持仓高点{mfe:.2f}回撤超过{trailing_pct}%，当前{close:.2f}",
                "action": "exit_full",
                "entry_price": entry_price,
                "exit_price": close,
                "pnl_pct": round((close / entry_price - 1) * 100, 2) if entry_price else None,
            })
            continue

    return stops


def compute_mfe_mfe_update(open_trades, snapshots):
    """Update MFE (Maximum Favorable Excursion) for open positions.

    Returns dict {code: new_mfe} for positions where current price
    exceeds the recorded MFE.
    """
    updates = {}
    for trade in open_trades:
        code = trade.get("code")
        snap = snapshots.get(code) or {}
        current = snap.get("price")
        if current is None:
            continue
        current_mfe = trade.get("mfe") or 0
        if current > current_mfe:
            updates[code] = current
    return updates
