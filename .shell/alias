# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# File management
if [[ -n ${commands[eza]} ]]; then
  alias ls='eza --group-directories-first --color=auto --icons'
  alias l='eza -l --group-directories-first --color=auto --icons'
  alias ll='eza -lA --header --classify --group-directories-first --time-style=long-iso --color=auto --icons'
  alias la='eza -A --group-directories-first --color=auto --icons'
  alias lt='eza --tree --level=2 --group-directories-first --color=auto --icons'
  alias lta='eza --tree --level=2 -A --group-directories-first --color=auto --icons'
  alias tree='eza --tree --color=auto --icons'
elif [[ $OSTYPE == freebsd* ]] ||  [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto --classify --human-readable'
fi

# Process monitoring
if [[ -n ${commands[procs]} ]]; then
  alias ps='procs --theme light'
else
  alias ps='ps auxf'
fi

# Modern tools
command -v fd &>/dev/null && alias find='fd --color=auto --hidden --follow --exclude .git'
command -v rg &>/dev/null && alias grep='rg --color=auto --smart-case'
command -v bat &>/dev/null && alias cat='bat --style=auto --theme=ansi'
command -v htop &>/dev/null && alias top='htop'

# System
alias df='df -hT'
alias du='du -hc'
alias free='free -h'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias dd='dd status=progress'
alias rm='rm -Iv --one-file-system --preserve-root'

# Quick commands
alias vi='$EDITOR'
alias cl='clear'
alias x='exit'
alias reload='exec $SHELL'

# Git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'

# Kubernetes
if [[ $commands[kubectl] ]]; then
   alias k=kubectl
   source <(kubectl completion zsh)
fi
alias tf=terraform
alias tg=terragrunt
