# ===== Core Configuration =====
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

# ===== Path Configuration =====
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# ===== Tool Configurations =====
export LESS="-R -F -X -M"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ===== Zsh Features =====
autoload -Uz colors && colors

# History configuration
HISTSIZE=20000
SAVEHIST=20000
HISTFILE=~/.zsh_history
HISTORY_IGNORE="(rm *|pkill *|kill *|shutdown *|reboot *|exit)"
setopt append_history           # Append to history file instead of overwriting
setopt extended_history         # Save timestamp and duration of commands
setopt hist_expire_dups_first   # Delete duplicates first when history is full
setopt hist_ignore_all_dups
# setopt hist_ignore_space
setopt hist_verify              # Show command before executing
setopt inc_append_history       # Add commands to history immediately
setopt share_history            # Share history between sessions

# Completion system
autoload -Uz compinit
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
compinit -d "$HOME/.cache/zsh/.zcompdump"

# Directory options
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CDABLE_VARS EXTENDED_GLOB NO_BEEP
setopt MULTIOS NO_HUP IGNORE_EOF RC_QUOTES
setopt RM_STAR_SILENT SHORT_LOOPS NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS AUTOCD

# ===== Key Bindings =====
bindkey -v
export KEYTIMEOUT=1
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^f' vi-forward-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ===== Aliases =====
# Navigation
alias ..='cd ..' ...='cd ../..' ....='cd ../../..' -- -='cd -'

# Modern ls replacements
alias l='eza -l --icons --group-directories-first --color=auto'
alias ls='eza --icons --group-directories-first --color=auto'
alias ll='eza -l --git --header --classify --binary --group --time-style=long-iso --links --all --icons --group-directories-first --color=auto'
alias la='eza -a --icons --group-directories-first --color=auto'
alias lt='eza --tree --level=2 --icons --group-directories-first --color=auto'
alias lta='eza --tree --level=2 -a --icons --group-directories-first --color=auto'
alias ltg='eza --tree --level=2 --git-ignore --icons --group-directories-first --color=auto'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gs='git status -sb'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gph='git push'
alias gpl='git pull --rebase'
alias gl='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias gst='git stash'
alias gsp='git stash pop'

# System utilities
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias top='htop'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias grep='rg'
alias find='fd'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias wget='wget -c'
alias ports='ss -tulpn'
alias untar='tar -xvf'

# Safety nets
alias rm='rm -Iv --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# Modern alternatives
alias cat='bat'
alias vi='nvim'
alias vim='nvim'

# Handy shortcuts
alias ff='fastfetch'
alias cl='clear'
alias x='exit'
alias ts='date '\''+%Y-%m-%d %H:%M:%S'\'
alias reload='source ~/.zshrc'

# ===== Functions =====
path() {
  echo -e ${PATH//:/\\n} | bat
}

extract() {
  local file="$1" dir="${2:-.}"
  [[ ! -f "$file" ]] && echo "Error: '$file' not valid" >&2 && return 1
  
  case "$file" in
    *.tar.bz2|*.tbz2)  tar -xjf "$file" -C "$dir" ;;
    *.tar.gz|*.tgz)    tar -xzf "$file" -C "$dir" ;;
    *.tar.xz|*.txz)    tar -xJf "$file" -C "$dir" ;;
    *.bz2)             bunzip2 -k "$file" ;;
    *.rar)             unrar x "$file" "$dir" ;;
    *.gz)              gunzip -k "$file" ;;
    *.tar)             tar -xf "$file" -C "$dir" ;;
    *.zip)             unzip "$file" -d "$dir" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              7z x "$file" -o"$dir" ;;
    *.deb)             ar x "$file" ;;
    *)                 echo "Cannot extract '$file'" >&2 && return 1 ;;
  esac && echo "Extracted '$file' to '$dir'"
}

mkcd() { mkdir -p "$1" && cd "$1" }

fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse) && cd "$dir"
}

glf() {
  git log --color=always --format="%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset" "$@" | \
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview "git show --color=always {1}" \
        --bind "enter:execute(git show {1})+accept"
}

colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
    (( (i + 1) % 16 == 0 )) && printf "\n"
  done
}

# ===== Tool Initialization =====
# Initialize zoxide (if installed)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd j)"

# Initialize direnv (if installed)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ===== Starship Prompt ===== ( I dont use starship btw)
# command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ===== Custom Plugin Submodules =====
ZSH_PLUGINS="${HOME}/dotfiles/zsh"

# zsh-completions
fpath+=("$ZSH_PLUGINS/zsh-completions")

# zsh-autosuggestions
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

# pure prompt
fpath+=("$ZSH_PLUGINS/pure")
autoload -U promptinit; promptinit
prompt pure

# zsh-autopair
source "$ZSH_PLUGINS/zsh-autopair/autopair.zsh"

# fast-syntax-highlighting
source "$ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# fzf-tab
source "$ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh"