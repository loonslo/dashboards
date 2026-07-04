import argparse
import subprocess
import sys

from _bootstrap import ROOT


STEPS = [
    "fetch_etf_master.py",
    "fetch_snapshot.py",
    "compute_indicators.py",
    "compute_regime.py",
    "compute_signals.py",
    "run_llm_judge.py",
    "export_dashboard_json.py",
    "push_report.py",
]


def main():
    parser = argparse.ArgumentParser(description="Run short-flow v0.1 daily pipeline")
    parser.add_argument("--session", default="0940")
    parser.add_argument("--seed-only", action="store_true")
    args = parser.parse_args()
    for step in STEPS:
        command = [sys.executable, str(ROOT / "scripts" / step)]
        if step in ("compute_signals.py", "run_llm_judge.py", "export_dashboard_json.py"):
            command.extend(["--session", args.session])
        if step == "fetch_etf_master.py" and args.seed_only:
            command.append("--seed-only")
        print("$", " ".join(command))
        subprocess.run(command, check=True)


if __name__ == "__main__":
    main()

