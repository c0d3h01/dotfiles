return {
	"rebelot/kanagawa.nvim",
	-- "catppuccin/nvim",
	-- "projekt0n/github-nvim-theme",
	-- "folke/tokyonight.nvim",
	-- "Mofiqul/dracula.nvim",
	-- "olimorris/onedarkpro.nvim",
	-- "ellisonleao/gruvbox.nvim",
	lazy = false,
	config = function()
		vim.o.background = "dark"
		vim.cmd.colorscheme("kanagawa-wave")
		-- vim.cmd.colorscheme("catppuccin-mocha")
		-- vim.cmd.colorscheme("github_dark_default")
		-- vim.cmd.colorscheme("tokyonight-night")
		-- vim.cmd.colorscheme("dracula")
		-- vim.cmd.colorscheme("onedark")
		-- vim.cmd.colorscheme("gruvbox")
	end,
}
