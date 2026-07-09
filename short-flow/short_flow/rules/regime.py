# Hysteresis buffer: once in a regime, thresholds relax by this amount
# before exiting, preventing flicker around boundary values.
# e.g. TREND_UP entry requires above_ma20 > 0.60; exit requires < 0.55.
_HYST = 0.05


def classify_regime(above_ma20_ratio, ma20_slope_positive_ratio, inflow_positive_ratio,
                    previous_regime=None):
    """Classify market regime with optional hysteresis.

    Args:
        previous_regime: yesterday's regime string, or None for first run.
        When provided, exit thresholds are buffered by _HYST to prevent
        oscillation (e.g. TREND_UP ↔ RANGE at the 0.60 boundary).
    """
    is_prev = lambda r: previous_regime == r

    # ── TREND_UP ──
    entry_up = (above_ma20_ratio > 0.60 and ma20_slope_positive_ratio > 0.55)
    stay_up = is_prev("TREND_UP") and (
        above_ma20_ratio > 0.60 - _HYST and ma20_slope_positive_ratio > 0.55 - _HYST
    )
    if entry_up or stay_up:
        return "TREND_UP"

    # ── TREND_DOWN ──
    entry_down = above_ma20_ratio < 0.30
    stay_down = is_prev("TREND_DOWN") and above_ma20_ratio < 0.30 + _HYST
    if entry_down or stay_down:
        return "TREND_DOWN"

    # ── RECOVERY ──
    entry_rec = above_ma20_ratio > 0.50 and inflow_positive_ratio > 0.45
    stay_rec = is_prev("RECOVERY") and (
        above_ma20_ratio > 0.50 - _HYST and inflow_positive_ratio > 0.45 - _HYST
    )
    if entry_rec or stay_rec:
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

