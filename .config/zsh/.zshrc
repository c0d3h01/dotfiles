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

# autocompletions
autoload -Uz compinit
zmodload zsh/complist
compinit

# autosuggestions settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# fzf-tab
zstyle ':completion:*:git-checkout:*' sort false # disable sorting for git-checkout
zstyle ':fzf-tab:*' use-fzf-default-opts yes # use fzf default options
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath' # preview for cd

# Helper function
ifsource() { [ -f "$1" ] && source "$1"; }

# Credentials
ifsource "$HOME/.credentials"

# Source plugins
ifsource "$ZDOTDIR/plugins/autosuggestions/zsh-autosuggestions.plugin.zsh"
ifsource "$ZDOTDIR/plugins/completions/zsh-completions.plugin.zsh"
ifsource "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
ifsource "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Source configs
ifsource "$HOME/.config/shell/export.sh"
ifsource "$HOME/.config/shell/function.sh"
ifsource "$HOME/.config/shell/alias.sh"

# Load direnv integration
if [ -n "${commands[direnv]}" ]; then
  eval "$(direnv hook zsh)"
fi

# Starship prompt
if [ -n "${commands[starship]}" ]; then
  eval "$(starship init zsh)"
fi

# load nix
ifsource /etc/profile.d/nix.sh
ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Source dir hashes
ifsource "$HOME/.local/share/zsh/.zsh_dir_hashes"

# Source fzf
[ -d "$HOME/.nix-profile/share/fzf" ] &&
    source "$HOME/.nix-profile/share/fzf/completion.zsh" &&
    source "$HOME/.nix-profile/share/fzf/key-bindings.zsh"

# Source colors for ls (trapd00r/LS_COLORS)
eval "$(dircolors -b "$ZDOTDIR/dircolors")"

# Vim mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -v
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^H' backward-kill-word # ctrl+bspc
bindkey '^[^?' backward-kill-word # alt+bspc
# bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey "${terminfo[kcuu1]}" history-search-backward
bindkey "${terminfo[kcud1]}" history-search-forward
export KEYTIMEOUT=1

# Prevent broken terminals
ttyctl -f
