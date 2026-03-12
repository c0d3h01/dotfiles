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
    # [* GUI Apps *]
    # alacritty
    # vscodium
    # wezterm
    # kitty
    # ghostty
    brave

    # [* Shell plugins *]
    zsh-autosuggestions
    zsh-completions
    nix-zsh-completions
    zsh-fast-syntax-highlighting
    zsh-fzf-tab
    bash-completion

    # [* Cli *]
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
    xclip
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  home.file = {
    ".zshrc".source = ./.zshrc;
    ".zprofile".source = ./.zprofile;
    ".bashrc".source = ./.bashrc;
    ".tmux.conf".source = ./.tmux.conf;
    ".dircolors".source = ./.dircolors;
    ".shell_alias.sh".source = ./.shell_alias.sh;
    ".shell_export.sh".source = ./.shell_export.sh;
    ".shell_function.sh".source = ./.shell_function.sh;
    ".gdbinit".source = ./.gdbinit;
    ".config/VSCodium".source = ./.config/VSCodium;
    ".config/alacritty".source = ./.config/alacritty;
    ".config/bat".source = ./.config/bat;
    ".config/chrome-flags.conf".source = ./.config/chrome-flags.conf;
    ".config/chromium-flags.conf".source = ./.config/chromium-flags.conf;
    ".config/direnv".source = ./.config/direnv;
    ".config/flake8".source = ./.config/flake8;
    ".config/ghostty".source = ./.config/ghostty;
    ".config/git".source = ./.config/git;
    ".config/isort.cfg".source = ./.config/isort.cfg;
    ".config/kitty".source = ./.config/kitty;
    ".config/lazygit".source = ./.config/lazygit;
    ".config/lsd".source = ./.config/lsd;
    ".config/nix".source = ./.config/nix;
    ".config/nixpkgs".source = ./.config/nixpkgs;
    ".config/nushell".source = ./.config/nushell;
    ".config/nvim".source = ./.config/nvim;
    ".config/pacman".source = ./.config/pacman;
    ".config/ripgrep".source = ./.config/ripgrep;
    ".config/starship.toml".source = ./.config/starship.toml;
    ".config/wezterm".source = ./.config/wezterm;
    ".config/yt-dlp".source = ./.config/yt-dlp;
  };
}
