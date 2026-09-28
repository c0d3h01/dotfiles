#!/bin/zsh

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# always prompt before overwriting or deleting
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias less='less -R'
alias rg='rg --color=always'
alias fd='fd --color=always'

alias df='df -h'
alias du='du -h'

# fallback so ll/la/lt survive an eza uninstall
if command -v eza >/dev/null; then
	alias ls='eza --group-directories-first'
	alias ll='eza -l --group-directories-first'
	alias la='eza -la --group-directories-first'
	alias lt='eza -T --group-directories-first --level=2'
else
	alias ll='ls -l'
	alias la='ls -la'
	alias lt='ls -R'
fi

alias ghidra='/opt/homebrew/bin/ghidraRun'
