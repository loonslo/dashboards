def initial_state(session_name, candidates, excluded, regime, train_rules):
    return {
        "session_name": session_name,
        "market_context": regime,
        "train_rules": train_rules,
        "candidates": candidates,
        "excluded": excluded,
        "decisions": {"watch": [], "wait": [], "avoid": []},
        "report": "",
    }

