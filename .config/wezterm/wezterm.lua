local wezterm = require("wezterm")
local act = wezterm.action

local c = wezterm.config_builder and wezterm.config_builder() or {}

c.front_end = "WebGpu"
c.webgpu_power_preference = "HighPerformance"
c.animation_fps = 1
c.cursor_blink_rate = 0
c.cursor_blink_ease_in = "Constant"
c.cursor_blink_ease_out = "Constant"

c.use_fancy_tab_bar = false
c.tab_bar_at_bottom = false
c.show_tab_index_in_tab_bar = true
c.tab_max_width = 32
c.hide_tab_bar_if_only_one_tab = true

c.check_for_updates = false
c.audible_bell = "Disabled"
c.visual_bell = {
  fade_in_duration_ms = 0,
  fade_out_duration_ms = 0,
}

c.window_decorations = "RESIZE"
c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
c.window_close_confirmation = "NeverPrompt"
c.window_background_opacity = 1.0
c.scrollback_lines = 10000

c.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
c.font_size = 12
c.line_height = 1.0
c.cell_width = 1.0
c.adjust_window_size_when_changing_font_size = false
c.freetype_load_target = "Normal"
c.freetype_render_target = "Normal"
c.freetype_load_flags = "DEFAULT"

c.color_scheme = "Tokyo Night"

c.keys = {
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
  { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
  { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
  { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
  { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
  { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
  { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
  { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
  { key = "9", mods = "SUPER", action = act.ActivateTab(8) },
  { key = "[", mods = "SUPER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "SUPER", action = act.ActivateTabRelative(1) },
  { key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "SUPER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "h", mods = "SUPER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "SUPER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "SUPER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "SUPER", action = act.ActivatePaneDirection("Down") },
  { key = "LeftArrow", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = "SUPER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
  { key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "u", mods = "SUPER", action = act.QuickSelectArgs({
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    })
  },
  { key = "Enter", mods = "SUPER", action = act.ToggleFullScreen },
  { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
  { key = "0", mods = "SUPER", action = act.ResetFontSize },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
}

c.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

local function is_windows()
  return wezterm.target_triple:find("windows") ~= nil
end

local function is_linux()
  return wezterm.target_triple:find("linux") ~= nil
end

local function is_darwin()
  return wezterm.target_triple:find("darwin") ~= nil
end

if is_linux() then
  c.enable_wayland = true
  c.enable_kitty_graphics = false
elseif is_darwin() then
  c.native_macos_fullscreen_mode = false
elseif is_windows() then
  c.default_prog = { "pwsh.exe" }
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_index + 1 .. ": " .. tab.active_pane.title
  if #title > max_width - 2 then
    title = wezterm.truncate_right(title, max_width - 3) .. "…"
  end
  return " " .. title .. " "
end)

return c
