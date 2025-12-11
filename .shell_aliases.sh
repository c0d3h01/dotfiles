#!/bin/sh

# Process monitoring
if [[ -n ${commands[procs]} ]]; then
  alias ps='procs --theme light'
else
  alias ps='ps auxf'
fi

# Detect if eza is available, fallback to ls
if command -v eza >/dev/null 2>&1; then
    # eza aliases
    alias ls='eza --group-directories-first --icons'
    alias l='eza --group-directories-first --icons -lh'
    alias ll='eza --group-directories-first --icons -lah'
    alias la='eza --group-directories-first --icons -a'
    alias lt='eza --group-directories-first --icons --tree'
    alias l.='eza --group-directories-first --icons -d .*'
    alias tree='eza --group-directories-first --icons --tree'
else
    # Fallback to ls with colors
    if [ -n "$ZSH_VERSION" ]; then
        alias ls='ls --color=auto --group-directories-first'
    else
        alias ls='ls --color=auto --group-directories-first'
    fi
    alias l='ls -lh'
    alias ll='ls -lah'
    alias la='ls -A'
    alias l.='ls -d .*'
fi

# Common navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Misc
alias c='clear'
alias h='history'
alias now='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'
alias vi='$EDITOR'
alias reload='exec $SHELL'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# # Modern tools
# command -v fd &>/dev/null && alias find='fd --color=auto --hidden --follow --exclude .git'
# command -v rg &>/dev/null && alias grep='rg --color=auto --smart-case'
# command -v bat &>/dev/null && alias cat='bat --style=auto --theme=ansi'
# command -v htop &>/dev/null && alias top='htop'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# System aliases
alias grep='grep --color=auto'
alias free='free -h'
alias df='df -hT'
alias du='du -hc'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias dd='dd status=progress'
alias rm='rm -Iv --one-file-system --preserve-root'

# Quick edit configs
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias bashrc='${EDITOR:-vim} ~/.bashrc'
alias vimrc='${EDITOR:-vim} ~/.vimrc'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# Docker shortcuts (if docker is available)
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlog='docker logs -f'
fi

# Kubernetes shortcuts (if kubectl is available)
if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get svc'
    alias kgd='kubectl get deployments'
    alias kdp='kubectl describe pod'
    alias kds='kubectl describe svc'
    alias kdd='kubectl describe deployment'
    alias kex='kubectl exec -it'
    alias klog='kubectl logs -f'
fi
