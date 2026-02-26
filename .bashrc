#!/usr/bin/env bash

[[ $- != *i* ]] && return

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

# Emacs mode (prevents accidental overwrite from vi command mode)
set -o emacs
# Keybinding usage:
# Ctrl-P / Ctrl-N: search previous/next history entries by typed prefix
# Ctrl-W / Ctrl-H: delete previous word/character
# Ctrl-A / Ctrl-E: move to start/end of line
# Ctrl-X Ctrl-E: edit current command in $EDITOR
bind "\"\C-p\":history-search-backward"
bind "\"\C-n\":history-search-forward"
bind "\"\C-?\":backward-delete-char"
bind "\"\C-h\":backward-delete-char"
bind "\"\C-w\":backward-kill-word"
bind "\"\C-H\":backward-kill-word"
bind "\"\C-a\":beginning-of-line"
bind "\"\C-e\":end-of-line"
bind "\"\C-xe\":edit-and-execute-command"
bind "set keyseq-timeout 100"
bind "\"\e[D\":backward-char"
bind "\"\e[C\":forward-char"
bind "\"\e[1;5D\":backward-word"
bind "\"\e[1;5C\":forward-word"

# Enable color support
if [ -x /usr/bin/dircolors ]; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")"
	elif [ -r "$HOME/dircolors" ]; then
		eval "$(dircolors -b "$HOME/dircolors")"
	else
		eval "$(dircolors -b)"
	fi
fi
