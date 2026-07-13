#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Local API server for dashboard data, watchlists, and refresh workflows."""

import datetime as dt
import hmac
import importlib
import json
import os
import pathlib
import re
import sqlite3
import subprocess
import sys
import tempfile
import urllib.parse
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


ROOT = pathlib.Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "server_data"
DB_PATH = pathlib.Path(os.environ.get("DASHBOARD_API_DB", DATA_DIR / "dashboard_api.db"))
HOST = os.environ.get("DASHBOARD_API_HOST", "127.0.0.1")
PORT = int(os.environ.get("DASHBOARD_API_PORT", "8787"))
API_TOKEN = os.environ.get("DASHBOARD_API_TOKEN", "").strip()
ALLOWED_ORIGINS = {
    value.strip().rstrip("/")
    for value in os.environ.get("DASHBOARD_API_ALLOWED_ORIGINS", "").split(",")
    if value.strip()
}
MAX_BODY_BYTES = int(os.environ.get("DASHBOARD_API_MAX_BODY_BYTES", str(64 * 1024)))
LOOPBACK_HOSTS = {"127.0.0.1", "localhost", "::1"}

DASHBOARDS = {
    "index-decision": {
        "label": "投资观察看板",
        "watchlist": ROOT / "dashboards" / "index-decision" / "watchlist_v1.json",
        "latest": ROOT / "dashboards" / "index-decision" / "dashboard_latest.json",
        "history": ROOT / "dashboards" / "index-decision" / "history",
        "key": "ticker",
    },
    "short-flow": {
        "label": "A股短线资金跟随",
        "watchlist": ROOT / "dashboards" / "short-flow" / "watchlist_v1.json",
        "latest": ROOT / "dashboards" / "short-flow" / "dashboard_latest.json",
        "history": ROOT / "dashboards" / "short-flow" / "history",
        "key": "code",
    },
    "etf-pool": {
        "label": "ETF训练仓",
        "latest": ROOT / "dashboards" / "short-flow" / "etf_pool_latest.json",
    },
}
SHORT_FLOW_CONFIG = ROOT / "short-flow" / "config.yaml"

SCHEMA = """
CREATE TABLE IF NOT EXISTS watchlist_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dashboard TEXT NOT NULL,
  item_key TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(dashboard, item_key)
);

CREATE TABLE IF NOT EXISTS dashboard_snapshots (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dashboard TEXT NOT NULL,
  asof TEXT,
  payload_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_watchlist_dashboard_active
  ON watchlist_items(dashboard, active, sort_order, item_key);

CREATE INDEX IF NOT EXISTS idx_snapshot_dashboard_id
  ON dashboard_snapshots(dashboard, id);
"""


def now_text():
    return dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def connect():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    with connect() as conn:
        conn.executescript(SCHEMA)
        conn.commit()
        seed_watchlists(conn)


def load_json(path, default=None):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return default


def write_json(path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def load_short_flow_config():
    sys.path.insert(0, str(ROOT / "short-flow"))
    from short_flow.config import load_config

    return load_config(SHORT_FLOW_CONFIG)


def yaml_scalar(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    return json.dumps(str(value), ensure_ascii=False)


def yaml_lines(data, indent=0):
    lines = []
    pad = " " * indent
    for key, value in data.items():
        if isinstance(value, dict):
            lines.append(f"{pad}{key}:")
            lines.extend(yaml_lines(value, indent + 2))
        else:
            lines.append(f"{pad}{key}: {yaml_scalar(value)}")
    return lines


def save_short_flow_config(payload):
    current = load_short_flow_config()
    sys.path.insert(0, str(ROOT / "short-flow"))
    from short_flow.config import deep_merge

    allowed = {"capital", "features", "regime", "filters", "entry_params", "schedule"}
    updates = {key: value for key, value in payload.items() if key in allowed and isinstance(value, dict)}
    merged = deep_merge(current, updates)
    SHORT_FLOW_CONFIG.write_text("\n".join(yaml_lines(merged)) + "\n", encoding="utf-8")
    return merged


def item_key(dashboard, item):
    field = DASHBOARDS[dashboard]["key"]
    key = str(item.get(field) or "").strip()
    if not key:
        raise ValueError(f"missing required field: {field}")
    return key.upper() if field == "ticker" else key


def seed_watchlists(conn):
    for dashboard, cfg in DASHBOARDS.items():
        if "watchlist" not in cfg:
            continue
        existing = conn.execute(
            "SELECT COUNT(*) AS n FROM watchlist_items WHERE dashboard=?",
            (dashboard,),
        ).fetchone()["n"]
        if existing:
            continue
        payload = load_json(cfg["watchlist"], {"items": []})
        items = payload.get("items", payload) if isinstance(payload, dict) else payload
        for index, item in enumerate(items or []):
            key = item_key(dashboard, item)
            ts = now_text()
            conn.execute(
                """
                INSERT OR REPLACE INTO watchlist_items
                  (dashboard, item_key, payload_json, active, sort_order, created_at, updated_at)
                VALUES (?, ?, ?, 1, ?, ?, ?)
                """,
                (dashboard, key, json.dumps(item, ensure_ascii=False), index, ts, ts),
            )
        conn.commit()


def active_watchlist(conn, dashboard):
    if dashboard not in DASHBOARDS or "watchlist" not in DASHBOARDS[dashboard]:
        raise KeyError("unknown watchlist dashboard")
    rows = conn.execute(
        """
        SELECT payload_json FROM watchlist_items
        WHERE dashboard=? AND active=1
        ORDER BY sort_order, item_key
        """,
        (dashboard,),
    ).fetchall()
    return [json.loads(row["payload_json"]) for row in rows]


def export_watchlist(conn, dashboard, target=None):
    items = active_watchlist(conn, dashboard)
    payload = {"items": items}
    if target is None:
        target = DASHBOARDS[dashboard]["watchlist"]
    write_json(pathlib.Path(target), payload)
    return pathlib.Path(target)


def snapshot_payload(conn, dashboard, payload):
    conn.execute(
        """
        INSERT INTO dashboard_snapshots (dashboard, asof, payload_json, created_at)
        VALUES (?, ?, ?, ?)
        """,
        (
            dashboard,
            payload.get("asof") or payload.get("generated_at") or payload.get("trade_date"),
            json.dumps(payload, ensure_ascii=False),
            now_text(),
        ),
    )
    conn.commit()


def payload_time(payload):
    if not isinstance(payload, dict):
        return None
    for key in ("asof", "generated_at", "trade_date"):
        value = str(payload.get(key) or "").strip()
        if not value:
            continue
        for text, fmt in (
            (value[:19], "%Y-%m-%d %H:%M:%S"),
            (value[:16], "%Y-%m-%d %H:%M"),
            (value[:10], "%Y-%m-%d"),
        ):
            try:
                return dt.datetime.strptime(text, fmt)
            except ValueError:
                pass
        try:
            parsed = dt.datetime.fromisoformat(value.replace("Z", "+00:00"))
            return parsed.replace(tzinfo=None)
        except ValueError:
            pass
    return None


def latest_payload(conn, dashboard):
    row = conn.execute(
        """
        SELECT payload_json FROM dashboard_snapshots
        WHERE dashboard=?
        ORDER BY id DESC
        LIMIT 1
        """,
        (dashboard,),
    ).fetchone()
    path = DASHBOARDS[dashboard]["latest"]
    file_payload = load_json(path, {})
    if not row:
        return file_payload
    db_payload = json.loads(row["payload_json"])
    file_time = payload_time(file_payload)
    db_time = payload_time(db_payload)
    if file_payload and file_time and (not db_time or file_time > db_time):
        return file_payload
    return db_payload


def update_history(cfg, payload):
    history = cfg.get("history")
    if not history:
        return
    # Key history by date AND session (when present) so twice-daily short-flow
    # refreshes (e.g. 0940 intraday vs 1520 post-close) don't overwrite each
    # other. The index lists every archived file in chronological order.
    today = dt.date.today().isoformat()
    session = str(payload.get("session") or "").strip()
    suffix = f"-{session}" if session else ""
    target = history / f"{today}{suffix}.json"
    write_json(target, payload)
    dates = sorted(
        path.stem for path in history.glob("*.json") if path.name != "index.json"
    )
    write_json(history / "index.json", dates)


def run_index_decision_refresh(conn):
    module = importlib.import_module("scripts.index_decision_dashboard")
    with tempfile.TemporaryDirectory(dir=DATA_DIR) as tmp:
        watchlist_path = pathlib.Path(tmp) / "watchlist.json"
        export_watchlist(conn, "index-decision", watchlist_path)
        payload = module.collect_dashboard(watchlist_path=str(watchlist_path))
    cfg = DASHBOARDS["index-decision"]
    write_json(cfg["latest"], payload)
    update_history(cfg, payload)
    snapshot_payload(conn, "index-decision", payload)
    return payload


def run_short_flow_refresh(conn):
    module = importlib.import_module("scripts.short_flow_dashboard")
    with tempfile.TemporaryDirectory(dir=DATA_DIR) as tmp:
        watchlist_path = pathlib.Path(tmp) / "watchlist.json"
        export_watchlist(conn, "short-flow", watchlist_path)
        payload = module.collect_dashboard(str(watchlist_path))
        payload = module.apply_previous_snapshot(payload, module.load_previous_snapshot(DASHBOARDS["short-flow"]["latest"]))
    cfg = DASHBOARDS["short-flow"]
    write_json(cfg["latest"], payload)
    update_history(cfg, payload)
    snapshot_payload(conn, "short-flow", payload)
    return payload


def run_etf_pool_refresh(conn):
    command = [sys.executable, str(ROOT / "short-flow" / "scripts" / "daily_job.py"), "--session", "0940"]
    subprocess.run(command, cwd=ROOT, check=True)
    payload = load_json(DASHBOARDS["etf-pool"]["latest"], {})
    snapshot_payload(conn, "etf-pool", payload)
    return payload


def refresh_dashboard(conn, dashboard):
    if dashboard == "index-decision":
        return run_index_decision_refresh(conn)
    if dashboard == "short-flow":
        return run_short_flow_refresh(conn)
    if dashboard == "etf-pool":
        return run_etf_pool_refresh(conn)
    raise KeyError("unknown dashboard")


def upsert_watchlist_item(conn, dashboard, item):
    key = item_key(dashboard, item)
    ts = now_text()
    max_order = conn.execute(
        "SELECT COALESCE(MAX(sort_order), -1) AS n FROM watchlist_items WHERE dashboard=?",
        (dashboard,),
    ).fetchone()["n"]
    conn.execute(
        """
        INSERT INTO watchlist_items
          (dashboard, item_key, payload_json, active, sort_order, created_at, updated_at)
        VALUES (?, ?, ?, 1, ?, ?, ?)
        ON CONFLICT(dashboard, item_key) DO UPDATE SET
          payload_json=excluded.payload_json,
          active=1,
          updated_at=excluded.updated_at
        """,
        (dashboard, key, json.dumps(item, ensure_ascii=False), max_order + 1, ts, ts),
    )
    conn.commit()
    export_watchlist(conn, dashboard)
    return {"item_key": key, "item": item}


def delete_watchlist_item(conn, dashboard, key):
    conn.execute(
        "UPDATE watchlist_items SET active=0, updated_at=? WHERE dashboard=? AND item_key=?",
        (now_text(), dashboard, key.upper() if dashboard == "index-decision" else key),
    )
    conn.commit()
    export_watchlist(conn, dashboard)
    return {"deleted": key}


def read_body(handler):
    try:
        length = int(handler.headers.get("Content-Length") or 0)
    except ValueError as exc:
        raise ValueError("invalid Content-Length") from exc
    if length <= 0:
        return {}
    if length > MAX_BODY_BYTES:
        raise ValueError(f"request body exceeds {MAX_BODY_BYTES} bytes")
    raw = handler.rfile.read(length).decode("utf-8")
    return json.loads(raw or "{}")


class ApiHandler(SimpleHTTPRequestHandler):
    server_version = "DashboardApi/0.1"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def log_message(self, fmt, *args):
        sys.stderr.write("[%s] %s\n" % (now_text(), fmt % args))

    def cors_origin(self):
        origin = (self.headers.get("Origin") or "").rstrip("/")
        if not origin:
            return None
        if origin in ALLOWED_ORIGINS:
            return origin
        if not ALLOWED_ORIGINS and HOST in LOOPBACK_HOSTS:
            return origin
        return None

    def send_cors_headers(self):
        origin = self.cors_origin()
        if origin:
            self.send_header("Access-Control-Allow-Origin", origin)
            self.send_header("Vary", "Origin")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization, X-API-Token")

    def write_authorized(self):
        if not API_TOKEN:
            return HOST in LOOPBACK_HOSTS
        bearer = self.headers.get("Authorization") or ""
        supplied = bearer[7:].strip() if bearer.startswith("Bearer ") else self.headers.get("X-API-Token", "").strip()
        return bool(supplied) and hmac.compare_digest(supplied, API_TOKEN)

    def require_write_auth(self):
        if self.write_authorized():
            return True
        self.send_error_json(401, "authentication required")
        return False

    def send_json(self, payload, status=200):
        body = json.dumps(payload, ensure_ascii=False, indent=2).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Cache-Control", "no-store")
        self.send_cors_headers()
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def send_json_head(self, payload, status=200):
        body = json.dumps(payload, ensure_ascii=False, indent=2).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Cache-Control", "no-store")
        self.send_cors_headers()
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()

    def send_error_json(self, status, message):
        self.send_json({"error": message}, status=status)

    def do_OPTIONS(self):
        if self.headers.get("Origin") and not self.cors_origin():
            return self.send_error_json(403, "origin not allowed")
        self.send_response(204)
        self.send_cors_headers()
        self.end_headers()

    def route_parts(self):
        parsed = urllib.parse.urlparse(self.path)
        parts = [urllib.parse.unquote(part) for part in parsed.path.strip("/").split("/") if part]
        return parsed, parts

    def do_GET(self):
        parsed, parts = self.route_parts()
        if not parts or parts[0] != "api":
            return super().do_GET()
        try:
            with connect() as conn:
                if parts == ["api", "health"]:
                    return self.send_json({"ok": True, "time": now_text()})
                if parts == ["api", "dashboards"]:
                    rows = []
                    for key, cfg in DASHBOARDS.items():
                        count = 0
                        if "watchlist" in cfg:
                            count = conn.execute(
                                "SELECT COUNT(*) AS n FROM watchlist_items WHERE dashboard=? AND active=1",
                                (key,),
                            ).fetchone()["n"]
                        rows.append({"id": key, "label": cfg["label"], "watchlist_count": count})
                    return self.send_json({"dashboards": rows})
                if len(parts) == 3 and parts[:2] == ["api", "watchlists"]:
                    dashboard = parts[2]
                    return self.send_json({"dashboard": dashboard, "items": active_watchlist(conn, dashboard)})
                if len(parts) == 3 and parts[:2] == ["api", "latest"]:
                    dashboard = parts[2]
                    return self.send_json(latest_payload(conn, dashboard))
                if parts == ["api", "config", "short-flow"]:
                    return self.send_json(load_short_flow_config())
                if len(parts) == 5 and parts[:3] == ["api", "report", "short-flow"]:
                    trade_date, session = parts[3], parts[4]
                    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", trade_date) or not re.fullmatch(r"\d{4}", session):
                        return self.send_error_json(400, "invalid report path")
                    report_path = ROOT / "dashboards" / "short-flow" / "reports" / trade_date / f"{session}.json"
                    report = load_json(report_path)
                    if report is None:
                        return self.send_error_json(404, "report not found")
                    return self.send_json(report)
            return self.send_error_json(404, "not found")
        except Exception as exc:
            return self.send_error_json(500, str(exc))

    def do_HEAD(self):
        parsed, parts = self.route_parts()
        if not parts or parts[0] != "api":
            return super().do_HEAD()
        try:
            with connect() as conn:
                if parts == ["api", "health"]:
                    return self.send_json_head({"ok": True, "db": str(DB_PATH), "time": now_text()})
                if len(parts) == 3 and parts[:2] == ["api", "latest"]:
                    return self.send_json_head(latest_payload(conn, parts[2]))
                if len(parts) == 3 and parts[:2] == ["api", "watchlists"]:
                    dashboard = parts[2]
                    return self.send_json_head({"dashboard": dashboard, "items": active_watchlist(conn, dashboard)})
                if parts == ["api", "config", "short-flow"]:
                    return self.send_json_head(load_short_flow_config())
            return self.send_json_head({"error": "not found"}, status=404)
        except Exception as exc:
            return self.send_json_head({"error": str(exc)}, status=500)

    def do_POST(self):
        parsed, parts = self.route_parts()
        if not parts or parts[0] != "api":
            return self.send_error_json(404, "not found")
        if not self.require_write_auth():
            return
        try:
            payload = read_body(self)
            with connect() as conn:
                if len(parts) == 3 and parts[:2] == ["api", "watchlists"]:
                    return self.send_json(upsert_watchlist_item(conn, parts[2], payload), status=201)
                if len(parts) == 3 and parts[:2] == ["api", "refresh"]:
                    result = refresh_dashboard(conn, parts[2])
                    return self.send_json({"dashboard": parts[2], "result": result})
                if parts == ["api", "config", "short-flow"]:
                    return self.send_json(save_short_flow_config(payload))
            return self.send_error_json(404, "not found")
        except ValueError as exc:
            return self.send_error_json(400, str(exc))
        except KeyError as exc:
            return self.send_error_json(404, str(exc))
        except Exception as exc:
            return self.send_error_json(500, str(exc))

    def do_DELETE(self):
        parsed, parts = self.route_parts()
        if len(parts) != 4 or parts[:2] != ["api", "watchlists"]:
            return self.send_error_json(404, "not found")
        if not self.require_write_auth():
            return
        try:
            with connect() as conn:
                return self.send_json(delete_watchlist_item(conn, parts[2], parts[3]))
        except Exception as exc:
            return self.send_error_json(500, str(exc))


def main():
    sys.path.insert(0, str(ROOT))
    if HOST not in LOOPBACK_HOSTS and not API_TOKEN:
        raise SystemExit("DASHBOARD_API_TOKEN is required when API listens on a non-loopback host")
    if HOST not in LOOPBACK_HOSTS and not ALLOWED_ORIGINS:
        raise SystemExit("DASHBOARD_API_ALLOWED_ORIGINS is required when API listens on a non-loopback host")
    init_db()
    server = ThreadingHTTPServer((HOST, PORT), ApiHandler)
    print(f"Dashboard API listening on http://{HOST}:{PORT}/")
    server.serve_forever()


if __name__ == "__main__":
    main()
