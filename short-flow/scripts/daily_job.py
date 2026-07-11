import argparse
import subprocess
import sys

from _bootstrap import ROOT


DATA_STEPS = [
    "fetch_etf_master.py",
    "fetch_snapshot.py",
    "compute_indicators.py",
    "compute_regime.py",
    "compute_signals.py",
    "run_llm_judge.py",
]

BACKTEST_STEPS = ["backtest.py"]
PUBLISH_STEPS = ["export_dashboard_json.py", "push_report.py"]


def run_step(step_name, extra_args=None):
    command = [sys.executable, str(ROOT / "scripts" / step_name)]
    if extra_args:
        command.extend(extra_args)
    print("$", " ".join(command))
    subprocess.run(command, check=True)


def main():
    parser = argparse.ArgumentParser(description="Run short-flow v0.1 daily pipeline")
    parser.add_argument("--session", default="0940")
    parser.add_argument("--seed-only", action="store_true")
    parser.add_argument("--skip-backtest", action="store_true",
                        help="Skip the backtest step (useful for non-close sessions)")
    args = parser.parse_args()

    session_args = ["--session", args.session]

    # 两段漏斗：盘中场次(0850/0940/1130/1430)各步骤只处理 T-1 短名单∪持仓∪基准，
    # regime 复用前一交易日并做崩盘检查；1520 盘后场次全市场扫描、产出次日短名单。
    for step in DATA_STEPS:
        extra = []
        if step in ("fetch_snapshot.py", "compute_indicators.py", "compute_regime.py", "compute_signals.py", "run_llm_judge.py"):
            extra = session_args
        if step == "fetch_etf_master.py" and args.seed_only:
            extra.append("--seed-only")
        run_step(step, extra)

    if not args.skip_backtest:
        for step in BACKTEST_STEPS:
            run_step(step)

    for step in PUBLISH_STEPS:
        extra = session_args if step == "export_dashboard_json.py" else []
        run_step(step, extra)


if __name__ == "__main__":
    main()

