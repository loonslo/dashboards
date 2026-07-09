(function () {
  // 共享格式化与词表：两个看板 + 管理台共用同一套，避免逻辑与术语漂移。
  const safe = value => String(value ?? "").replace(/[&<>"']/g, ch => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[ch]));
  const fmt = (v, d = 2) => v === null || v === undefined || Number.isNaN(Number(v)) ? "暂无" : Number(v).toFixed(d);
  const pct = (v, d = 1) => v === null || v === undefined || Number.isNaN(Number(v)) ? "暂无" : `${Number(v).toFixed(d)}%`;
  const cls = v => Number(v) > 0 ? "pos" : Number(v) < 0 ? "neg" : "flat";
  const money = v => {
    if (v === null || v === undefined || Number.isNaN(Number(v))) return "暂无";
    const value = Number(v);
    const abs = Math.abs(value);
    if (abs >= 100000000) return `${(value / 100000000).toFixed(2)}亿`;
    if (abs >= 10000) return `${(value / 10000).toFixed(0)}万`;
    return value.toFixed(0);
  };

  // 统一状态词表：后端英文枚举 → 中文。两个看板必须共用这一份。
  const DECISION_LABELS = {
    "Focus watch": "可观察",
    "Wait for strength": "待观察",
    "Exclude for now": "待排除"
  };
  const decisionLabel = status => DECISION_LABELS[status] || status || "资金观察";

  const dataStatusLabel = status => ({
    live: "实时",
    stale: "延迟",
    unavailable: "不可用",
    unknown: "未知"
  }[status] || "未知");
  const dataStatusClass = status => status === "live" ? "live" : status === "stale" ? "stale" : "na";

  const alertLevelLabel = level => ({
    local: "本机",
    alert: "提醒",
    warning: "预警",
    info: "观察",
    cost: "成本",
    data: "数据"
  }[level] || level || "提醒");

  const priorityLabel = priority => ({
    core: "核心",
    high: "高优先",
    normal: "普通",
    low: "低优先"
  }[priority] || "普通");

  const regimeLabel = regime => ({
    TREND_UP: "趋势向上",
    RANGE: "震荡",
    TREND_DOWN: "趋势向下"
  }[regime] || regime || "暂无");

  function parseTimestamp(value) {
    const raw = String(value == null ? "" : value).trim();
    if (!raw) return null;
    // 支持 "2026-07-04 14:22:03" / ISO / 纯日期，按本地时区解析（数据由本机/服务器生成）
    let ms = Date.parse(raw.replace(" ", "T"));
    if (Number.isNaN(ms)) ms = Date.parse(raw);
    return Number.isNaN(ms) ? null : ms;
  }

  // 相对新鲜度：把 asof 时间戳换算成“多久前”，并给出新鲜/偏旧/过期级别。
  function relativeTime(asof) {
    const t = parseTimestamp(asof);
    if (t === null) return { text: "", level: "unknown", minutes: null };
    const minutes = Math.floor((Date.now() - t) / 60000);
    if (minutes < 0) return { text: "刚刚", level: "fresh", minutes: 0 };
    let text;
    if (minutes < 1) text = "刚刚";
    else if (minutes < 60) text = `${minutes} 分钟前`;
    else if (minutes < 60 * 24) text = `${Math.floor(minutes / 60)} 小时前`;
    else text = `${Math.floor(minutes / (60 * 24))} 天前`;
    const level = minutes >= 60 * 24 ? "old" : minutes >= 180 ? "stale" : "fresh";
    return { text, level, minutes };
  }

  window.DashFmt = {
    safe, fmt, pct, cls, money,
    decisionLabel, dataStatusLabel, dataStatusClass,
    alertLevelLabel, priorityLabel, regimeLabel,
    relativeTime
  };
})();
