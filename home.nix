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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    tmux
    fzf
    neovim
    ripgrep
    bat
    yt-dlp
    gitFull
    git-lfs
    git-crypt
    lazygit
    nushell
    lsd
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  home.file = {
    # ".zshrc".source = .zshrc;
    # ".zprofile".source = .zprofile;
    # ".tmux.conf".source = .tmux.conf;
    # ".config/ghostty".source = .config/ghostty;
    # ".config/bat".source = .config/bat;
    # ".config/alacritty".source = .config/alacritty;
    # ".config/lazygit".source = .config/lazygit;
    # ".config/git".source = .config/git;
  };
}
