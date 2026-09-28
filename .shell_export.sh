#!/bin/zsh
# Shared env, mac-only. XDG first, user bins last so they beat brew in PATH.

# -d guard: missing toolchains shouldn't litter PATH with dead entries
add_to_path() { [[ -d "$1" ]] && export PATH="$1:$PATH"; }

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="nvim +Man!"
export BROWSER="open"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export GPG_TTY="$(tty 2>/dev/null)"

export LESS="-R -F -X -i -J --tabs=4"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
mkdir -p "${LESSHISTFILE:h}" 2>/dev/null || true

export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
mkdir -p "${PYTHON_HISTORY:h}" 2>/dev/null || true
export UV_CACHE_DIR="${XDG_CACHE_HOME}/uv"

# border-sharp is valid fzf syntax, but the rest of this setup uses rounded
export FZF_DEFAULT_OPTS='
  --preview-window=right,55%,wrap,border-rounded
  --bind=ctrl-a:first,ctrl-g:last
  --bind=ctrl-j:preview-down,ctrl-k:preview-up
  --walker-skip=.git
  --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
'

export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
export GOTELEMETRY="off"
add_to_path "$GOBIN"

export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
add_to_path "$CARGO_HOME/bin"

export BUN_INSTALL="$HOME/.bun"
add_to_path "$BUN_INSTALL/bin"
add_to_path "$HOME/.npm-global/bin"
export PNPM_HOME="$HOME/Library/pnpm"
add_to_path "$PNPM_HOME/bin"

export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/latest"
export NDK_HOME="$ANDROID_NDK_HOME"
export CHROME_EXECUTABLE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"
add_to_path "$ANDROID_HOME/emulator"

export FLUTTER_HOME="$HOME/Android/flutter"
export FLUTTER_ROOT="$FLUTTER_HOME"
export PUB_CACHE="$HOME/.pub-cache"
add_to_path "$FLUTTER_HOME/bin"
add_to_path "$PUB_CACHE/bin"

add_to_path "$HOME/.local/share/solana/install/active_release/bin"
add_to_path "$HOME/.foundry/bin"
add_to_path "$HOME/.avm/bin"

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"

# IDE CLIs, each installed separately
add_to_path "$HOME/.antigravity-ide/antigravity-ide/bin"
add_to_path "$HOME/.codeium/windsurf/bin"

add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "$HOME/.opencode/bin"
