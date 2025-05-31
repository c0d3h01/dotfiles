# shellcheck disable=SC1036

# ===== Core Configuration =====
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export CHROME_EXECUTABLE="$(which firefox)"
export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which javac))))"
export NIX_USER_PROFILE_DIR=${NIX_USER_PROFILE_DIR:-/nix/var/nix/profiles/per-user/${USER}}
export NIX_PROFILES=${NIX_PROFILES:-$HOME/.nix-profile}
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# Android SDK
export ANDROID_HOME="$HOME/Android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$HOME/Android/flutter/bin:$PATH"

# ===== Path Configuration =====
path=(
    $HOME/.local/bin
    $HOME/.rustup
    $HOME/.cargo/bin
    $HOME/go/bin
    $HOME/.npm-global/bin
    $HOME/bin
    $HOME/.cabal/bin
    $HOME/.gem/ruby/*.*.*/bin(NOn[1])
    $path
)

typeset -U path   # unique entries only
path=($^path(N))  # remove nonexistent paths
export PATH

# ===== Tool Configurations =====
export LESS="-R -F"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ===== Zsh Features =====
autoload -Uz colors && colors

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTORY_IGNORE="(rm *|pkill *|kill *|shutdown *|reboot *|exit)"
setopt append_history           # Append to history file instead of overwriting
setopt extended_history         # Save timestamp and duration of commands
setopt hist_expire_dups_first   # Delete duplicates first when history is full
setopt hist_ignore_all_dups
# setopt hist_ignore_space
setopt hist_verify              # Show command before executing
setopt inc_append_history       # Add commands to history immediately
setopt share_history            # Share history between sessions

# Completion system
autoload -Uz compinit
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
compinit -d "$HOME/.cache/zsh/.zcompdump"

# Options
setopt auto_pushd           # push dir stack
setopt pushd_ignore_dups    # no dup dirs
setopt pushd_silent         # quiet pushd
setopt cdable_vars          # cd to $var
setopt autocd               # auto 'cd' dirs
setopt extended_glob        # advanced globbing
setopt interactive_comments # allow # comments
setopt short_loops          # short for loops
setopt rc_quotes            # rc-style quotes
setopt no_flow_control      # disable Ctrl-S/Q
setopt no_beep              # disable bell
setopt ignore_eof           # disable Ctrl-D exit
setopt multios              # multi redirects
setopt no_hup               # no HUP on exit
setopt rm_star_silent       # no rm * warning
setopt complete_in_word
unsetopt always_to_end

# ===== Key Bindings =====
bindkey -v
export KEYTIMEOUT=1
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^f' vi-forward-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ===== Aliases =====
# Navigation
alias ..='cd ..' ...='cd ../..' ....='cd ../../..' -- -='cd -'

# Modern ls replacements with lsd
alias l='lsd -l --group-dirs first --color auto'
alias ls='lsd --group-dirs first --color auto'
alias ll='lsd -l --header --classify --size short --group-dirs first --date "+%Y-%m-%d %H:%M" --all --color auto'
alias la='lsd -a --group-dirs first --color auto'
alias lt='lsd --tree --depth 2 --group-dirs first --color auto'
alias lta='lsd --tree --depth 2 -a --group-dirs first --color auto'
alias ltg='lsd --tree --depth 2 --ignore-glob ".git" --group-dirs first --color auto'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gs='git status -sb'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gph='git push'
alias gpl='git pull --rebase'
alias gl='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias gst='git stash'
alias gsp='git stash pop'

# System utilities
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias top='htop'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias find='fd'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias wget='wget -c'
alias ports='ss -tulpn'
alias untar='tar -xvf'

# Safety nets
alias rm='rm -Iv --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# Modern alternatives
alias vi='nvim'
alias vim='nvim'

# Handy shortcuts
alias cl='clear'
alias x='exit'
alias nc='nix-collect-garbage'
alias home-check='journalctl -u home-manager-$USER.service'
alias hm='home-manager'
alias ts='date '\''+%Y-%m-%d %H:%M:%S'\'
alias reload='source ~/.zshrc'

if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

if [[ -e /etc/profile.d/nix.sh ]]; then
  . /etc/profile.d/nix.sh
fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

if [ -f ~/.nix-profile/zsh/ghostty-integration ]; then
  . ~/.nix-profile/zsh/ghostty-integration
fi

if [[ $OSTYPE == darwin* ]]; then
  export NIX_PATH="$NIX_PATH:darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"
fi

if [[ -S /nix/var/nix/daemon-socket/socket ]]; then
  export NIX_REMOTE=daemon
fi

# ===== Functions =====
path() {
  echo -e ${PATH//:/\\n} | bat
}

extract() {
  local file="$1" dir="${2:-.}"
  [[ ! -f "$file" ]] && echo "Error: '$file' not valid" >&2 && return 1

  case "$file" in
    *.tar.bz2|*.tbz2)  tar -xjf "$file" -C "$dir" ;;
    *.tar.gz|*.tgz)    tar -xzf "$file" -C "$dir" ;;
    *.tar.xz|*.txz)    tar -xJf "$file" -C "$dir" ;;
    *.bz2)             bunzip2 -k "$file" ;;
    *.rar)             unrar x "$file" "$dir" ;;
    *.gz)              gunzip -k "$file" ;;
    *.tar)             tar -xf "$file" -C "$dir" ;;
    *.zip)             unzip "$file" -d "$dir" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              7z x "$file" -o"$dir" ;;
    *.deb)             ar x "$file" ;;
    *)                 echo "Cannot extract '$file'" >&2 && return 1 ;;
  esac && echo "Extracted '$file' to '$dir'"
}

mkcd() { mkdir -p "$1" && cd "$1" }

fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse) && cd "$dir"
}

glf() {
  git log --color=always --format="%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset" "$@" | \
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview "git show --color=always {1}" \
        --bind "enter:execute(git show {1})+accept"
}

colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
    (( (i + 1) % 16 == 0 )) && printf "\n"
  done
}

flake-check() {
    if [ $# -lt 1 ]; then
      nix flake check
    fi
    for arg in "$@"; do
      nix build ".#checks.$(nix eval --impure --raw --expr builtins.currentSystem).$1"
    done
}

make(){
  local build_path="$(dirname "$(upfind "Makefile")")"
  command nice -n19 make -C "${build_path:-.}" -j$(nproc) "$@"
}

if [ -n "${commands[bat]}" ]; then
  cat() {
    if [[ -t 1 ]] && [[ -o interactive ]]; then
      bat "$@"
    else
      command cat "$@"
    fi
  }
fi

if [ -n "${commands[fastfetch]}" ]; then
  ff() {
    if [[ -t 1 ]] && [[ -o interactive ]]; then
      fastfetch "$@"
    else
      command fastfetch "$@"
    fi
  }
fi

if [ -n "${commands[rg]}" ]; then
  grep() {
    if [[ -t 1 ]] && [[ -o interactive ]]; then
      rg "$@"
    else
      command grep "$@"
    fi
  }
fi

if [ -n "${commands[direnv]}" ]; then
  eval "$(direnv hook zsh)"
fi

if [[ $commands[kubectl] ]]; then
   alias k=kubectl
   source <(kubectl completion zsh)
fi

# ===== Tool Initialization =====
# Initialize zoxide (if installed)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd j)"

# Initialize direnv (if installed)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ===== Starship Prompt ===== ( I dont use starship btw)
# command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ===== Custom Plugin Submodules =====
# zsh-completions
fpath+=("$HOME/.zsh-completions")

# zsh-autosuggestions
source "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=60

if [[ -n "${commands[fzf-share]}" ]]; then
  FZF_CTRL_R_OPTS=--reverse
  if [[ -n "${commands[fd]}" ]]; then
    export FZF_DEFAULT_COMMAND='fd --type f'
  fi
  source "$(fzf-share)/key-bindings.zsh"
fi

# Pure Prompt
fpath+=("$HOME/.zsh-pure")
zstyle :prompt:pure:path color yellow
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:user color cyan
zstyle :prompt:pure:host color yellow
zstyle :prompt:pure:git:branch:cached color red
autoload -U promptinit; promptinit
prompt pure

# zsh-autopair
source "$HOME/.zsh-autopair/autopair.zsh"

# fast-syntax-highlighting
source "$HOME/.zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# fzf-tab
source "$HOME/.zsh-fzf-tab/fzf-tab.zsh"

# prevent broken terminals by resetting to sane defaults after a command
ttyctl -f
