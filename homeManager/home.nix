{
  lib,
  pkgs,
  declarative,
  inputs,
  ...
}:

{
  imports = [
    ./spicetify.nix
  ];

  # services.syncthing.enable = true;

  home = {
    username = declarative.username;
    homeDirectory = "/home/${declarative.username}";
    stateVersion = lib.trivial.release;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      # Let install Home manager
      home-manager

      # Terminal Utilities
      neovim
      vim
      tmux
      coreutils
      fastfetch
      xclip
      curl
      wget
      tree
      stow
      zellij
      bat
      zoxide
      ripgrep
      fd
      file
      bashInteractive
      lsd
      tea
      less
      binutils
      findutils
      hub
      xdg-utils
      pciutils
      inxi
      procs
      glances
      cheat
      tree-sitter
      devenv
      just
      just-formatter
      pre-commit
      starship
      fzf

      # Language Servers
      lua-language-server
      nil

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract

      # git
      git
      git-lfs
      gh
      delta
      mergiraf
      lazygit
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.log_filter = "ignore-everything-forever";
    };
  };
}
