def classify_entry_pattern(indicator):
    if indicator.get("above_ma20") and not indicator.get("above_ma5"):
        return "A_PULLBACK_WATCH"
    if indicator.get("above_ma5") and (indicator.get("amount_ratio_20") or 0) >= 1.3:
        return "B_PLATFORM_BREAKOUT_WATCH"
    return "OBSERVE_ONLY"


