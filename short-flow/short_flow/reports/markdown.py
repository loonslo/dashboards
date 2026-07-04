def decision_markdown(report):
    lines = [
        f"{report['session_name']} short-flow",
        "",
        f"市场状态：{report['market_regime']['regime']}",
        f"今日策略：最大训练仓敞口 {report['trading_permission']['max_exposure_pct']:.0%}，主题ETF{'启用' if report['trading_permission']['theme_enabled'] else '关闭'}",
        "",
        "可观察：",
    ]
    for item in report.get("focus_watch", []):
        lines.extend([
            f"1. {item['code']} {item['name']}",
            f"   原因：{item['reason']}",
            f"   触发：{item['trigger']}",
            f"   失败：{item['failure']}",
        ])
    if not report.get("focus_watch"):
        lines.append("无")
    lines.append("")
    lines.append("等待：")
    for item in report.get("wait", []):
        lines.append(f"1. {item['code']} {item['name']}：{item['reason']}")
    if not report.get("wait"):
        lines.append("无")
    lines.append("")
    lines.append("今日不碰：")
    for item in report.get("exclude", []):
        lines.append(f"1. {item['code']} {item['name']}：{item['reason']}")
    if not report.get("exclude"):
        lines.append("无")
    return "\n".join(lines) + "\n"

