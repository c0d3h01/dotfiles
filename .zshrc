#!/usr/bin/env zsh

[[ -o interactive ]] || return

# History
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="false"
export HIST_STAMPS="dd.mm.yyyy"
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_SPACE
setopt sharehistory          # implies appendhistory + incappendhistory
setopt HIST_IGNORE_ALL_DUPS  # implies HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
unsetopt correct
unsetopt correct_all

# Navigation + completion behaviour
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt always_to_end
setopt interactive_comments
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# fzf-tab zstyles — must be set before compinit
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# fpath — extend before compinit so completions are picked up
# zsh-completions and nix-zsh-completions both install into site-functions
_nix_site_functions="$HOME/.nix-profile/share/zsh/site-functions"
if [[ -d "$_nix_site_functions" ]]; then
    fpath=("$_nix_site_functions" $fpath)
fi
unset _nix_site_functions

# Custom completions (local overrides, takes highest priority)
if [[ -d "$HOME/.completions/src" ]]; then
    fpath=("$HOME/.completions/src" $fpath)
fi

# Completion init with compiled cache
_zsh_comp_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
_zcompdump_file="$_zsh_comp_cache_dir/.zcompdump"
mkdir -p "$_zsh_comp_cache_dir"

autoload -Uz compinit
compinit -C -d "$_zcompdump_file"
if [[ -s "$_zcompdump_file" && ( ! -s "$_zcompdump_file.zwc" || "$_zcompdump_file" -nt "$_zcompdump_file.zwc" ) ]]; then
    zcompile "$_zcompdump_file"
fi
unset _zsh_comp_cache_dir _zcompdump_file

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"
# ZSH_AUTOSUGGEST_MANUAL_REBIND=1
_nix_autosuggest="$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_nix_autosuggest" ]] && source "$_nix_autosuggest"
unset _nix_autosuggest

# fzf-tab — must load after compinit, before syntax highlighting
_nix_fzf_tab="$HOME/.nix-profile/share/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$_nix_fzf_tab" ]] && source "$_nix_fzf_tab"
unset _nix_fzf_tab

# fast-syntax-highlighting — must be sourced last among plugins
_nix_fsh="$HOME/.nix-profile/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
[[ -f "$_nix_fsh" ]] && source "$_nix_fsh"
unset _nix_fsh

# Source helper — no-op if file missing
ifsource() { [[ -f "$1" ]] && source "$1"; }

# Skip slow package-manager lookup on unknown commands
command_not_found_handler() {
    print -u2 "zsh: command not found: $1"
    return 127
}

# Credentials (tokens, secrets)
ifsource "$HOME/.credentials"

# Shell config modules
ifsource "$HOME/.shell_export.sh"
ifsource "$HOME/.shell_function.sh"
ifsource "$HOME/.shell_alias.sh"

# direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# Prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

# kubectl completion — cached against binary mtime to avoid regenerating every shell
if (( $+commands[kubectl] )); then
    _zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    _kubectl_comp_cache="$_zsh_cache_dir/kubectl-completion.zsh"
    mkdir -p "$_zsh_cache_dir"

    if [[ ! -s "$_kubectl_comp_cache" || "$_kubectl_comp_cache" -ot "$(command -v kubectl)" ]]; then
        kubectl completion zsh >| "$_kubectl_comp_cache" 2>/dev/null
    fi

    [[ -s "$_kubectl_comp_cache" ]] && source "$_kubectl_comp_cache"
    unset _zsh_cache_dir _kubectl_comp_cache
fi

# Nix
ifsource /etc/profile.d/nix.sh
ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Named dir hashes
ifsource "$HOME/.local/share/zsh/.zsh_dir_hashes"

# fzf key bindings + completions (nix-managed)
if [[ -d "$HOME/.nix-profile/share/fzf" ]]; then
    source "$HOME/.nix-profile/share/fzf/completion.zsh"
    source "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
fi

# LS_COLORS (trapd00r/LS_COLORS)
if [[ -z "${LS_COLORS:-}" && -f "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
fi
if [[ -n "${LS_COLORS:-}" ]]; then
    zstyle ':completion:*' list-colors "$LS_COLORS"
fi

# NVM — lazy loaded to keep shell startup fast
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
fi

_lazy_load_nvm() {
    unset -f _lazy_load_nvm nvm node npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

# Only wrap commands that actually require nvm's node resolution
nvm()  { _lazy_load_nvm; nvm  "$@"; }
node() { _lazy_load_nvm; node "$@"; }
npm()  { _lazy_load_nvm; npm  "$@"; }
npx()  { _lazy_load_nvm; npx  "$@"; }

# pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
if [[ -d "$PYENV_ROOT/bin" && ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if [[ -d "$PYENV_ROOT/shims" && ":$PATH:" != *":$PYENV_ROOT/shims:"* ]]; then
    export PATH="$PYENV_ROOT/shims:$PATH"
fi
if command -v pyenv >/dev/null 2>&1; then
    pyenv() {
        unset -f pyenv
        eval "$(command pyenv init - zsh)"
        pyenv "$@"
    }
fi

# Keybindings — emacs mode
zmodload zsh/terminfo          # required for $terminfo[] lookups below
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -e

# Line movement
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# History search by typed prefix
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Delete
bindkey '^?' backward-delete-char  # Backspace
bindkey '^w' backward-kill-word

# Edit command in $EDITOR
bindkey '^xe'  edit-command-line
bindkey '^x^e' edit-command-line

# Arrow keys via terminfo (portable across terminals)
[[ -n "${terminfo[kcuu1]:-}" ]] && bindkey "${terminfo[kcuu1]}" history-search-backward
[[ -n "${terminfo[kcud1]:-}" ]] && bindkey "${terminfo[kcud1]}" history-search-forward
[[ -n "${terminfo[kcub1]:-}" ]] && bindkey "${terminfo[kcub1]}" backward-char
[[ -n "${terminfo[kcuf1]:-}" ]] && bindkey "${terminfo[kcuf1]}" forward-char

# Fallback escape sequences for arrow keys
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char

# Ctrl+Arrow word motion
[[ -n "${terminfo[kLFT5]:-}" ]] && bindkey "${terminfo[kLFT5]}" backward-word
[[ -n "${terminfo[kRIT5]:-}" ]] && bindkey "${terminfo[kRIT5]}" forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# 100ms — enough for multi-key sequences without noticeable lag
export KEYTIMEOUT=10

# Lock terminal state after init to prevent corruption
ttyctl -f
