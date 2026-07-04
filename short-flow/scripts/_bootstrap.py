import pathlib
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))


def default_db_path():
    return ROOT / "data" / "short_flow.db"


def default_config_path():
    return ROOT / "config.yaml"

