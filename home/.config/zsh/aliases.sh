#!/usr/bin/env zsh

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# ls/lsd
if command -v lsd &>/dev/null; then
  alias ls='lsd --group-dirs=first --color=auto'
  alias l='lsd -l --group-dirs=first --color=auto'
  alias ll='lsd -lA --header --classify --size=short --group-dirs=first --date="+%Y-%m-%d %H:%M" --color=auto'
  alias la='lsd -A --group-dirs=first --color=auto'
  alias lt='lsd --tree --depth=2 --group-dirs=first --color=auto'
  alias lta='lsd --tree --depth=2 -A --group-dirs=first --color=auto'
  alias tree='lsd --tree --color=auto'
else
  alias ls='ls --color=auto --group-directories-first'
  alias l='ls -lh'
  alias ll='ls -lAh'
  alias la='ls -A'
fi

# Modern tools
command -v fd &>/dev/null && alias find='fd'
command -v rg &>/dev/null && alias grep='rg'
command -v bat &>/dev/null && alias cat='bat --style=auto'
command -v btop &>/dev/null && alias top='btop'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ip='ip -color=auto'
alias diff='diff --color=auto'

# Safety
alias rm='rm -Iv --one-file-system --preserve-root'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias mkdir='mkdir -pv'

# Quick commands
alias v='$EDITOR'
alias vi='$EDITOR'
alias cl='clear'
alias x='exit'
alias reload='exec zsh'

# Nix
alias nc='nix-collect-garbage'
alias ncd='nix-collect-garbage -d'
alias hm='home-manager'
alias hms='home-manager switch'

# Git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias gp='git push'
alias gst='git status'
alias glog='git log --oneline --decorate --graph'

# Kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ka='kubectl apply -f'
alias kl='kubectl logs'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Development - R
alias r='R --vanilla'
alias rdev='R -q --no-save'

# Development - Python
alias py='python3'
alias venv='python3 -m venv'

# Development - Node/Bun
alias b='bun'
alias br='bun run'
alias bi='bun install'

# Development - Rust
alias c='cargo'
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'

# tmux
alias tm='tmux'
alias tma='tmux attach -t'
alias tml='tmux list-sessions'

# Network
alias myip='curl -s https://api.ipify.org && echo'
alias serve='python3 -m http.server'
