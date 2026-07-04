import copy
import pathlib


DEFAULT_CONFIG = {
    "capital": {
        "train_capital": 30000,
        "max_total_exposure_pct": 0.40,
        "first_entry_ratio": 0.33,
        "max_single_etf_pct": 0.20,
    },
    "features": {
        "theme_enabled": False,
        "use_llm": False,
        "use_n8n": False,
        "allowed_train_categories": "CORE,GROWTH",
    },
    "regime": {
        "trend_down_exit_days": 3,
        "trend_up": {"max_exposure_pct": 0.40, "max_positions": 3},
        "recovery": {"max_exposure_pct": 0.25, "max_positions": 2},
        "range": {"max_exposure_pct": 0.15, "max_positions": 1},
        "trend_down": {"max_exposure_pct": 0.0, "max_positions": 0},
    },
    "filters": {
        "min_amount": 50000000,
        "min_main_inflow_pct": 3.0,
        "require_main_inflow_positive": True,
    },
    "entry_params": {
        "version": "v0.1_assumption_not_backtested",
        "breakout_threshold_pct": 0.3,
        "volume_surge_ratio": 1.3,
        "pullback_ma_tolerance_pct": 0.5,
    },
    "schedule": {
        "premarket": "08:50",
        "morning_confirm": "09:40",
        "noon_review": "11:30",
        "tail_review": "14:30",
        "after_close": "15:20",
    },
}


def deep_merge(base, updates):
    result = copy.deepcopy(base)
    for key, value in updates.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = deep_merge(result[key], value)
        else:
            result[key] = value
    return result


def parse_scalar(value):
    value = value.strip()
    if value.lower() in ("true", "false"):
        return value.lower() == "true"
    if value.startswith('"') and value.endswith('"'):
        return value[1:-1]
    try:
        if "." in value:
            return float(value)
        return int(value)
    except ValueError:
        return value


def parse_simple_yaml(text):
    root = {}
    stack = [(0, root)]
    for raw in text.splitlines():
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        line = raw.strip()
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip()
        while stack and indent < stack[-1][0]:
            stack.pop()
        parent = stack[-1][1]
        if value == "":
            child = {}
            parent[key] = child
            stack.append((indent + 2, child))
        else:
            parent[key] = parse_scalar(value)
    return root


def load_config(path):
    path = pathlib.Path(path)
    if not path.exists():
        return copy.deepcopy(DEFAULT_CONFIG)
    return deep_merge(DEFAULT_CONFIG, parse_simple_yaml(path.read_text(encoding="utf-8")))


