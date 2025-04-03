{ pkgs, ... }: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    package = pkgs.unstable.neovim-unwrapped;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      tokyonight-nvim
    ];

    extraLuaConfig = ''
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras" },
        },

        defaults = {
          lazy = true,
          version = false,
        },

        install = { colorscheme = { "tokyonight" } },
        checker = { enabled = true },
        
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "matchit",
              "matchparen",
              "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
  };
}
