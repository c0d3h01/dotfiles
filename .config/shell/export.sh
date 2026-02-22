#!/usr/bin/env zsh

export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave-browser"
export DIFFTOOL='icdiff'
export LC_ALL="en_IN.UTF-8"
export LANG="en_IN.UTF-8"
export TERM="xterm-256color"
export COLORTERM="truecolor"
export CLICOLOR="1"
export CLICOLOR_FORCE="1"
export FORCE_COLOR="1"
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"

if command -v dircolors >/dev/null 2>&1; then
	eval "$(dircolors -b)"
fi

# Helper functions
add_to_path() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		export PATH="$1:$PATH"
	fi
}
ifsource() {
	[ -f "$1" ] && . "$1"
}

# Android
export CHROME_EXECUTABLE="$BROWSER"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/latest"
export NDK_HOME="$ANDROID_NDK_HOME"
export JAVA_HOME="$HOME/Android/jdk"
export FLUTTER_HOME="$HOME/Android/flutter"
add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/emulator"
add_to_path "$ANDROID_HOME/build-tools/36.1.0"
add_to_path "$NDK_HOME"
add_to_path "$JAVA_HOME/bin"
add_to_path "$FLUTTER_HOME/bin"

# Go
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
add_to_path "$GOBIN"

# Other tools
add_to_path "$HOME/.local/share/solana/install/active_release/bin"
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# Local bins
add_to_path "$HOME/.avm/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.npm-global/bin"

# Bun
export BUN_INSTALL="$HOME/.bun"
add_to_path "$BUN_INSTALL/bin"

# Rust Build Environment
export CARGO_HOME="$HOME/.cargo"
add_to_path "$CARGO_HOME/bin"
ifsource "$HOME/.cargo/env"
