{ config, pkgs, ... }:

{
  #  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  source ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #  source /etc/profiles/per-user/c0d3h01/etc/profile.d/hm-session-vars.sh

  # Home Manager needs a bit of information about you
  home.username = "c0d3h01";
  home.homeDirectory = "/home/c0d3h01";
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    MANPAGER = "nvim +Man!";
    MANWIDTH = 999;
    BROWSER = "firefox";
    DIFFTOOL = "icdiff";
    LC_ALL = "en_IN.UTF-8";
    LANG = "en_IN.UTF-8";
    TERM = "xterm-256color";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # cli pkgs
    pkgs.tmux
    pkgs.fzf
    pkgs.neovim
    pkgs.ripgrep
    pkgs.bat
    pkgs.yt-dlp
    pkgs.gitFull
    pkgs.git-lfs
    pkgs.git-crypt
    pkgs.lsd

    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  home.file = {
    ".zshrc".source = ".zshrc";
    ".zprofile".source = ".zprofile";
    ".tmux.conf".source = ".tmux.conf";
    # ".config/ghostty".source = ".config/ghostty";
    ".config/git/config".source = ".config/git/config";
    ".config/git/attributes".source = ".config/git/attributes";
    ".config/git/ignore".source = ".config/git/ignore";

    ".gradle/gradle.properties".text = ''
      org.gradle.console=verbose
      org.gradle.daemon.idletimeout=3600000
    '';
  };
}
