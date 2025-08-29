#!/usr/bin/env bash

export LC_ALL=en_IN.UTF-8
export LANG="$LC_ALL"
export TERM="xterm-256color"
export EDITOR='nvim'
export BROWSER='firefox'
export DIFFTOOL='icdiff'
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

# zsh settings
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="false"
export HIST_STAMPS="dd.mm.yyyy"
export HISTSIZE=5000
export SAVEHIST=5000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_SPACE
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# cd-ing settings
setopt auto_cd                                         # automatically cd if folder name and no command found
setopt auto_list                                       # automatically list choices on ambiguous completion
setopt auto_menu                                       # automatically use menu completion
setopt always_to_end                                   # move cursor to end if word had one match
setopt interactive_comments                            # allow comments in interactive shells
zstyle ':completion:*' menu select                     # select completions with arrow keys
zstyle ':completion:*' group-name ''                   # group results by category
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # non case sensitive complete
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Tool Initialization
eval "$(zoxide init zsh --cmd j)"
eval "$(direnv hook zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Setup direnv
eval "$(direnv hook zsh)"

# Autocompletions
autoload -Uz compinit
zmodload zsh/complist
compinit

# Autosuggestions settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# FZF-tab config
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# Helper to source if exists
ifsource(){ [ -f "$1" ] && source "$1"; }

# Credentials
ifsource "$HOME/.credentials"
ifsource "$HOME/.zsh_dir_hashes"

# Load nix
ifsource /etc/profile.d/nix.sh
ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Source plugins
ifsource "$HOME/.shell/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ifsource "$HOME/.shell/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
ifsource "$HOME/.shell/zsh-completions/zsh-completions.plugin.zsh"
# FZF - Tab
ifsource "$HOME/.shell/fzf-tab/fzf-tab.plugin.zsh"
# FZF
ifsource "$HOME/.shell/fzf/shell/completion.zsh"
ifsource "$HOME/.shell/fzf/shell/key-bindings.zsh"
# Custom
ifsource "$HOME/.shell/aliases.sh"
ifsource "$HOME/.shell/exports.sh"
ifsource "$HOME/.shell/functions.sh"

# Vim mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -v
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^H' backward-kill-word
bindkey '^[^?' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey "''${terminfo[kcuu1]}" history-search-backward
bindkey "''${terminfo[kcud1]}" history-search-forward
export KEYTIMEOUT=1

# Prevent broken terminals by resetting to sane defaults after a command
ttyctl -f