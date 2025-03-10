{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Enhanced plugin selection for VS Code-like experience
    plugins = with pkgs.vimPlugins; [
      # Core plugins
      vim-sensible
      vim-commentary
      vim-surround
      vim-lastplace
      vim-sleuth
      direnv-vim

      # VS Code-like UI
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-web-devicons
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua

      # Development features
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      gitsigns-nvim
      which-key-nvim
      indent-blankline-nvim
      toggleterm-nvim

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Theme
      tokyonight-nvim
      mini-icons
    ];

    # VS Code-like configuration with properly escaped Lua
    extraLuaConfig = ''
      -- Set theme
      vim.cmd('colorscheme tokyonight')

      -- Core settings
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.expandtab = true
      vim.o.shiftwidth = 2
      vim.o.tabstop = 2
      vim.o.ignorecase = true
      vim.o.smartcase = true
      vim.o.mouse = 'a'
      vim.o.termguicolors = true
      vim.o.updatetime = 100
      vim.o.clipboard = 'unnamedplus'
      vim.o.cursorline = true
      vim.o.signcolumn = 'yes'
      vim.wo.wrap = false
      
      -- Leader key
      vim.g.mapleader = ' ';
      
      -- Status line (Lualine)
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          component_separators = { left = '|', right = '|' },
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
            },
          },
        },
      })

      -- Tab line (Bufferline)
      require('bufferline').setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
        },
      })

      -- File explorer
      require('nvim-tree').setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
      })

      -- Git integration
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })

      -- Terminal
      require('toggleterm').setup({
        size = 15,
        open_mapping = [[<c-`>]],
        direction = 'float',
      })

      -- Command palette
      require('which-key').setup({})
      require('which-key').register({
        f = {
          name = "File",
          f = { "<cmd>Telescope find_files<cr>", "Find File" },
          g = { "<cmd>Telescope live_grep<cr>", "Search in Files" },
          e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        },
        e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        b = {
          name = "Buffers",
          n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
          p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
          c = { "<cmd>bdelete<cr>", "Close" },
        },
      }, { prefix = "<leader>" })

      -- LSP setup
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Language servers
      require('lspconfig').ts_ls.setup({ capabilities = capabilities })
      require('lspconfig').rust_analyzer.setup({ capabilities = capabilities })
      require('lspconfig').nil_ls.setup({ capabilities = capabilities })

      -- LSP keybindings
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })

      -- Diagnostics
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })

      -- Completion setup
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      -- Indent guides
      require('indent_blankline').setup({
        char = '│',
        show_current_context = true,
      })

      -- Telescope file finder
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      })
      require('telescope').load_extension('fzf')

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
      vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, {})

      -- VS Code-like keymaps
      vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

      -- Split navigation
      vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
      vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

      -- Syntax highlighting
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    '';
  };
}
