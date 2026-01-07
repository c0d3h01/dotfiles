return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bashls = {},
      gopls = {
        on_attach = function(client, bufnr)
          -- Ensure `common` is defined or imported somewhere in your config
          -- If not, replace `common.on_attach` with your actual on_attach function
          if common and common.on_attach then
            common.on_attach(client, bufnr)
          end

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
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--pch-storage=memory",
        },
        on_attach = function(client, bufnr)
          if common and common.on_attach then
            common.on_attach(client, bufnr)
          end
        end,
      },
      pyright = {
        on_attach = function(client, bufnr)
          if common and common.on_attach then
            common.on_attach(client, bufnr)
          end
        end,
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
