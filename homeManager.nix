{ pkgs, ... }:
let
  inherit (pkgs) lib stdenv;
in
{
  imports = [ ./modules/default.nix ];

  home.username = "c0d3h01";
  home.homeDirectory = "/home/c0d3h01";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages =
    (with pkgs; [
      zsh-autosuggestions
      zsh-completions
      nix-zsh-completions
      zsh-fast-syntax-highlighting
      zsh-fzf-tab
      bash-completion
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.symbols-only
      cascadia-code
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      kubectl
      bash-language-server
      tmux
      zsh
      fzf
      fd
      file
      neovim
      ripgrep
      bat
      less
      direnv
      starship
      gitFull
      git-lfs
      git-crypt
      icdiff
      lazygit
      nushell
      lsd
      nil
      yt-dlp
      gnutar
      gzip
      bzip2
      xz
      zstd
      zip
      unzip
      p7zip
    ])
    ++ lib.optionals stdenv.isLinux (
      with pkgs;
      [
        brave
        xclip
      ]
    );
}
