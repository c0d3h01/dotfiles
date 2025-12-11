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

# Custom prompt (simplified version - no Pure prompt in Bash)
# Basic two-line prompt with git branch support
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

set_prompt() {
    local last_exit=$?
    local git_branch=$(parse_git_branch)

    # Color definitions
    local reset='\[\033[0m\]'
    local yellow='\[\033[33m\]'
    local green='\[\033[32m\]'
    local red='\[\033[31m\]'
    local cyan='\[\033[36m\]'
    local magenta='\[\033[35m\]'

    # Prompt symbol based on last exit code
    local symbol
    if [ $last_exit -eq 0 ]; then
        symbol="${green}%${reset}"
    else
        symbol="${red}%${reset}"
    fi

    # Build prompt
    PS1="${cyan}\u${reset} ${yellow}\w${reset}"

    # Add git branch if in a git repo
    if [ -n "$git_branch" ]; then
        PS1="${PS1} ${yellow}${git_branch}${reset}"
    fi

    PS1="${PS1}\n${symbol} "

    # Right prompt (exit code if non-zero)
    if [ $last_exit -ne 0 ]; then
        PS1="${PS1}"
    fi
}

PROMPT_COMMAND=set_prompt

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
ifsource "$HOME/.shell_exports.sh"
ifsource "$HOME/.shell_functions.sh"
ifsource "$HOME/.shell_aliases.sh"

# Load direnv integration
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
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

if [ -n "${commands[fzf]}" ]; then
  source <(fzf --bash)
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
