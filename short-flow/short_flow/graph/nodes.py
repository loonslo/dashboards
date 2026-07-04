def rule_only_judge(state):
    state["decisions"] = {
        "watch": state.get("candidates", [])[:3],
        "wait": state.get("candidates", [])[3:8],
        "avoid": state.get("excluded", [])[:8],
    }
    return state

