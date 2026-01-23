local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config = {
  color_scheme = 'Batman',
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE",
  window_background_opacity = 0.9,
  font = wezterm.font('JetBrains Mono', { weight = 'Regular', italic = false }),
  font_size = 14.0,
  initial_cols = 150,
  initial_rows = 35,

  keys = {
    -- Tab management
    { key = "t", mods = "SUPER|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "SUPER|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
    { key = "1", mods = "SUPER|SHIFT", action = act.ActivateTab(0) },
    { key = "2", mods = "SUPER|SHIFT", action = act.ActivateTab(1) },
    { key = "3", mods = "SUPER|SHIFT", action = act.ActivateTab(2) },
    { key = "4", mods = "SUPER|SHIFT", action = act.ActivateTab(3) },
    { key = "5", mods = "SUPER|SHIFT", action = act.ActivateTab(4) },
    { key = "6", mods = "SUPER|SHIFT", action = act.ActivateTab(5) },
    { key = "7", mods = "SUPER|SHIFT", action = act.ActivateTab(6) },
    { key = "8", mods = "SUPER|SHIFT", action = act.ActivateTab(7) },
    { key = "9", mods = "SUPER|SHIFT", action = act.ActivateTab(8) },
    { key = "[", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "SUPER|SHIFT", action = act.ActivateTabRelative(1) },

    -- Pane management
    { key = "d", mods = "SUPER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "x", mods = "SUPER|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "h", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "SUPER|SHIFT", action = act.ActivatePaneDirection("Down") },
    { key = "LeftArrow", mods = "SUPER|SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "SUPER|SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = "SUPER|SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = "SUPER|SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 5 }) },

    -- Copy/Paste
    { key = "c", mods = "SUPER|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SUPER|SHIFT", action = act.PasteFrom("Clipboard") },

    -- Search and URL
    { key = "f", mods = "SUPER|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "u", mods = "SUPER|SHIFT", action = act.QuickSelectArgs({
        patterns = { "https?://\\S+" },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      })
    },

    -- Fullscreen and font size
    { key = "Enter", mods = "SUPER|ALT", action = act.ToggleFullScreen },
    { key = "=", mods = "SUPER|ALT", action = act.IncreaseFontSize },
    { key = "-", mods = "SUPER|ALT", action = act.DecreaseFontSize },
    { key = "0", mods = "SUPER|ALT", action = act.ResetFontSize },
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
