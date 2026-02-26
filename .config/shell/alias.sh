#!/usr/bin/env zsh

if command -v lsd >/dev/null 2>&1; then
	alias ls='lsd'
	alias ll='lsd -lh'
	alias la='lsd -A'
else
	alias ls='ls --color=always'
	alias ll='ls -lh --color=always'
	alias la='ls -A --color=always'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=always'
alias egrep='grep -E --color=always'
alias fgrep='grep -F --color=always'
alias rg='rg --color=always'
alias fd='fd --color=always'
alias less='less -R'
alias free='free -h'
alias df='df -hT'
alias du='du -hc'
alias ip='ip --color=always'
alias diff='diff --color=always'
alias watch='watch --color'
alias dd='dd status=progress'
# Safer defaults for destructive file operations.
alias rm='rm -Iv --one-file-system --preserve-root'
