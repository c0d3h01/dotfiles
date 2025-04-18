{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
  ];

  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      autocd = true;

      history = {
        extended = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        ignoreSpace = true;
        save = 15000;
        size = 15000;
        path = "${config.xdg.dataHome}/.local/share/zsh/history";
        share = true;
      };

      shellAliases = {
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        # Modern ls replacements
        l = "eza -l --icons --group-directories-first";
        ls = "eza --icons --group-directories-first";
        ll = "eza --header --git --classify --long --binary --group --time-style=long-iso --links --all --all --group-directories-first --sort=name";
        la = "eza -a --icons --group-directories-first";
        lt = "eza --tree --icons --level=2";
        # Git shortcuts
        g = "git";
        ga = "git add";
        gs = "git status";
        gc = "git commit";
        gph = "git push";
        gpl = "git pull";
        # Safety nets
        rm = "rm -I";
        cp = "cp -i";
        mv = "mv -i";
        # Modern alternatives
        cat = "bat";
        grep = "rg";
        find = "fd";
        # Handy shortcuts
        ff = "fastfetch";
        cl = "clear";
        x = "exit";
        # Additional useful aliases
        ports = "netstat -tulpn";
        ip = "ip --color=auto";
        diff = "diff --color=auto";
        ping = "ping -c 5";
        mkdir = "mkdir -pv";
        wget = "wget -c";
      };

      # Environment setup
      envExtra = ''
        export MANPAGER="nvim +Man!"
        export PATH="$HOME/.local/bin:$PATH"
        export EDITOR="nvim"
        export VISUAL="nvim"
        export TERM="xterm-256color"
        export LANG="en_IN.UTF-8"
        export LC_ALL="en_IN.UTF-8"
      '';

      # Functional config
      initExtra = ''
        # Improved completion
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "$LS_COLORS"
        zstyle ':completion:*' special-dirs true
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"

        # Improved Vi mode
        bindkey -v
        bindkey '^?' backward-delete-char
        bindkey '^h' backward-delete-char
        bindkey '^w' backward-kill-word

        # History substring search key bindings
        # bindkey '^[[A' history-substring-search-up
        # bindkey '^[[B' history-substring-search-down
        # bindkey -M vicmd 'k' history-substring-search-up
        # bindkey -M vicmd 'j' history-substring-search-down

        # Directory stack
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT
        setopt EXTENDED_GLOB
        setopt NO_BEEP
        setopt MULTIOS
        setopt CORRECT
        setopt CORRECT_ALL
        setopt DVORAK
        setopt NO_HUP
        setopt IGNORE_EOF
        setopt PRINT_EIGHT_BIT
        setopt RC_QUOTES
        setopt RM_STAR_SILENT
        setopt SHORT_LOOPS
        setopt NO_FLOW_CONTROL

        # Lazy load Direnv
        direnv() {
          unset -f direnv
          eval "$(direnv hook zsh)"
          direnv "$@"
        }

        # Lazy load Zoxide
        z() {
          unset -f z
          eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
          z "$@"
        }

        function extract() {
          if [ -f "$1" ] ; then
            case "$1" in
              *.tar.bz2)   tar xjf "$1"     ;;
              *.tar.gz)    tar xzf "$1"     ;;
              *.bz2)       bunzip2 "$1"     ;;
              *.rar)       unrar x "$1"     ;;
              *.gz)        gunzip "$1"      ;;
              *.tar)       tar xf "$1"      ;;
              *.tbz2)      tar xjf "$1"     ;;
              *.tgz)       tar xzf "$1"     ;;
              *.zip)       unzip "$1"       ;;
              *.Z)         uncompress "$1"  ;;
              *.7z)        7z x "$1"        ;;
              *)          echo "'$1' cannot be extracted via extract()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }
      '';
    };
  };
}
