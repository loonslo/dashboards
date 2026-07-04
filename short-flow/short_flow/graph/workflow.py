from .nodes import rule_only_judge


def run_workflow(state, use_llm=False):
    if use_llm:
        return run_langgraph_workflow(state)
    return rule_only_judge(state)


def run_langgraph_workflow(state):
    """Run the decision flow through LangGraph when the optional dependency exists."""
    try:
        from langgraph.graph import END, StateGraph
    except ImportError:
        state["workflow_note"] = "LangGraph not installed; used rule-only fallback."
        return rule_only_judge(state)

    graph = StateGraph(dict)
    graph.add_node("hard_rule_judge", rule_only_judge)
    graph.set_entry_point("hard_rule_judge")
    graph.add_edge("hard_rule_judge", END)
    app = graph.compile()
    result = app.invoke(state)
    result["workflow_note"] = "LangGraph workflow executed with rule-only judge node."
    return result

