#!/usr/bin/env sh
# Sourced by zshrc — must stay sh-compatible except where noted (zsh :h modifier)

# XDG base dirs — must come first; everything below may reference these
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Core
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="nvim +Man!"
export BROWSER="brave-browser"
export DIFFTOOL="icdiff"
export LC_ALL="en_IN.UTF-8"
export LANG="en_IN.UTF-8"
# Do NOT export TERM here — let the terminal emulator set it.
# Hardcoding it breaks tmux, SSH, and any non-xterm terminal.
export GPG_TTY="$(tty)"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"  # moved after XDG_DATA_HOME is set

# less
export LESS="-R -F -X -i -J --tabs=4"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
[[ -d "${LESSHISTFILE:h}" ]] || mkdir -p "${LESSHISTFILE:h}"

# fzf
export FZF_DEFAULT_OPTS='
  --preview-window=right,55%,wrap,border-sharp
  --bind=ctrl-a:first,ctrl-g:last
  --bind=ctrl-j:preview-down,ctrl-k:preview-up
  --bind=ctrl-t:preview-top,ctrl-b:preview-bottom
  --walker-skip=.git
  --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
'

# LS_COLORS
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

# PATH helper — idempotent prepend
add_to_path() {
  [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# Go
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
export GOTELEMETRY="off"
add_to_path "$GOBIN"
add_to_path "/usr/local/go/bin"

# Rust
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
add_to_path "$CARGO_HOME/bin"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# Python
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
[[ -d "${PYTHON_HISTORY:h}" ]] || mkdir -p "${PYTHON_HISTORY:h}"
export UV_CACHE_DIR="${XDG_CACHE_HOME}/uv"
export POETRY_HOME="$HOME/.poetry"
add_to_path "$POETRY_HOME/bin"

# Node
add_to_path "$HOME/.npm-global/bin"
export BUN_INSTALL="$HOME/.bun"
add_to_path "$BUN_INSTALL/bin"

# JVM / Android / Flutter
export JAVA_HOME="${JAVA_HOME:-$HOME/Android/jdk}"
export GRADLE_HOME="$HOME/.gradle"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/latest"
export NDK_HOME="$ANDROID_NDK_HOME"
export FLUTTER_HOME="$HOME/Android/flutter"
export FLUTTER_ROOT="$FLUTTER_HOME"
export PUB_CACHE="$HOME/.pub-cache"
export CHROME_EXECUTABLE="$BROWSER"
add_to_path "$JAVA_HOME/bin"
add_to_path "$GRADLE_HOME/bin"
add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/emulator"
add_to_path "$ANDROID_HOME/build-tools/36.1.0"
add_to_path "$NDK_HOME"
add_to_path "$FLUTTER_HOME/bin"
add_to_path "$PUB_CACHE/bin"

# Solana / Anchor / Foundry
add_to_path "$HOME/.local/share/solana/install/active_release/bin"
add_to_path "$HOME/.avm/bin"
add_to_path "$HOME/.foundry/bin"

# Tool config paths
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"

# DB history — keep dot files out of $HOME
export SQLITE_HISTORY="${XDG_STATE_HOME}/sqlite/history"
export REDISCLI_HISTFILE="${XDG_STATE_HOME}/redis/history"
export PSQL_HISTORY="${XDG_STATE_HOME}/psql/history"
export MYSQL_HISTFILE="${XDG_STATE_HOME}/mysql/history"
for _hist_dir in \
  "${SQLITE_HISTORY:h}" \
  "${REDISCLI_HISTFILE:h}" \
  "${PSQL_HISTORY:h}" \
  "${MYSQL_HISTFILE:h}"
do
  [[ -d "$_hist_dir" ]] || mkdir -p "$_hist_dir"
done
unset _hist_dir

# User-local binaries
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
