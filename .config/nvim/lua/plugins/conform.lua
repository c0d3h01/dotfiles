return {
	-- Autoformat
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			rust = { "rustfmt", lsp_format = "fallback" },
			["*"] = { "trim_whitespace" },
		},
	},
}
