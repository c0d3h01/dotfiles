-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Disable auto comment next line
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Solidity
vim.api.nvim_create_autocmd("FileType", {
	pattern = "solidity",
	command = "setlocal shiftwidth=4 tabstop=4",
})

-- Typescript
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "css" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

-- Disable oil status on bottom of the screen
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.laststatus = 0
	end,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
