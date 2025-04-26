{
  pkgs,
  userConfig,
  outputs,
  inputs,
  ...
}:
{

  imports = [
    ./config
    ./git
    ./gtk
    ./spicetify
    ./zshell

    # Gnome ( dconf, xdg ) home config
    ../nixos/desktop/gnome/home-gnome.nix
  ];

  home = {
    username = "${userConfig.username}";
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "${userConfig.stateVersion}";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "brave";
      PAGER = "less";
      LESS = "-R";
      JAVA_HOME = "${pkgs.openjdk}/lib/openjdk";
      ANDROID_HOME = "/home/c0d3h01/Android";
      # ANDROID_SDK_ROOT = "/home/c0d3h01/Android";
      # ANDROID_NDK_HOME = "/home/c0d3h01/Android/android-ndk-r27c";
      # PATH = "$HOME/Android/cmdline-tools/bin:$HOME/Android/platform-tools:$HOME/Android/android-ndk-r27c:$PATH";
      CHROME_EXECUTABLE = "${pkgs.brave}/bin/brave";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    packages = with pkgs; [
      # Terminal
      kitty

      # Utilities
      coreutils
      bashInteractive
      fastfetch
      glances
      xclip
      curl
      wget
      tree
      asar
      fuse
      appimage-run
      nh # Nix Garbage Cleaner

      # Editors & Viewers
      fd # find
      file

      # Nix Tools
      nix-prefetch-github

      # Language Servers
      lua-language-server
      nil

      # System Monitoring
      inxi
      procs

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract
    ];
  };

  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        "c0d3h01" = {
          hostname = "c0d3h01";
          user = "root";
          forwardAgent = true;
        };
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        LazyVim
        lazygit-nvim
        tokyonight-nvim
        rocks-nvim
      ];

      extraPackages = with pkgs; [
        tree-sitter
        lazygit
        imagemagick
        xclip
      ];
    };
  };
}
