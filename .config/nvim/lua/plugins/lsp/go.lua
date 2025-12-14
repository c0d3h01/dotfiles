local common = require("plugins.lsp.common")

return {
  "neovim/nvim-lspconfig",
  ft = { "go", "gomod" },
  opts = {
    servers = {
      gopls = {
        on_attach = function(client, bufnr)
          common.on_attach(client, bufnr)

          -- gofmt on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format()
            end,
          })
        end,
        settings = {
          gopls = {
            staticcheck = true,
            gofumpt = true,
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
            },
          },
        },
      },
    },
  },
}
