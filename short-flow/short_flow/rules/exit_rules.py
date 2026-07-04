def build_exit_queue(regime, open_trades, config):
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

