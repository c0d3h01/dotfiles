return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"vim",
				"diff",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"bash",
				"css",
				"html",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"rust",
				"solidity",
			},
			auto_install = true,
			highlight = { enabled = true },
			indent = { enabled = true },
		})
	end,
}
