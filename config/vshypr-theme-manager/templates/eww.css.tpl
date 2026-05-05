* {
    all: unset;
    font-family: "JetBrains Mono", monospace;
}

window, window.background, #clock, #sysinfo {
    background-color: rgba(0, 0, 0, 0);
    background: none;
}


/* ── CLOCK ─────────────────────────────── */
.clock-box {
    background-color: rgba(0, 0, 0, 0);
    padding: 6px 0px;
}

.clock-time-row {
    background-color: rgba(0, 0, 0, 0);
}

.clock-hh {
    font-family: "Product Sans", sans-serif;
    font-size: 82px;
    font-weight: 700;
    color: {{fg}};
    letter-spacing: -3px;
    text-shadow: 0px 0px 28px {{accent_rgba_28}},
                 0px 2px 18px rgba(0, 0, 0, 0.95);
}

.clock-colon {
    font-family: "Product Sans", sans-serif;
    font-size: 62px;
    font-weight: 300;
    color: {{accent_rgba_55}};
    margin-left: 3px;
    margin-right: 3px;
    text-shadow: 0px 2px 10px rgba(0, 0, 0, 0.8);
}

.clock-mm {
    font-family: "Product Sans", sans-serif;
    font-size: 82px;
    font-weight: 300;
    color: {{fg_rgba_55}};
    letter-spacing: -3px;
    text-shadow: 0px 2px 18px rgba(0, 0, 0, 0.95);
}

.clock-date {
    font-family: "Product Sans", sans-serif;
    font-size: 11px;
    font-weight: 500;
    color: {{overlay_rgba_85}};
    letter-spacing: 3px;
    margin-top: 2px;
    text-shadow: 0px 1px 8px rgba(0, 0, 0, 0.9);
}

/* ── MONITOR BOX ────────────────────────── */
.monitor-box {
    background-color: {{bg}};
    border-radius: 16px;
    border: 1px solid {{surface}};
    padding: 16px 16px;
}

.monitor-header {
    margin-bottom: 5px;
    padding-top: 0px;
    padding-bottom:0px;
}

.fetch-logo {
    font-family: "JetBrainsMono Nerd Font Mono", monospace;
    font-size: 95px;
    color: {{accent}};
    margin-left: 90px;
    margin-right: 45px;
    text-shadow: 0px 0px 16px {{accent_rgba_35}};
}

.fetch-titles {
    background-color: rgba(0, 0, 0, 0);
    margin-right: 12px;
}

.fetch-label {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 700;
    color: {{teal}};
    margin-bottom: 6px;
}

.fetch-values {
    background-color: rgba(0, 0, 0, 0);
}

.fetch-value {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 400;
    color: {{fg}};
    margin-bottom: 6px;
}

.monitor-title {
    font-family: "JetBrains Mono", monospace;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2px;
    color: {{surface2}};
}

.status-dot {
    background-color: {{teal}};
    border-radius: 50%;
    min-width: 5px;
    min-height: 5px;
    margin-left: 8px;
}

.monitor-divider {
    background-color: {{surface}};
    min-height: 1px;
    margin: 10px 0px;
}

.storage-label {
    font-family: "JetBrains Mono", monospace;
    font-size: 10px;
    letter-spacing: 2px;
    color: {{surface2}};
    margin-bottom: 8px;
}

/* ── STAT ROWS ──────────────────────────── */
.stat-row {
    margin-bottom: 10px;
}

.stat-header {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 500;
    color: {{fg_dim}};
    margin-bottom: 4px;
}

/* ── BARS (scale widget) ────────────────── */
scale.stat-bar {
    padding: 0;
    margin-top: 4px;
}

scale.stat-bar trough {
    background-color: {{surface3}};
    border-radius: 3px;
    border: 1px solid {{surface}};
    min-height: 6px;
}

scale.stat-bar trough highlight {
    border-radius: 3px;
    min-height: 6px;
}

scale.stat-bar slider {
    min-width: 0;
    min-height: 0;
    background: none;
    border: none;
    padding: 0;
    opacity: 0;
}

scale.stat-bar.fill-blue   trough highlight { background-color: {{accent}}; }
scale.stat-bar.fill-purple trough highlight { background-color: {{accent}}; }
scale.stat-bar.fill-green  trough highlight { background-color: {{teal}}; }
scale.stat-bar.fill-yellow trough highlight { background-color: {{accent_dim}}; }
scale.stat-bar.fill-orange trough highlight { background-color: {{teal_dim}}; }

/* ════════════════════════════════════════════════
   SIDEBAR
   ════════════════════════════════════════════════ */

.sb-main {
    background-color: {{bg}};
    border-radius: 16px;
    border: 1px solid {{surface}};
}

/* ── Separador ────────────────────────────────── */
.sb-sep {
    background-color: {{surface}};
    min-height: 1px;
    margin: 12px 14px;
}

/* ── Calendario + Reloj ───────────────────────── */
.sb-cal-box {
    padding: 8px 4px 4px 4px;
}
.sb-time {
    font-size: 34px;
    font-weight: bold;
    color: {{accent}};
    padding-bottom: 2px;
}
.sb-date {
    font-size: 12px;
    color: {{fg_dim}};
    padding-bottom: 6px;
    letter-spacing: 1px;
}
.sb-calendar {
    font-size: 13px;
    color: {{fg}};
    padding-left:10px;
    padding-right:10px;
    padding-top:5px;
}
.sb-calendar:selected {
    color: {{accent}};
    font-weight: bold;
}
.sb-calendar:indeterminate {
    color: {{surface2}};
}

/* ── Info ─────────────────────────────────────── */
.sb-info {
    padding: 4px 8px;
}
.sb-info-icons {
    margin-right: 8px;
}
.sb-info-icon {
    color: {{teal}};
    font-size: 13px;
    margin-bottom: 4px;
}
.sb-info-val {
    color: {{fg}};
    font-size: 12px;
    margin-bottom: 4px;
}

/* ── Circular Progress (CPU/RAM/Temp) ─────────── */
.sb-sys-box {
    padding: 10px 0px;
}
.sb-ring-box {
    margin: 8px 10px;
}
.sb-ring-cpu {
    color: {{accent}};
    background-color: {{surface3}};
    border-radius: 50%;
}
.sb-ring-mem {
    color: {{teal}};
    background-color: {{surface3}};
    border-radius: 50%;
}
.sb-ring-disk {
    color: {{accent_dim}};
    background-color: {{surface3}};
    border-radius: 50%;
}
.sb-ring-temp {
    color: {{teal_dim}};
    background-color: {{surface3}};
    border-radius: 50%;
}
.sb-ring-spacer { margin: 38px; }
.sb-ring-icon-cpu  { font-size: 26px; color: {{accent}}; }
.sb-ring-icon-mem  { font-size: 26px; color: {{teal}}; }
.sb-ring-icon-disk { font-size: 26px; color: {{accent_dim}}; }
.sb-ring-icon-temp { font-size: 26px; color: {{teal_dim}}; }
.sb-ring-perc-cpu  { color: {{accent}};     font-size: 13px; padding-top: 4px; }
.sb-ring-perc-mem  { color: {{teal}};       font-size: 13px; padding-top: 4px; }
.sb-ring-perc-disk { color: {{accent_dim}}; font-size: 13px; padding-top: 4px; }
.sb-ring-perc-temp { color: {{teal_dim}};   font-size: 13px; padding-top: 4px; }

/* ── Clima ────────────────────────────────────── */
.sb-weather-box {
    padding: 10px 6px;
}
.sb-weather-icon {
    color: {{accent}};
    font-size: 28px;
    font-weight: bold;
}
.sb-weather-temp {
    color: {{accent}};
    font-size: 26px;
    font-weight: bold;
}
.sb-weather-desc {
    color: {{fg_dim}};
    font-size: 12px;
    padding-bottom: 4px;
}
.sb-weather-detail {
    color: {{fg}};
    font-size: 12px;
}

/* ── Red ──────────────────────────────────────── */
.sb-net-box {
    padding: 4px 6px;
}
.sb-net-ip {
    color: {{fg}};
    font-size: 12px;
    font-weight: bold;
    padding-bottom: 4px;
}
.sb-net-up-icon   { color: {{teal}};   font-size: 22px; }
.sb-net-down-icon { color: {{accent}}; font-size: 22px; }
.sb-net-graph-up {
    color: {{teal}};
    padding: 4px;
}
.sb-net-graph-down {
    color: {{accent}};
    padding-bottom: 4px;
}

/* ── Storage ──────────────────────────────────── */
.sb-storage {
    padding: 10px 16px 12px 16px;
}

/* ── Launchers ────────────────────────────────── */
.sb-launchers {
    padding: 10px 8px 14px 8px;
}
.sb-launcher-btn {
    border-radius: 12px;
    padding: 8px;
    background-color: {{surface3}};
    border: 1px solid {{surface}};
}
.sb-launcher-btn:hover {
    background-color: {{surface}};
    border: 1px solid {{accent}};
}
