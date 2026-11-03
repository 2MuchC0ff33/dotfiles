// LibreWolf performance tweaks for 3.1 GB RAM / 2-core CPU (AMD Athlon Silver 7120U)
// Apply by restarting LibreWolf

// --- Process & memory reduction ---
user_pref("dom.ipc.processCount", 1);
user_pref("dom.ipc.processCount.webIsolated", 1);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 524288);
user_pref("browser.sessionhistory.max_total_viewers", 0);
user_pref("browser.sessionhistory.max_entries", 5);
user_pref("browser.sessionstore.max_tabs_undo", 3);
user_pref("browser.sessionstore.interval", 600000);
user_pref("browser.tabs.unloadOnLowMemory", true);

// --- UI animations off ---
user_pref("browser.tabs.animate", false);
user_pref("browser.download.animateNotifications", false);
user_pref("toolkit.cosmeticAnimations.enabled", false);
user_pref("browser.aboutWelcome.enabled", false);
user_pref("browser.newtabpage.enabled", false);

// --- Network / prefetch off ---
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.predictor.enabled", false);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// --- Graphics / WebRender (AMD Radeon Vega) ---
user_pref("gfx.webrender.enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("gfx.canvas.accelerated", true);
user_pref("image.mem.max_decoded_image_kb", 16384);

// --- AI / ML features off ---
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.pageAssist.enabled", false);
user_pref("extensions.ml.enabled", false);
