-- WezTerm terminal emulator configuration.
-- Docs: https://wezfurlong.org/wezterm/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Font ───────────────────────────────────────────────────────────────────
config.font = wezterm.font_with_fallback({
    { family = "Cascadia Code NF", weight = "Regular" },  -- Cascadia Code with Nerd Font icons
    { family = "JetBrainsMono Nerd Font" },               -- fallback
    "Symbols Nerd Font Mono",                             -- icon fallback
})
config.font_size = 14.0

-- ── Colors ─────────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha"

-- ── Window ─────────────────────────────────────────────────────────────────
config.initial_cols = 140
config.initial_rows = 40
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- Clean look: hide the tab bar when only one tab is open
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- ── Performance ────────────────────────────────────────────────────────────
config.max_fps = 120
config.scrollback_lines = 5000

-- ── Behavior ───────────────────────────────────────────────────────────────
config.audible_bell = "Disabled"

-- ── Key bindings ───────────────────────────────────────────────────────────
-- Super+T = new tab, Super+W = close tab, Super+1-9 = switch tab
config.keys = {
    -- Split pane horizontally (side by side)
    { key = "d", mods = "SUPER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Split pane vertically (top/bottom)
    { key = "D", mods = "SUPER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- Navigate between panes with Super+Arrow
    { key = "LeftArrow", mods = "SUPER|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "SUPER|ALT", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "SUPER|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "SUPER|ALT", action = wezterm.action.ActivatePaneDirection("Down") },
}

return config
