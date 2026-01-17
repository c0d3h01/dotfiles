local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config = {
  color_scheme = 'Batman',
  hide_tab_bar_if_only_one_tab  = true,
  window_decorations = "RESIZE",
  window_background_opacity = 0.9
  font = wezterm.font('JetBrains Mono', { weight = 'Regular', italic = false }),
  font_size = 14.0,
  initial_cols = 150,
  initial_rows = 35,

  keys = {
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
  },
  mouse_bindings = {
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
  },
}

return config
