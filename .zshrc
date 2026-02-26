#!/usr/bin/env zsh

[[ -o interactive ]] || return

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
unsetopt correct
unsetopt correct_all

# cd-ing settings
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt always_to_end
setopt interactive_comments
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# Completion setup
if [[ -d "$HOME/.completions/src" ]]; then
    fpath=("$HOME/.completions/src" $fpath)
fi

_zsh_comp_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
_zcompdump_file="$_zsh_comp_cache_dir/.zcompdump"
mkdir -p "$_zsh_comp_cache_dir"

autoload -Uz compinit
compinit -C -d "$_zcompdump_file"
if [[ -s "$_zcompdump_file" && ( ! -s "$_zcompdump_file.zwc" || "$_zcompdump_file" -nt "$_zcompdump_file.zwc" ) ]]; then
    zcompile "$_zcompdump_file"
fi
unset _zsh_comp_cache_dir
unset _zcompdump_file

# autosuggestions settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # Prevent rebinding on every prompt

# fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# Helper function
ifsource() { [ -f "$1" ] && source "$1"; }

# Keep failed command feedback instant; avoid slow package lookup handlers.
command_not_found_handler() {
	print -u2 "zsh: command not found: $1"
	return 127
}

# Credentials
ifsource "$HOME/.credentials"

# Source plugins
ifsource "$HOME/.autosuggestions/zsh-autosuggestions.plugin.zsh"
ifsource "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
ifsource "$HOME/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Source configs
ifsource "$HOME/.config/shell/export.sh"
ifsource "$HOME/.config/shell/function.sh"
ifsource "$HOME/.config/shell/alias.sh"

# Load direnv integration
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

# Starship prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

# kubectl completion (cached to avoid re-generating every shell startup)
if (( $+commands[kubectl] )); then
    _zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    _kubectl_comp_cache="$_zsh_cache_dir/kubectl-completion.zsh"
    mkdir -p "$_zsh_cache_dir"

    if [[ ! -s "$_kubectl_comp_cache" || "$_kubectl_comp_cache" -ot "$(command -v kubectl)" ]]; then
        kubectl completion zsh >| "$_kubectl_comp_cache" 2>/dev/null
    fi

    [ -s "$_kubectl_comp_cache" ] && source "$_kubectl_comp_cache"
    unset _zsh_cache_dir _kubectl_comp_cache
fi

# load nix
ifsource /etc/profile.d/nix.sh
ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Source dir hashes
ifsource "$HOME/.local/share/zsh/.zsh_dir_hashes"

# Source fzf
if [ -d "$HOME/.nix-profile/share/fzf" ]; then
    source "$HOME/.nix-profile/share/fzf/completion.zsh"
    source "$HOME/.nix-profile/share/fzf/key-bindings.zsh"
fi

# Source colors for ls (trapd00r/LS_COLORS)
if [[ -z "${LS_COLORS:-}" && -f "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
fi
if [[ -n "${LS_COLORS:-}" ]]; then
    zstyle ':completion:*' list-colors "$LS_COLORS"
fi

# Runtime managers
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
fi

_lazy_load_nvm() {
    unset -f _lazy_load_nvm nvm node npm npx pnpm yarn corepack
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

nvm() { _lazy_load_nvm; nvm "$@"; }
node() { _lazy_load_nvm; node "$@"; }
npm() { _lazy_load_nvm; npm "$@"; }
npx() { _lazy_load_nvm; npx "$@"; }
pnpm() { _lazy_load_nvm; pnpm "$@"; }
yarn() { _lazy_load_nvm; yarn "$@"; }
corepack() { _lazy_load_nvm; corepack "$@"; }

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

# Emacs mode (prevents accidental overwrite from vi command mode)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -e
# Keybinding usage:
# Ctrl-P / Ctrl-N: search previous/next history entries by typed prefix
# Ctrl-W / Ctrl-H: delete previous word/character
# Ctrl-A / Ctrl-E: move to start/end of line
# Ctrl-X Ctrl-E: edit current command in $EDITOR
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
bindkey "${terminfo[kcuu1]}" history-search-backward
bindkey "${terminfo[kcud1]}" history-search-forward
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char
# Ctrl+Arrow word motion: prefer terminfo, keep one common fallback.
[[ -n "${terminfo[kLFT5]:-}" ]] && bindkey "${terminfo[kLFT5]}" backward-word
[[ -n "${terminfo[kRIT5]:-}" ]] && bindkey "${terminfo[kRIT5]}" forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
export KEYTIMEOUT=100

# Prevent broken terminals
ttyctl -f
