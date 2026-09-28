#!/bin/zsh
# mac-only, Apple Silicon. brew owns CLI tools, nix adds the extras.

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# nix-daemon.sh, not nix.sh: only this one puts the nix binary on PATH
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_SPACE
setopt sharehistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
unsetopt correct
unsetopt correct_all

setopt auto_cd
setopt auto_list
setopt auto_menu
setopt always_to_end
setopt interactive_comments

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:*:git-checkout:*' sort false

# fpath before compinit or brew completions never load
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
mkdir -p "${_zcompdump:h}"
autoload -Uz compinit
compinit -C -d "$_zcompdump"

# fzf-tab reads these at source time, so after compinit and before the plugin
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'

# order is load-bearing, highlighting must stay last
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"
source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh
source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# generating these costs ~1s, so rebuild only when the binary is newer
if command -v kubectl >/dev/null; then
  _kubectl_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/kubectl-completion.zsh"
  mkdir -p "${_kubectl_cache:h}"
  if [[ ! -s $_kubectl_cache || $_kubectl_cache -ot "$(command -v kubectl)" ]]; then
    kubectl completion zsh >"$_kubectl_cache" 2>/dev/null
  fi
  [[ -s $_kubectl_cache ]] && source "$_kubectl_cache"
  unset _kubectl_cache
fi

source "$HOME/.shell_export.sh"
source "$HOME/.shell_function.sh"
source "$HOME/.shell_alias.sh"
[[ -f "$HOME/.secrets.env" ]] && source "$HOME/.secrets.env"

# arrows read from terminfo so they work in any terminal
zmodload zsh/terminfo
autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -e
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^w' backward-kill-word
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

bindkey "${terminfo[kcuu1]}" history-search-backward
bindkey "${terminfo[kcud1]}" history-search-forward
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char
bindkey "${terminfo[kLFT5]}" backward-word
bindkey "${terminfo[kRIT5]}" forward-word
