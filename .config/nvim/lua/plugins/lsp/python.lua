local common = require("plugins.lsp.common")

return {
  "neovim/nvim-lspconfig",
  ft = { "python" },
  opts = {
    servers = {
      pyright = {
        on_attach = common.on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- change to "strict" when ready
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    },
  },
}
