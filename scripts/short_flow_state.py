#!/usr/bin/env python3
"""Export/restore the ignored short-flow SQLite DB as a Git-friendly SQL snapshot."""

import argparse
import contextlib
import os
import pathlib
import sqlite3
import tempfile


ROOT = pathlib.Path(__file__).resolve().parents[1]
DEFAULT_DB = ROOT / "short-flow" / "data" / "short_flow.db"
DEFAULT_STATE = ROOT / "short-flow" / "state" / "short_flow.sql"


def display_path(path):
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def export_state(db_path, state_path):
    if not db_path.is_file():
        raise FileNotFoundError(f"database does not exist: {db_path}")
    state_path.parent.mkdir(parents=True, exist_ok=True)
    with contextlib.closing(sqlite3.connect(db_path)) as conn:
        conn.execute("PRAGMA wal_checkpoint(FULL)")
        dump = "\n".join(conn.iterdump()) + "\n"
    with tempfile.NamedTemporaryFile(
        "w",
        encoding="utf-8",
        newline="\n",
        dir=state_path.parent,
        delete=False,
    ) as handle:
        handle.write(dump)
        temporary = pathlib.Path(handle.name)
    os.replace(temporary, state_path)
    print(f"exported SQLite state: {display_path(state_path)} ({state_path.stat().st_size} bytes)")


def restore_state(state_path, db_path, force=False):
    if not state_path.is_file():
        print(f"no persisted state yet: {display_path(state_path)}; starting with a new database")
        return False
    if db_path.exists() and not force:
        print(f"database already exists, keeping persistent copy: {display_path(db_path)}")
        return False
    db_path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=db_path.parent, suffix=".db", delete=False) as handle:
        temporary = pathlib.Path(handle.name)
    try:
        script = state_path.read_text(encoding="utf-8")
        with contextlib.closing(sqlite3.connect(temporary)) as conn:
            conn.executescript(script)
            integrity = conn.execute("PRAGMA integrity_check").fetchone()[0]
            if integrity != "ok":
                raise RuntimeError(f"restored database failed integrity check: {integrity}")
        os.replace(temporary, db_path)
    finally:
        if temporary.exists():
            temporary.unlink()
    print(f"restored SQLite state: {display_path(state_path)} -> {display_path(db_path)}")
    return True


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("export", "restore"))
    parser.add_argument("--db", type=pathlib.Path, default=DEFAULT_DB)
    parser.add_argument("--state", type=pathlib.Path, default=DEFAULT_STATE)
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    if args.action == "export":
        export_state(args.db.resolve(), args.state.resolve())
    else:
        restore_state(args.state.resolve(), args.db.resolve(), force=args.force)


if __name__ == "__main__":
    main()
