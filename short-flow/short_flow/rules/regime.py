def classify_regime(above_ma20_ratio, ma20_slope_positive_ratio, inflow_5d_ratio):
    if above_ma20_ratio > 0.60 and ma20_slope_positive_ratio > 0.55:
        return "TREND_UP"
    if above_ma20_ratio < 0.30:
        return "TREND_DOWN"
    if above_ma20_ratio > 0.50 and inflow_5d_ratio > 0.45:
        return "RECOVERY"
    return "RANGE"


def permission_for(regime, config):
    key = regime.lower()
    rules = config["regime"].get(key, {})
    return {
        "can_open": regime != "TREND_DOWN",
        "max_exposure_pct": rules.get("max_exposure_pct", 0),
        "max_positions": rules.get("max_positions", 0),
        "theme_enabled": config["features"].get("theme_enabled", False),
        "daily_new_allowed": regime in ("TREND_UP", "RECOVERY"),
        "trend_down_exit_days": config["regime"].get("trend_down_exit_days", 3),
    }

