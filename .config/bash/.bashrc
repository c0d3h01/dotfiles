#!/usr/bin/env bash

# Bash history configuration
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="%d.%m.%Y %T "
shopt -s histappend
shopt -s histverify
shopt -s cmdhist

# Bash shell options
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s nocaseglob
shopt -s checkwinsize

# Helper function
ifsource() { [ -f "$1" ] && source "$1"; }

# Fzf Key Bindings
if [ -f /usr/share/fzf/key-bindings.bash ]; then
	source /usr/share/fzf/key-bindings.bash
elif [ -f "$HOME/.fzf/shell/key-bindings.bash" ]; then
	source "$HOME/.fzf/shell/key-bindings.bash"
fi

# Fzf Auto-Completion
if [ -f /usr/share/fzf/completion.bash ]; then
	source /usr/share/fzf/completion.bash
elif [ -f "$HOME/.fzf/shell/completion.bash" ]; then
	source "$HOME/.fzf/shell/completion.bash"
fi

# Enable programmable completion features
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	fi
fi

# Custom configs
ifsource "$HOME/.config/shell/export.sh"
ifsource "$HOME/.config/shell/function.sh"
ifsource "$HOME/.config/shell/alias.sh"

# Load direnv integration
if command -v direnv &>/dev/null; then
	eval "$(direnv hook bash)"
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
fi

# Vi mode for Bash
set -o vi
bind -m vi-insert "\C-p":history-search-backward
bind -m vi-insert "\C-n":history-search-forward
bind -m vi-insert "\C-?":backward-delete-char
bind -m vi-insert "\C-h":backward-delete-char
bind -m vi-insert "\C-w":backward-kill-word
bind -m vi-insert "\C-H":backward-kill-word
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line
bind -m vi-insert "\C-xe":edit-and-execute-command
export KEYTIMEOUT=1

# Enable color support
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
