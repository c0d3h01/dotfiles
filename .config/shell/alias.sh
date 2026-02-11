#!/usr/bin/env zsh

alias ls='ls -l --color=always'
alias ll='ls -la --color=always'
alias la='ls -la --color=always'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=always'
alias free='free -h'
alias df='df -hT'
alias du='du -hc'
alias ip='ip -color=always'
alias diff='diff --color=always'
alias dd='dd status=progress'
# Safer defaults for destructive file operations.
alias rm='rm -Iv --one-file-system --preserve-root'
