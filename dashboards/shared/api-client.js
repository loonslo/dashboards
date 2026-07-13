(function () {
  function trimSlash(value) {
    return String(value || "").replace(/\/+$/, "");
  }

  async function apiBase() {
    const local = trimSlash(localStorage.getItem("dashboard_api_base"));
    if (local) return local;
    const globalBase = trimSlash(window.DASHBOARD_API_BASE);
    if (globalBase) return globalBase;
    try {
      const res = await fetch("../api_config.json", { cache: "no-store" });
      if (res.ok) {
        const config = await res.json();
        return trimSlash(config.apiBase);
      }
    } catch {
      return "";
    }
    return "";
  }

  async function fetchJson(url) {
    const res = await fetch(url, { cache: "no-store" });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  }

  async function fetchLatest(dashboard, fallback) {
    const localApi = ["127.0.0.1", "localhost", "::1"].includes(window.location.hostname);
    const runtimeApiEnabled = localApi || window.DASHBOARD_SAME_ORIGIN_API === true;
    if (!runtimeApiEnabled) {
      return fetchJson(fallback);
    }

    const base = await apiBase();
    const candidates = [];
    if (base) candidates.push(`${base}/api/latest/${dashboard}`);
    if (!base && (localApi || window.DASHBOARD_SAME_ORIGIN_API === true)) {
      candidates.push(`/api/latest/${dashboard}`);
    }
    for (const url of candidates) {
      try {
        return await fetchJson(url);
      } catch {
        // Try configured API, same-origin API, then the static snapshot.
      }
    }
    return fetchJson(fallback);
  }

  async function api(path, options = {}) {
    const base = await apiBase();
    const url = base ? `${base}${path}` : path;
    const token = localStorage.getItem("dashboard_api_token") || "";
    const headers = {
      "Content-Type": "application/json",
      ...(token ? { "Authorization": `Bearer ${token}` } : {}),
      ...(options.headers || {})
    };
    const res = await fetch(url, {
      cache: "no-store",
      ...options,
      headers
    });
    const text = await res.text();
    const data = text ? JSON.parse(text) : {};
    if (!res.ok) throw new Error(data.error || `HTTP ${res.status}`);
    return data;
  }

  window.DashboardApi = { apiBase, fetchLatest, api };
})();
