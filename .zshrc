export EDITOR="vim"
export VISUAL="$EDITOR";
export BROWSER="brave"
export CLICOLOR=1
export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8
export TERM="xterm-256color"

# Zsh Options
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="false"
export HIST_STAMPS="dd.mm.yyyy"

# Zsh history location
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
DIRSTACKSIZE=30
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt append_history
setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt long_list_jobs

# Pure prompt
PURE_GIT_UNTRACKED_DIRTY=0 PURE_GIT_PULL=0
PURE_PROMPT_SYMBOL="%(?.%F{green}.%F{red})%%%f"
fpath+=($HOME/.pure)
zstyle :prompt:pure:path color yellow
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:user color cyan
zstyle :prompt:pure:host color yellow
zstyle :prompt:pure:git:branch:cached color red
RPS1='%(?.%F{magenta}.%F{red}(%?%) %F{magenta})'
autoload -U promptinit; promptinit
prompt pure

# settings
setopt auto_cd
setopt auto_list
setopt no_beep
setopt multios
setopt auto_menu
setopt always_to_end
setopt interactive_comments
setopt pushd_ignore_dups
setopt correct
setopt auto_name_dirs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
bindkey "^[m" copy-prev-shell-word

# Completion system
autoload colors; colors;
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# FZF-tab config
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# Helper function
ifsource() { [ -f "$1" ] && source "$1"; }

# Source plugins
ifsource "$HOME/.zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ifsource "$HOME/.zsh-completions/zsh-completions.plugin.zsh"
ifsource "$HOME/.fzf-tab/fzf-tab.plugin.zsh"
ifsource "$HOME/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Autosuggestions config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# Custom configs
ifsource "$HOME/.shell/exports.sh"
ifsource "$HOME/.shell/functions.sh"
ifsource "$HOME/.shell/aliases.sh"

# Load direnv integration
if [ -n "${commands[direnv]}" ]; then
  eval "$(direnv hook zsh)"
fi

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
bindkey "${terminfo[kcuu1]}" history-search-backward
bindkey "${terminfo[kcud1]}" history-search-forward
export KEYTIMEOUT=1

# Prevent broken terminals
ttyctl -f
