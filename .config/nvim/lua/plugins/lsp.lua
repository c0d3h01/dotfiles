return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    opts = { ui = { border = "rounded" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({ automatic_enable = false })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- one server per filetype; vim.lsp.enable resolves and installs on demand
      local servers_by_ft = {
        lua = { "lua_ls" },
        python = { "pyright" },
        javascript = { "ts_ls" },
        javascriptreact = { "ts_ls" },
        typescript = { "ts_ls" },
        typescriptreact = { "ts_ls" },
        go = { "gopls" },
        rust = { "rust_analyzer" },
        json = { "jsonls" },
        yaml = { "yamlls" },
        html = { "html" },
        css = { "cssls" },
        scss = { "cssls" },
        less = { "cssls" },
        bash = { "bashls" },
        sh = { "bashls" },
        zsh = { "bashls" },
        markdown = { "marksman" },
        dockerfile = { "dockerls" },
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("EnableLsp", { clear = true }),
        callback = function(args)
          local servers = servers_by_ft[vim.bo[args.buf].filetype]
          if servers then
            vim.lsp.enable(servers)
          end
        end,
      })

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local function map(modes, lhs, rhs, desc)
            vim.keymap.set(modes, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gr", vim.lsp.buf.references, "List references")
          map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })
    end,
  },
}
