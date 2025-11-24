require("config.options")
require("config.keybinds")
require("config.lazy")
require("config.autocmd")

-- Disable diagnostic signs (E, W, H, I) displayed to the left of row numbers
vim.diagnostic.config({
	signs = false,
})
