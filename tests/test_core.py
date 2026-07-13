import pathlib
import sqlite3
import sys
import tempfile
import unittest
import datetime as dt
import json
from unittest import mock


ROOT = pathlib.Path(__file__).resolve().parents[1]
SHORT_ROOT = ROOT / "short-flow"
SHORT_SCRIPTS = SHORT_ROOT / "scripts"
for path in (ROOT, SHORT_ROOT, SHORT_SCRIPTS):
    sys.path.insert(0, str(path))

import fetch_snapshot
import fetch_etf_master
import export_dashboard_json
import scripts.short_flow_state as short_flow_state
import scripts.validate_dashboards as validate_dashboards
from short_flow.db import connect, init_db
from short_flow.data_sources import eastmoney


class TradeDateTests(unittest.TestCase):
    def test_resolve_trade_date_uses_market_quorum(self):
        dates = {
            "510300": "2026-07-10",
            "510500": "2026-07-10",
            "510050": "2026-07-09",
        }

        def fake_klines(code, _limit):
            return [{"date": dates[code]}]

        with mock.patch.object(fetch_snapshot, "fetch_daily_klines", side_effect=fake_klines):
            self.assertEqual(
                fetch_snapshot.resolve_trade_date(list(dates)),
                "2026-07-10",
            )

    def test_resolve_trade_date_fails_without_market_dates(self):
        with mock.patch.object(fetch_snapshot, "fetch_daily_klines", return_value=[]):
            with self.assertRaises(RuntimeError):
                fetch_snapshot.resolve_trade_date(["510300"])


class TrainingUniverseTests(unittest.TestCase):
    @staticmethod
    def _master_item(code, name="ETF", category="CORE"):
        return {
            "code": code,
            "name": name,
            "market": "SH" if code.startswith("5") else "SZ",
            "category": category,
            "sub_category": "",
            "is_broad": 1 if category in ("CORE", "GROWTH") else 0,
            "is_theme": 1 if category == "THEME" else 0,
            "is_qdii": 0,
            "is_bond": 0,
            "is_money": 0,
        }

    def test_configured_categories_plus_manual_watchlist(self):
        api_items = [
            {"code": "510300", "category": "CORE"},
            {"code": "512000", "category": "SECTOR"},
            {"code": "512760", "category": "THEME"},
        ]
        seed_items = [{"code": "512000", "category": "SECTOR", "name": "手工观察"}]
        config = {
            "features": {
                "allowed_train_categories": "CORE,GROWTH",
                "theme_enabled": False,
            }
        }
        selected = fetch_etf_master.select_training_items(api_items, seed_items, config)
        by_code = {item["code"]: item for item in selected}
        self.assertEqual(set(by_code), {"510300", "512000"})
        self.assertEqual(by_code["512000"]["name"], "手工观察")

    def test_api_fallback_host_is_used(self):
        response = {
            "data": {
                "total": 1,
                "diff": [{"f12": "510300", "f14": "沪深300ETF"}],
            }
        }

        def fake_get_json(url):
            if "push2.eastmoney.com" in url:
                raise ValueError("primary returned invalid JSON")
            return response

        with mock.patch.object(eastmoney, "get_json", side_effect=fake_get_json):
            items = eastmoney.fetch_etf_list(max_pages=1)
        self.assertEqual([item["code"] for item in items], ["510300"])

    def test_incomplete_api_snapshot_is_rejected(self):
        response = {
            "data": {
                "total": 2,
                "diff": [{"f12": "510300", "f14": "沪深300ETF"}],
            }
        }
        with mock.patch.object(eastmoney, "get_json", return_value=response):
            with self.assertRaises(RuntimeError):
                eastmoney.fetch_etf_list(max_pages=1)

    def test_transient_api_failure_preserves_existing_active_rows(self):
        with tempfile.TemporaryDirectory() as temp:
            db_path = pathlib.Path(temp) / "master.db"
            init_db(db_path)
            existing = self._master_item("510300", "沪深300ETF")
            seed = self._master_item("159915", "创业板ETF", "GROWTH")
            fetch_etf_master.upsert_master(db_path, [existing])
            fetch_etf_master.upsert_master(
                db_path,
                [seed],
                deactivate_missing=False,
            )
            conn = connect(db_path)
            try:
                active = {
                    row["code"]
                    for row in conn.execute(
                        "SELECT code FROM etf_master WHERE status='active'"
                    )
                }
            finally:
                conn.close()
            self.assertEqual(active, {"510300", "159915"})


class EastmoneyTransportTests(unittest.TestCase):
    def test_curl_fallback_decodes_utf8_json(self):
        payload = '{"data":{"name":"沪深300ETF"}}'.encode("utf-8")
        completed = mock.Mock(stdout=payload)
        with mock.patch.object(
            eastmoney.urllib.request,
            "urlopen",
            side_effect=OSError("primary unavailable"),
        ), mock.patch.object(
            eastmoney.time,
            "sleep",
        ), mock.patch.object(
            eastmoney.shutil,
            "which",
            return_value="curl",
        ), mock.patch.object(
            eastmoney.subprocess,
            "run",
            return_value=completed,
        ):
            result = eastmoney.get_json("https://example.com/data", timeout=1)
        self.assertEqual(result["data"]["name"], "沪深300ETF")


class DashboardScopeTests(unittest.TestCase):
    def test_public_pages_keep_configuration_and_a_share_scopes_separate(self):
        root_html = (ROOT / "index.html").read_text(encoding="utf-8")
        index_html = (ROOT / "dashboards" / "index-decision" / "index.html").read_text(encoding="utf-8")
        short_html = (ROOT / "dashboards" / "short-flow" / "index.html").read_text(encoding="utf-8")

        for html in (root_html, index_html, short_html):
            self.assertNotIn("管理台", html)
            self.assertNotIn("../admin/", html)
        self.assertNotIn('id="short-flow-section"', index_html)
        self.assertNotIn("ETF训练仓", short_html)
        self.assertNotIn("交易日志", short_html)
        self.assertNotIn('data-filter="宽基"', short_html)

    def test_investment_watchlist_matches_declared_asset_scope(self):
        path = ROOT / "dashboards" / "index-decision" / "watchlist_v1.json"
        payload = json.loads(path.read_text(encoding="utf-8"))
        tickers = {item["ticker"] for item in payload["items"]}
        expected = {
            "VOO", "VT", "QQQ", "SPY", "SMH", "DRAM", "VGT",
            "MSFT", "NVDA", "AVGO", "AAPL", "AMZN", "GOOGL", "META",
            "512890.SH",
        }
        self.assertEqual(tickers, expected)
        cn_items = [item for item in payload["items"] if item["market"] == "CN"]
        self.assertEqual([item["ticker"] for item in cn_items], ["512890.SH"])


class SessionPersistenceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.db_path = pathlib.Path(self.temp.name) / "test.db"
        init_db(self.db_path)

    def tearDown(self):
        self.temp.cleanup()

    def insert_signal(self, conn, session, score):
        conn.execute(
            """
            INSERT INTO signal_result (
              ts, trade_date, session_name, code, name, group_name, score,
              rule_result, reason, entry_trigger, failure_condition
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                "2026-07-10 09:40",
                "2026-07-10",
                session,
                "510300",
                "沪深300ETF",
                "CORE",
                score,
                "candidate",
                "test",
                "trigger",
                "failure",
            ),
        )

    def test_sessions_do_not_overwrite_each_other(self):
        conn = connect(self.db_path)
        try:
            self.insert_signal(conn, "0940", 10)
            self.insert_signal(conn, "1520", 20)
            conn.commit()
            count = conn.execute("SELECT COUNT(*) FROM signal_result").fetchone()[0]
            self.assertEqual(count, 2)
        finally:
            conn.close()

    def test_export_reads_requested_session_only(self):
        conn = connect(self.db_path)
        try:
            self.insert_signal(conn, "0940", 10)
            self.insert_signal(conn, "1520", 20)
            conn.commit()
            rows = export_dashboard_json.signal_items(
                conn,
                "2026-07-10",
                "1520",
                "candidate",
                3,
            )
            self.assertEqual(len(rows), 1)
            self.assertEqual(rows[0]["score"], 20)
        finally:
            conn.close()

    def test_old_signal_schema_migrates_session_column(self):
        legacy_path = pathlib.Path(self.temp.name) / "legacy.db"
        conn = sqlite3.connect(legacy_path)
        try:
            conn.execute(
                """
                CREATE TABLE signal_result (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  ts TEXT, trade_date TEXT, code TEXT, name TEXT,
                  group_name TEXT, score REAL, rule_result TEXT,
                  reason TEXT, entry_trigger TEXT, failure_condition TEXT
                )
                """
            )
            conn.commit()
        finally:
            conn.close()
        init_db(legacy_path)
        conn = sqlite3.connect(legacy_path)
        try:
            columns = {row[1] for row in conn.execute("PRAGMA table_info(signal_result)")}
        finally:
            conn.close()
        self.assertIn("session_name", columns)


class StateSnapshotTests(unittest.TestCase):
    def test_sql_state_round_trip(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            source = root / "source.db"
            restored = root / "restored.db"
            state = root / "state.sql"
            conn = sqlite3.connect(source)
            try:
                conn.execute("CREATE TABLE sample (id INTEGER PRIMARY KEY, value TEXT)")
                conn.execute("INSERT INTO sample (value) VALUES ('durable')")
                conn.commit()
            finally:
                conn.close()
            short_flow_state.export_state(source, state)
            self.assertTrue(short_flow_state.restore_state(state, restored))
            conn = sqlite3.connect(restored)
            try:
                value = conn.execute("SELECT value FROM sample").fetchone()[0]
            finally:
                conn.close()
            self.assertEqual(value, "durable")


class BacktestHorizonTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.db_path = pathlib.Path(self.temp.name) / "test.db"
        init_db(self.db_path)

    def tearDown(self):
        self.temp.cleanup()

    def _seed_trade_date(self, conn, trade_date):
        conn.execute(
            "INSERT INTO etf_indicator (trade_date, code) VALUES (?, ?)",
            (trade_date, "510300"),
        )

    def test_recent_signal_not_eligible(self):
        # A signal only 2 trading days ago must NOT be backtested yet.
        conn = connect(self.db_path)
        try:
            self._seed_trade_date(conn, "2026-07-08")
            self._seed_trade_date(conn, "2026-07-09")
            conn.execute(
                """
                INSERT INTO signal_result
                  (ts, trade_date, session_name, code, name, group_name, score,
                   rule_result, reason, entry_trigger, failure_condition)
                VALUES (?, ?, '0940', '510300', '沪深300ETF', 'CORE', 10,
                        'candidate', 't', 'tr', 'f')
                """,
                ("2026-07-09 09:40", "2026-07-09"),
            )
            conn.commit()
            import backtest
            self.assertEqual(backtest.signal_dates_to_backtest(conn), [])
        finally:
            conn.close()

    def test_signal_past_horizon_is_eligible(self):
        # With >=10 trading days of history after the signal, it becomes eligible.
        conn = connect(self.db_path)
        try:
            for offset in range(1, 13):
                d = (dt.date(2026, 7, 9) + dt.timedelta(days=offset)).isoformat()
                self._seed_trade_date(conn, d)
            conn.execute(
                """
                INSERT INTO signal_result
                  (ts, trade_date, session_name, code, name, group_name, score,
                   rule_result, reason, entry_trigger, failure_condition)
                VALUES (?, ?, '0940', '510300', '沪深300ETF', 'CORE', 10,
                        'candidate', 't', 'tr', 'f')
                """,
                ("2026-07-09 09:40", "2026-07-09"),
            )
            conn.commit()
            import backtest
            self.assertEqual(backtest.signal_dates_to_backtest(conn), ["2026-07-09"])
        finally:
            conn.close()

    def test_partial_backtest_is_requeued(self):
        # A date whose backtest row is missing hit_10d should stay eligible.
        conn = connect(self.db_path)
        try:
            for offset in range(1, 13):
                d = (dt.date(2026, 7, 9) + dt.timedelta(days=offset)).isoformat()
                self._seed_trade_date(conn, d)
            conn.execute(
                """
                INSERT INTO signal_result
                  (ts, trade_date, session_name, code, name, group_name, score,
                   rule_result, reason, entry_trigger, failure_condition)
                VALUES (?, ?, '0940', '510300', '沪深300ETF', 'CORE', 10,
                        'candidate', 't', 'tr', 'f')
                """,
                ("2026-07-09 09:40", "2026-07-09"),
            )
            # Stale partial row (5d present, 10d NULL).
            conn.execute(
                """
                INSERT INTO backtest_result
                  (signal_date, code, name, regime, score, rule_result, reason,
                   close_price, return_5d, hit_5d, hit_10d, computed_at)
                VALUES (?, '510300', '沪深300ETF', 'RANGE', 10, 'candidate', 't',
                        1.0, 2.0, 1, NULL, '2026-07-20 00:00')
                """,
                ("2026-07-09",),
            )
            conn.commit()
            import backtest
            self.assertEqual(backtest.signal_dates_to_backtest(conn), ["2026-07-09"])
        finally:
            conn.close()


class ValidationConsistencyTests(unittest.TestCase):
    def _make_payload(self, trade_date, session="0940", run_id=1,
                      gen="2026-07-10 09:40", source=None, backtest=None):
        return {
            "trade_date": trade_date,
            "session": session,
            "analysis_run_id": run_id,
            "generated_at": gen,
            "source_status": source or {"live_rows": 5, "stale_rows": 0,
                                        "latest_quote_date": trade_date},
            "backtest": backtest or {"recent": []},
        }

    def test_mismatched_board_dates_are_rejected(self):
        short = self._make_payload("2026-07-10")
        etf = self._make_payload("2026-07-09")  # differs from short-flow
        index = self._make_payload("2026-07-10")
        with self.assertRaises(ValueError):
            validate_dashboards.validate_short_flow_date_consistency(index, short, etf)

    def test_stale_quote_date_is_rejected(self):
        short = self._make_payload(
            "2026-07-10",
            source={"live_rows": 5, "stale_rows": 0, "latest_quote_date": "2026-07-09"},
        )
        etf = self._make_payload("2026-07-10")
        index = self._make_payload("2026-07-10")
        with self.assertRaises(ValueError):
            validate_dashboards.validate_short_flow_date_consistency(index, short, etf)

    def test_consistent_dates_pass(self):
        short = self._make_payload("2026-07-10")
        etf = self._make_payload("2026-07-10")
        index = self._make_payload("2026-07-10")
        result = validate_dashboards.validate_short_flow_date_consistency(index, short, etf)
        self.assertEqual(result.isoformat(), "2026-07-10")

    def test_incomplete_backtest_is_rejected(self):
        etf = self._make_payload(
            "2026-07-10",
            backtest={"recent": [
                {"signal_date": "2026-07-10", "hit_10d": None},
            ]},
        )
        # Force the window-closed helper to true so the incomplete row is flagged.
        with mock.patch.object(validate_dashboards, "_is_backtest_window_closed",
                               return_value=True):
            with self.assertRaises(ValueError):
                validate_dashboards.validate_backtest_completeness(etf)

    def test_complete_backtest_passes(self):
        etf = self._make_payload(
            "2026-07-10",
            backtest={"recent": [
                {"signal_date": "2026-07-10", "hit_10d": 1},
            ]},
        )
        # Should not raise even if the window is closed.
        with mock.patch.object(validate_dashboards, "_is_backtest_window_closed",
                               return_value=True):
            validate_dashboards.validate_backtest_completeness(etf)


if __name__ == "__main__":
    unittest.main()
