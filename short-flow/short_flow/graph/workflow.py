from .nodes import rule_only_judge


def run_workflow(state, use_llm=False):
    # v0.1 intentionally avoids model calls. v0.2 will replace this with LangGraph.
    return rule_only_judge(state)

