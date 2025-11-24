vim.g.mapleader = " "

-- New tab
vim.keymap.set("n", "<C-t>", ":tabnew%<CR>", { noremap = true, silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight on mouse double click
vim.keymap.set("n", "<2-LeftMouse>", "*#", { desc = "Highligh on double click" })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Live grep directory of currently open file
vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, { noremap = true, silent = true, desc = "Live grep in current file" })

-- Live grep current directory opend in oil
vim.keymap.set("n", "<leader>dg", function()
	local oil = require("oil")
	local oil_dir = oil.get_current_dir()
	require("telescope.builtin").live_grep({ search_dirs = { oil_dir } })
end, { noremap = true, silent = true, desc = "Live grep in oil directory" })
