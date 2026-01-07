return {
  "mrcjkb/rustaceanvim",
  ft = { "rust" },
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { buffer = bufnr, desc = "Code Action" })

          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { buffer = bufnr, desc = "Rust Debuggables" })
        end,

        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = false },
            },
            checkOnSave = false,
            diagnostics = { enable = true },
            procMacro = { enable = true },
            files = {
              watcher = "client",
            },
          },
        },
      },
    }
  end,
}
