import { readFile } from "node:fs/promises";

const SNAPSHOT_URL = new URL("../dashboards/short-flow/dashboard_latest.json", import.meta.url);
const MAX_CANDIDATES = 36;
const BATCH_SIZE = 10;
const QUOTE_FIELDS = [
  "f12", "f14", "f2", "f3", "f5", "f6", "f8", "f10", "f15", "f16",
  "f17", "f18", "f62", "f184", "f66", "f72", "f78", "f84", "f124"
].join(",");
const AUTO_CATEGORIES = new Set(["SECTOR", "THEME", "DEFENSE", "GROWTH"]);

function numberOrNull(value) {
  if (value === null || value === undefined || value === "" || value === "-") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function secidFor(code) {
  return `${String(code).startsWith("5") ? "1" : "0"}.${code}`;
}

function beijingParts(date = new Date()) {
  const values = Object.fromEntries(
    new Intl.DateTimeFormat("en-CA", {
      timeZone: "Asia/Shanghai",
      weekday: "short",
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hourCycle: "h23"
    }).formatToParts(date).filter(part => part.type !== "literal").map(part => [part.type, part.value])
  );
  return {
    ...values,
    hour: Number(values.hour),
    minute: Number(values.minute),
    second: Number(values.second),
    date: `${values.year}-${values.month}-${values.day}`,
    timestamp: `${values.year}-${values.month}-${values.day} ${values.hour}:${values.minute}:${values.second}`
  };
}

export function marketPhase(date = new Date()) {
  const parts = beijingParts(date);
  const weekday = !["Sat", "Sun"].includes(parts.weekday);
  const minute = parts.hour * 60 + parts.minute;
  let key = "closed";
  let label = "休市";
  let marketOpen = false;
  let entryWindow = false;

  if (weekday && minute < 570) {
    key = "pre_open";
    label = "开盘前";
  } else if (weekday && minute < 580) {
    key = "opening";
    label = "开盘观察";
    marketOpen = true;
  } else if (weekday && minute < 630) {
    key = "confirm";
    label = "首次确认";
    marketOpen = true;
    entryWindow = true;
  } else if (weekday && minute < 690) {
    key = "morning";
    label = "上午跟踪";
    marketOpen = true;
    entryWindow = true;
  } else if (weekday && minute < 780) {
    key = "break";
    label = "午间休市";
  } else if (weekday && minute < 860) {
    key = "afternoon";
    label = "下午确认";
    marketOpen = true;
    entryWindow = true;
  } else if (weekday && minute < 870) {
    key = "final_confirm";
    label = "最后确认";
    marketOpen = true;
    entryWindow = true;
  } else if (weekday && minute < 900) {
    key = "late";
    label = "尾盘只观察";
    marketOpen = true;
  } else if (weekday) {
    label = "已收盘";
  }

  return { ...parts, key, label, market_open: marketOpen, entry_window: entryWindow };
}

export function selectCandidates(snapshot, limit = MAX_CANDIDATES) {
  const merged = new Map();
  for (const row of [...(snapshot.market_flow || []), ...(snapshot.watch_signals || [])]) {
    const code = String(row.code || "").trim();
    if (!/^\d{6}$/.test(code)) continue;
    const current = merged.get(code);
    if (!current || row.role === "watch" || (current.role !== "watch" && (row.score || 0) > (current.score || 0))) {
      merged.set(code, { ...row, code });
    }
  }

  const pinned = [];
  const automatic = [];
  for (const row of merged.values()) {
    if (row.role === "watch") {
      pinned.push(row);
      continue;
    }
    if (!AUTO_CATEGORIES.has(row.category)) continue;
    if (!["Focus watch", "Wait for strength"].includes(row.status)) continue;
    automatic.push(row);
  }

  const statusRank = status => status === "Focus watch" ? 0 : 1;
  pinned.sort((a, b) => (a.priority === "core" ? -1 : 0) - (b.priority === "core" ? -1 : 0) || (b.score || 0) - (a.score || 0));
  automatic.sort((a, b) => statusRank(a.status) - statusRank(b.status) || (b.score || 0) - (a.score || 0));
  return [...pinned, ...automatic].slice(0, limit);
}

function chunks(values, size) {
  const result = [];
  for (let index = 0; index < values.length; index += size) result.push(values.slice(index, index + size));
  return result;
}

async function requestQuotes(secids, endpoint) {
  const query = new URLSearchParams({
    fltt: "2",
    invt: "2",
    secids: secids.join(","),
    fields: QUOTE_FIELDS
  });
  const response = await fetch(`${endpoint}?${query}`, {
    headers: {
      Accept: "application/json",
      Referer: "https://quote.eastmoney.com/",
      "User-Agent": "dashboards-intraday/1.0"
    },
    signal: AbortSignal.timeout(6000)
  });
  if (!response.ok) throw new Error(`quote HTTP ${response.status}`);
  const payload = await response.json();
  const rows = payload?.data?.diff;
  if (!Array.isArray(rows)) throw new Error("quote payload missing rows");
  return rows;
}

async function fetchQuoteBatch(secids) {
  const sources = [
    ["https://push2.eastmoney.com/api/qt/ulist.np/get", "Eastmoney:realtime", false],
    ["https://push2delay.eastmoney.com/api/qt/ulist.np/get", "Eastmoney:delayed", true]
  ];
  let lastError;
  for (const [endpoint, source, delayed] of sources) {
    try {
      return { rows: await requestQuotes(secids, endpoint), source, delayed };
    } catch (error) {
      lastError = error;
    }
  }
  throw lastError || new Error("quote source unavailable");
}

function elapsedTradingFraction(phase) {
  const minute = phase.hour * 60 + phase.minute;
  let elapsed = 0;
  if (minute >= 570 && minute <= 690) elapsed = minute - 570;
  else if (minute > 690 && minute < 780) elapsed = 120;
  else if (minute >= 780 && minute <= 900) elapsed = 120 + minute - 780;
  else if (minute > 900) elapsed = 240;
  return Math.max(1 / 240, Math.min(1, elapsed / 240));
}

function signedPct(value) {
  return value === null ? "暂无" : `${value >= 0 ? "+" : ""}${value.toFixed(1)}%`;
}

export function classifyIntraday(base, live, phase) {
  const price = live.close;
  const aboveMa5 = price !== null && base.ma5 != null && price >= base.ma5;
  const aboveMa10 = price !== null && base.ma10 != null && price >= base.ma10;
  const aboveMa20 = price !== null && base.ma20 != null && price >= base.ma20;
  const positiveFlow = live.main_net != null && live.main_net > 0 && (live.main_net_pct == null || live.main_net_pct > 0);
  const weakFlow = live.main_net != null && live.main_net < 0;
  const largeExitSmallEntry = (live.super_large_net || 0) < 0 && (live.large_net || 0) < 0 && (live.small_net || 0) > 0;
  const heavyFade = live.intraday_drawdown_pct != null && live.intraday_drawdown_pct <= -2 && live.upper_shadow_ratio >= 0.45;
  const exhausted = base.return_20d_pct != null && base.return_20d_pct >= 30;
  const activeAmount = live.amount_pace_20 == null || live.amount_pace_20 >= 0.75;
  const confirmationOpen = !phase.market_open || !["opening"].includes(phase.key);

  let status = "Wait for strength";
  if ((price != null && base.ma20 != null && price < base.ma20 && weakFlow) ||
      (!aboveMa10 && live.main_net_pct != null && live.main_net_pct <= -5) || largeExitSmallEntry) {
    status = "Exclude for now";
  } else if (confirmationOpen && aboveMa5 && aboveMa10 && aboveMa20 && positiveFlow && activeAmount && !heavyFade && !exhausted) {
    status = "Focus watch";
  }
  if (phase.key === "opening" && status === "Focus watch") status = "Wait for strength";

  const reasons = [];
  if (positiveFlow) reasons.push(`主力净流入${signedPct(live.main_net_pct)}`);
  else if (weakFlow) reasons.push(`主力净流出${signedPct(live.main_net_pct)}`);
  else reasons.push("盘中资金流不足");
  if (aboveMa5 && aboveMa10 && aboveMa20) reasons.push("价格站上昨日MA5/10/20");
  else if (aboveMa20) reasons.push("仍在MA20上方但短线待修复");
  else reasons.push("未收回关键短均线");
  if (live.amount_pace_20 != null) reasons.push(`成交额进度为20日均额${live.amount_pace_20.toFixed(2)}倍`);
  if (heavyFade) reasons.push("盘中冲高回落");
  if (largeExitSmallEntry) reasons.push("小单流入但大单流出");
  if (exhausted) reasons.push("20日涨幅偏高");
  if (phase.key === "opening") reasons.push("开盘前10分钟只观察");
  if (phase.key === "late") reasons.push("14:30后不新增追涨确认");

  const triggers = [];
  if (base.key_level != null) triggers.push(`站稳关键位${Number(base.key_level).toFixed(2)}`);
  if (base.ma5 != null) triggers.push(`站稳MA5(${Number(base.ma5).toFixed(2)})`);
  triggers.push("主力资金转正且成交额进度不明显萎缩");

  const failures = [];
  if (base.key_level != null) failures.push(`跌破关键位${Number(base.key_level).toFixed(2)}且资金继续流出`);
  if (base.ma5 != null) failures.push(`跌破MA5(${Number(base.ma5).toFixed(2)})且主力净流出`);
  if (status === "Exclude for now" && base.ma20 != null) failures.push(`未收回MA20(${Number(base.ma20).toFixed(2)})前不升级`);

  return { status, reason: reasons.join("；"), next_trigger: triggers.join("；"), failure: failures.join("；") };
}

function quoteTimestamp(value) {
  const seconds = numberOrNull(value);
  if (!seconds) return null;
  return beijingParts(new Date(seconds * 1000)).timestamp;
}

export function mergeLiveRow(base, quote, phase, source, delayed) {
  const close = numberOrNull(quote.f2);
  const high = numberOrNull(quote.f15);
  const low = numberOrNull(quote.f16);
  const open = numberOrNull(quote.f17);
  const amount = numberOrNull(quote.f6);
  const volume = numberOrNull(quote.f5);
  const average20 = base.amount_ratio_20 > 0 && base.amount != null ? base.amount / base.amount_ratio_20 : null;
  const amountRatio20 = average20 && amount != null ? amount / average20 : null;
  const amountPace20 = amountRatio20 == null ? null : amountRatio20 / elapsedTradingFraction(phase);
  const range = high != null && low != null ? high - low : null;
  const upperShadow = range > 0 && open != null && close != null ? (high - Math.max(open, close)) / range : 0;
  const drawdown = high > 0 && close != null ? (close / high - 1) * 100 : null;
  const mainNet = numberOrNull(quote.f62);
  const mainNetPct = numberOrNull(quote.f184);
  const superLarge = numberOrNull(quote.f66);
  const large = numberOrNull(quote.f72);
  const medium = numberOrNull(quote.f78);
  const small = numberOrNull(quote.f84);
  const live = {
    close,
    pct: numberOrNull(quote.f3),
    open,
    high,
    low,
    previous_close: numberOrNull(quote.f18),
    volume,
    amount,
    turnover_pct: numberOrNull(quote.f8),
    volume_ratio: numberOrNull(quote.f10),
    vwap: amount != null && volume > 0 ? amount / (volume * 100) : null,
    amount_ratio_20: amountRatio20,
    amount_pace_20: amountPace20,
    intraday_drawdown_pct: drawdown,
    upper_shadow_ratio: upperShadow,
    main_net: mainNet,
    main_net_pct: mainNetPct,
    super_large_net: superLarge,
    large_net: large,
    medium_net: medium,
    small_net: small
  };
  const classification = classifyIntraday(base, live, phase);
  return {
    ...base,
    ...live,
    ...classification,
    name: quote.f14 || base.name,
    display_name: base.display_name || base.name || quote.f14,
    source_pool: "intraday_candidate",
    source_price: source,
    source_flow: source,
    data_status: delayed ? "stale" : "live",
    flow_data_status: delayed ? "stale" : "live",
    quote_asof: quoteTimestamp(quote.f124),
    phase: phase.key,
    entry_window: phase.entry_window,
    score: (classification.status === "Focus watch" ? 100 : classification.status === "Wait for strength" ? 25 : 0) +
      Math.max(-20, Math.min(20, mainNetPct || 0)) * 1.5 + Math.min(amountPace20 || 0, 3) * 8
  };
}

async function buildResponse() {
  const snapshot = JSON.parse(await readFile(SNAPSHOT_URL, "utf8"));
  const candidates = selectCandidates(snapshot);
  const phase = marketPhase();
  const batches = chunks(candidates.map(row => secidFor(row.code)), BATCH_SIZE);
  const results = await Promise.allSettled(batches.map(fetchQuoteBatch));
  const quotes = new Map();
  const sourceCounts = { realtime: 0, delayed: 0, failed_batches: 0 };
  for (const result of results) {
    if (result.status !== "fulfilled") {
      sourceCounts.failed_batches += 1;
      continue;
    }
    const { rows, source, delayed } = result.value;
    sourceCounts[delayed ? "delayed" : "realtime"] += rows.length;
    for (const quote of rows) quotes.set(String(quote.f12), { quote, source, delayed });
  }
  const rows = candidates.flatMap(base => {
    const found = quotes.get(base.code);
    return found ? [mergeLiveRow(base, found.quote, phase, found.source, found.delayed)] : [];
  }).sort((a, b) => {
    const rank = status => status === "Focus watch" ? 0 : status === "Wait for strength" ? 1 : 2;
    return rank(a.status) - rank(b.status) || (b.score || 0) - (a.score || 0);
  });
  if (!rows.length) throw new Error("盘中行情源暂不可用");
  const refreshEnabled = phase.market_open || phase.key === "break" || (phase.key === "pre_open" && phase.hour >= 9);
  return {
    generated_at: phase.timestamp,
    baseline_asof: snapshot.asof,
    baseline_trade_date: snapshot.trade_date,
    phase: {
      key: phase.key,
      label: phase.label,
      market_open: phase.market_open,
      entry_window: phase.entry_window
    },
    refresh_seconds: refreshEnabled ? 300 : 0,
    candidate_count: candidates.length,
    quote_count: rows.length,
    status_counts: Object.fromEntries(["Focus watch", "Wait for strength", "Exclude for now"].map(status => [status, rows.filter(row => row.status === status).length])),
    source_status: sourceCounts,
    rows
  };
}

export default {
  async fetch(request) {
    if (request.method !== "GET") {
      return Response.json({ error: "Method not allowed" }, { status: 405, headers: { Allow: "GET" } });
    }
    try {
      const payload = await buildResponse();
      return Response.json(payload, {
        headers: {
          "Cache-Control": "public, max-age=0, s-maxage=180, stale-while-revalidate=120",
          "X-Content-Type-Options": "nosniff"
        }
      });
    } catch (error) {
      return Response.json({ error: error.message || "Intraday data unavailable" }, {
        status: 503,
        headers: { "Cache-Control": "no-store", "X-Content-Type-Options": "nosniff" }
      });
    }
  }
};
