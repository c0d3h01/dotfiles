{ config
, lib
, ...
}: {

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
        path = "${config.xdg.dataHome}/zsh/history";
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
        ll = "eza -l --icons --group-directories-first --git";
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
        v = "nvim";
      };

      # Environment setup
      envExtra = ''
        export MANPAGER="nvim +Man!"
        export PATH="$HOME/.local/bin:$PATH"
      '';

      # Functional config
      initExtra = ''
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

        # Improved Vi mode
        bindkey -v
        bindkey '^?' backward-delete-char
        bindkey '^h' backward-delete-char
        bindkey '^w' backward-kill-w
        # Directory stack
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS

        if [ -n "command fzf-share" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi
      '';
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe"
        "--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef"
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--pretty"
      ];
    };

    eza = {
      enable = true;
      extraOptions = [
        "--classify"
        "--color-scale"
        "--git"
        "--group-directories-first"
      ];
    };

    # Starship prompt
    starship = {
      enable = true;
      settings =
        let
          darkgray = "242";
        in
        {
          format = lib.concatStrings [
            "$username"
            "($hostname )"
            "$directory"
            "($git_branch )"
            "($git_state )"
            "($git_status )"
            "($git_metrics )"
            "($cmd_duration )"
            "$line_break"
            "($python )"
            "($nix_shell )"
            "($direnv )"
            "$character"
          ];

          directory = {
            style = "blue";
            read_only = " !";
          };

          character = {
            success_symbol = "[❯](purple)";
            error_symbol = "[❯](red)";
            vicmd_symbol = "[❮](green)";
          };

          git_branch = {
            format = "[$branch]($style)";
            style = darkgray;
          };

          git_status = {
            format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted )](218)($ahead_behind$stashed)]($style)";
            style = "cyan";
            conflicted = "​";
            untracked = "​";
            modified = "​";
            staged = "​";
            renamed = "​";
            deleted = "​";
            stashed = "≡";
          };

          git_state = {
            format = "[$state( $progress_current/$progress_total)]($style)";
            style = "dimmed";
            rebase = "rebase";
            merge = "merge";
            revert = "revert";
            cherry_pick = "pick";
            bisect = "bisect";
            am = "am";
            am_or_rebase = "am/rebase";
          };

          git_metrics.disabled = false;

          cmd_duration = {
            format = "[$duration]($style)";
            style = "yellow";
          };

          python = {
            format = "[$virtualenv]($style)";
            style = darkgray;
          };

          nix_shell = {
            format = "❄️";
            style = darkgray;
            heuristic = true;
          };

          direnv = {
            format = "[($loaded/$allowed)]($style)";
            style = darkgray;
            disabled = false;
            loaded_msg = "";
            allowed_msg = "";
          };

          username = {
            format = "[$user]($style)";
            style_root = "yellow italic";
            style_user = darkgray;
          };

          hostname = {
            format = "@[$hostname]($style)";
            style = darkgray;
          };
        };
    };
  };
}
