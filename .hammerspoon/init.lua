local hyper = { "ctrl", "alt" }

local apps = {
  c = "Visual Studio Code",
  t = "Ghostty",
  b = "Google Chrome",
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

-- apps that should NOT be resized
local ignore = {
  ["Finder"] = true,
  ["System Settings"] = true,
  ["Hammerspoon"] = true,
}

-- maximize any app's window when it launches
appWatcher = hs.application.watcher.new(function(name, event, app)
  if event == hs.application.watcher.launched and not ignore[name] then
    hs.timer.doAfter(0.7, function()   -- wait for the window to appear
      local win = app:mainWindow()
      if win and win:isStandard() then
        win:maximize()
      end
    end)
  end
end)
appWatcher:start()

hs.alert.show("Hammerspoon loaded")
