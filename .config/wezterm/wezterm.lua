local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local function leader_binds(key, action)
  return {
    { key = "mapped:" .. key, mods = "LEADER", action = action },
    { key = "mapped:" .. key, mods = "LEADER|CTRL", action = action },
  }
end

local function add_all(target, items)
  for _, item in ipairs(items) do
    table.insert(target, item)
  end
end

local keys = {
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  { key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "right", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
  { key = "left", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
  { key = "2", mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
  { key = "3", mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
  { key = "4", mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
  { key = "5", mods = "CTRL|SHIFT", action = act.ActivateTab(4) },
  { key = "6", mods = "CTRL|SHIFT", action = act.ActivateTab(5) },
  { key = "7", mods = "CTRL|SHIFT", action = act.ActivateTab(6) },
  { key = "8", mods = "CTRL|SHIFT", action = act.ActivateTab(7) },
  { key = "9", mods = "CTRL|SHIFT", action = act.ActivateTab(8) },
  { key = "enter", mods = "CTRL|SHIFT", action = act.SpawnWindow },
  { key = "=", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL|SHIFT", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL|SHIFT", action = act.ResetFontSize },
}

-- Tabs
add_all(keys, leader_binds("r", act.ActivateTabRelative(-1)))
add_all(keys, leader_binds("f", act.ActivateTabRelative(1)))

-- Panes
add_all(keys, leader_binds("c", act.SplitHorizontal({ domain = "CurrentPaneDomain" })))
add_all(keys, leader_binds("v", act.SplitVertical({ domain = "CurrentPaneDomain" })))
add_all(keys, leader_binds("x", act.CloseCurrentPane({ confirm = false })))
add_all(keys, leader_binds("z", act.TogglePaneZoomState))
add_all(keys, leader_binds("a", act.ActivatePaneDirection("Left")))
add_all(keys, leader_binds("d", act.ActivatePaneDirection("Right")))
add_all(keys, leader_binds("w", act.ActivatePaneDirection("Up")))
add_all(keys, leader_binds("s", act.ActivatePaneDirection("Down")))

-- Resize with Leader + Shift + WASD
add_all(keys, {
  { key = "mapped:a", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "mapped:a", mods = "LEADER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "mapped:d", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "mapped:d", mods = "LEADER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "mapped:w", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "mapped:w", mods = "LEADER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "mapped:s", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "mapped:s", mods = "LEADER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
})

-- Search/URL/UI
add_all(keys, leader_binds("g", act.Search("CurrentSelectionOrEmptyString")))
add_all(keys, leader_binds("b", act.ToggleFullScreen))
add_all(keys, {
  {
    key = "mapped:u",
    mods = "LEADER",
    action = act.QuickSelectArgs({
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  {
    key = "mapped:u",
    mods = "LEADER|CTRL",
    action = act.QuickSelectArgs({
      patterns = { "https?://\\S+" },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    }),
  },
  { key = "mapped:r", mods = "LEADER|SHIFT", action = act.ReloadConfiguration },
  { key = "mapped:r", mods = "LEADER|CTRL|SHIFT", action = act.ReloadConfiguration },
  -- Send literal Ctrl+a to applications running in the terminal.
  { key = "mapped:;", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "mapped:;", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
})

wezterm.on("update-right-status", function(window, _)
  if window:leader_is_active() then
    window:set_right_status("LEADER")
  else
    window:set_right_status("")
  end
end)

config.color_scheme = "Batman"
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.font = wezterm.font("JetBrains Mono", { weight = "Regular", italic = false })
config.font_size = 14.0
config.initial_cols = 150
config.initial_rows = 35
config.disable_default_key_bindings = false
config.key_map_preference = "Mapped"
config.leader = { key = "mapped:a", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = keys

config.mouse_bindings = {
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

return config
