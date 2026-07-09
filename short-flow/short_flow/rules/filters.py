THEME_TRAIN_CATEGORIES = {"THEME", "SECTOR", "DEFENSE"}

# v0.2: entry patterns that bypass the above_ma5 check — these patterns
# are defined by being below MA5 (e.g. pullback to MA20), so requiring
# above_ma5 would make them dead code.
PULLBACK_PATTERNS = {"A_PULLBACK_WATCH"}


def hard_filter(master, snapshot, indicator, config, entry_pattern=None):
    filters = config["filters"]
    category = master.get("category")
    allowed = {
        item.strip()
        for item in str(config["features"].get("allowed_train_categories", "CORE,GROWTH")).split(",")
        if item.strip()
    }
    if config["features"].get("theme_enabled"):
        allowed.update(THEME_TRAIN_CATEGORIES)
    if master.get("is_money") or master.get("is_bond"):
        return "exclude", "货币/债券类不适合训练仓短线"
    if category not in allowed:
        return "exclude", f"{category}不在v0.1训练仓交易范围"
    if category == "THEME" and not config["features"].get("theme_enabled"):
        return "exclude", "主题ETF默认关闭"
    if snapshot.get("amount") is not None and snapshot["amount"] < filters["min_amount"]:
        return "exclude", "成交额低于阈值"
    if filters.get("require_main_inflow_positive") and (snapshot.get("main_inflow") or 0) <= 0:
        return "wait", "主力资金未转正"
    if (snapshot.get("main_inflow_pct") or 0) < filters["min_main_inflow_pct"]:
        return "wait", "主力流入强度不足"
    if indicator.get("above_ma10") == 0:
        return "exclude", "跌破MA10"
    # 回踩模式：above_ma20=1 且 above_ma5=0 是其定义特征，
    # 跳过 above_ma5 检查，否则回踩标的永远过不了硬过滤。
    # v0.2: 额外要求 ma20 斜率向上——横盘阴跌中回踩 MA20 是死猫反弹，不是买点。
    if entry_pattern in PULLBACK_PATTERNS:
        if indicator.get("above_ma20") == 0:
            return "exclude", "回踩模式要求站上MA20"
        if indicator.get("ma20_slope_positive") == 0:
            return "wait", "回踩模式要求MA20斜率向上"
        return "candidate", f"通过硬过滤（回踩模式）"
    if indicator.get("above_ma5") == 0:
        return "wait", "未站回MA5"
    return "candidate", "通过硬过滤"


def score_direction(snapshot, indicator):
    pct = snapshot.get("pct") or 0
    inflow_pct = snapshot.get("main_inflow_pct") or 0
    ret20 = indicator.get("ret20") or 0
    structure = 0
    structure += 10 if indicator.get("above_ma5") else 0
    structure += 10 if indicator.get("above_ma10") else 0
    structure += 10 if indicator.get("above_ma20") else 0
    relative_strength = max(min(pct, 10), -10) * 4
    flow_strength = max(min(inflow_pct, 20), -20) * 1.5
    technical = structure + max(min(ret20, 20), -20) * 0.5
    return round(relative_strength * 0.4 + flow_strength * 0.3 + technical * 0.3, 2)


