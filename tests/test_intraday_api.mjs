import assert from "node:assert/strict";
import test from "node:test";

import IntradayETF from "../dashboards/shared/intraday-etf.js";

const { classifyIntraday, marketPhase, selectCandidates } = IntradayETF;

test("candidate pool keeps manual watch and excludes broad or cash auto candidates", () => {
  const snapshot = {
    market_flow: [
      { code: "510300", role: "market", category: "CORE", status: "Focus watch", score: 200 },
      { code: "511880", role: "scan", category: "MONEY", status: "Focus watch", score: 190 }
    ],
    watch_signals: [
      { code: "515070", role: "watch", category: "THEME", status: "Exclude for now", score: -10 },
      { code: "512760", role: "scan", category: "SECTOR", status: "Focus watch", score: 100 },
      { code: "516020", role: "scan", category: "SECTOR", status: "Wait for strength", score: 50 },
      { code: "513100", role: "scan", category: "CROSS", status: "Focus watch", score: 180 }
    ]
  };
  assert.deepEqual(selectCandidates(snapshot).map(row => row.code), ["515070", "512760", "516020"]);
});

test("market phases enforce the opening and late-session guardrails", () => {
  assert.equal(marketPhase(new Date("2026-07-14T01:35:00Z")).key, "opening");
  assert.equal(marketPhase(new Date("2026-07-14T01:45:00Z")).key, "confirm");
  assert.equal(marketPhase(new Date("2026-07-14T06:25:00Z")).key, "final_confirm");
  assert.equal(marketPhase(new Date("2026-07-14T06:40:00Z")).key, "late");
});

test("intraday classification requires trend, flow and volume confirmation", () => {
  const base = { ma5: 1.0, ma10: 0.98, ma20: 0.95, return_20d_pct: 8, key_level: null };
  const live = {
    close: 1.05,
    main_net: 2_000_000,
    main_net_pct: 6,
    super_large_net: 1_000_000,
    large_net: 1_000_000,
    small_net: -500_000,
    amount_pace_20: 1.2,
    intraday_drawdown_pct: -0.5,
    upper_shadow_ratio: 0.2
  };
  const confirmation = { key: "confirm", market_open: true };
  assert.equal(classifyIntraday(base, live, confirmation).status, "Focus watch");

  const opening = { key: "opening", market_open: true };
  assert.equal(classifyIntraday(base, live, opening).status, "Wait for strength");

  const distribution = {
    ...live,
    super_large_net: -3_000_000,
    large_net: -1_000_000,
    small_net: 4_000_000
  };
  assert.equal(classifyIntraday(base, distribution, confirmation).status, "Exclude for now");
});
