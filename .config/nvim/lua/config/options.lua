vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false

-- Tab
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Disable line wrap
vim.opt.wrap = false

-- vim.opt.scrolloff = 10

-- Disable swap files
vim.opt.swapfile = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live as you type
vim.opt.inccommand = "split"

-- Fold
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Only show file name in tabs
function _G.tabline()
	local s = ""
	for i = 1, vim.fn.tabpagenr("$") do
		local tab = i
		local winnr = vim.fn.tabpagewinnr(tab)
		local buflist = vim.fn.tabpagebuflist(tab)
		local bufnr = buflist[winnr]
		local bufname = vim.fn.bufname(bufnr)
		local bufmodified = vim.fn.getbufvar(bufnr, "&mod")

		s = s .. "%" .. tab .. "T"
		s = s .. (tab == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#")
		-- s = s .. " " .. tab .. ":"
		s = s .. (bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]")
		if bufmodified == 1 then
			s = s .. " +"
		end
		s = s .. " "
	end

	s = s .. "%#TabLineFill#"
	return s
end

vim.o.tabline = "%!v:lua.tabline()"
