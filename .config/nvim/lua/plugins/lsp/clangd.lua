local common = require("plugins.lsp.common")

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--pch-storage=memory",
        },
        on_attach = common.on_attach,
      },
    },
  },
}
