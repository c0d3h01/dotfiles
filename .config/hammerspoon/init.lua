local hyper = { "ctrl", "alt", "cmd" }

-- window halves
hs.window.animationDuration = 0
local function move(x, y, w, h)
  local win = hs.window.focusedWindow()
  if win then win:move(hs.geometry.rect(x, y, w, h)) end
end
hs.hotkey.bind(hyper, "h", function() move(0, 0, 0.5, 1) end)
hs.hotkey.bind(hyper, "l", function() move(0.5, 0, 0.5, 1) end)
hs.hotkey.bind(hyper, "k", function() move(0, 0, 1, 0.5) end)
hs.hotkey.bind(hyper, "j", function() move(0, 0.5, 1, 0.5) end)
hs.hotkey.bind(hyper, "f", function()
  local win = hs.window.focusedWindow()
  if win then win:maximize() end
end)

-- auto-reload
hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", hs.reload):start()
hs.alert.show("Hammerspoon loaded")
