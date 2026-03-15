return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    opts = {
      ui = {
        border = "rounded",
      },
    },
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
      local mason_lspconfig = require("mason-lspconfig")
      local registry = require("mason-registry")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      mason_lspconfig.setup({
        ensure_installed = { "lua_ls" },
        automatic_enable = false,
      })

      local server_settings = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      local preferred_servers_by_ft = {
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

      local disabled_auto_install_filetypes = {
        text = true,
        gitcommit = true,
        help = true,
      }

      local blocked_auto_install_servers = {
        textlsp = true,
      }

      local package_by_server = mason_lspconfig.get_mappings().lspconfig_to_package
      local configured_servers = {}
      local installing_servers = {}
      local registry_ready = false
      local registry_refreshing = false
      local registry_waiters = {}

      local function with_registry(callback)
        if registry_ready then
          callback(true)
          return
        end

        if registry_refreshing then
          table.insert(registry_waiters, callback)
          return
        end

        registry_refreshing = true
        table.insert(registry_waiters, callback)

        registry.refresh(function(success)
          registry_ready = success == true
          registry_refreshing = false

          local waiters = registry_waiters
          registry_waiters = {}
          for _, waiter in ipairs(waiters) do
            waiter(success)
          end
        end)
      end

      local function configure_server(server_name)
        if configured_servers[server_name] then
          return
        end

        local opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_settings[server_name] or {})

        vim.lsp.config(server_name, opts)
        vim.lsp.enable(server_name)
        configured_servers[server_name] = true
      end

      local function ensure_server(server_name)
        if configured_servers[server_name] or installing_servers[server_name] then
          return
        end

        if blocked_auto_install_servers[server_name] then
          return
        end

        local package_name = package_by_server[server_name]
        if not package_name then
          configure_server(server_name)
          return
        end

        with_registry(function(success)
          if not success then
            return
          end

          if registry.is_installed(package_name) then
            configure_server(server_name)
            return
          end

          local ok, pkg = pcall(registry.get_package, package_name)
          if not ok then
            vim.notify(("No Mason package found for %s"):format(server_name), vim.log.levels.WARN)
            return
          end

          installing_servers[server_name] = true
          pkg:install({}, function(install_ok, result)
            vim.schedule(function()
              installing_servers[server_name] = nil
              if install_ok then
                configure_server(server_name)
              else
                vim.notify(("Failed to install %s: %s"):format(server_name, tostring(result)), vim.log.levels.ERROR)
              end
            end)
          end)
        end)
      end

      local function servers_for_filetype(filetype)
        if disabled_auto_install_filetypes[filetype] then
          return {}
        end

        local preferred = preferred_servers_by_ft[filetype]
        if preferred and #preferred > 0 then
          return preferred
        end

        local ok, available = pcall(mason_lspconfig.get_available_servers, { filetype = filetype })
        if ok and type(available) == "table" and #available > 0 then
          for _, server_name in ipairs(available) do
            if not blocked_auto_install_servers[server_name] then
              return { server_name }
            end
          end
        end

        return {}
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("AutoInstallLsp", { clear = true }),
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          if filetype == "" then
            return
          end

          for _, server_name in ipairs(servers_for_filetype(filetype)) do
            ensure_server(server_name)
          end
        end,
      })

      with_registry(function() end)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
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

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    end,
  },
}
