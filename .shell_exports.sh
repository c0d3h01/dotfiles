#!/bin/sh

export EDITOR="vim"
export VISUAL="$EDITOR";
export BROWSER="brave-browser"
export LC_ALL="en_IN.UTF-8"
export LANG="en_IN.UTF-8"
export TERM="xterm-256color"
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="false"
export HIST_STAMPS="dd.mm.yyyy"

# Detect shell type
if [ -n "$ZSH_VERSION" ]; then
    SHELL_TYPE="zsh"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_TYPE="bash"
else
    SHELL_TYPE="sh"
fi

# Helper functions
add_to_path() {
    if [ -d "$1" ] && ! echo "$PATH" | grep -q "(^|:)$1($|:)"; then
        if [ "$SHELL_TYPE" = "zsh" ]; then
            path=("$1" $path)
        else
            export PATH="$1:$PATH"
        fi
    fi
}

ifsource() {
    [ -f "$1" ] && . "$1"
}

# Rust Build Environment
export CARGO_HOME="$HOME/local/share/.cargo"
ifsource "$HOME/local/share/.cargo/env"
add_to_path "$HOME/local/share/.cargo/bin"

# Java
if command -v java > /dev/null; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(command -v java))))
fi

# Android
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export NDK_HOME="$ANDROID_HOME/android-ndk-29"
    add_to_path "$ANDROID_HOME/cmdline-tools/bin"
    add_to_path "$ANDROID_HOME/platform-tools"
    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/build-tools/36.1.0"
    add_to_path "$NDK_HOME"
fi

# Flutter
if [ -d "$HOME/Android/flutter" ]; then
    export FLUTTER_HOME="$HOME/Android/flutter"
    # Cross-shell compatible Chrome detection
    if command -v chromium >/dev/null 2>&1; then
        export CHROME_EXECUTABLE="$(command -v chromium)"
    elif command -v google-chrome >/dev/null 2>&1; then
        export CHROME_EXECUTABLE="$(command -v google-chrome)"
    fi
    add_to_path "$FLUTTER_HOME/bin"
fi

# Go
export GOPATH="$HOME/.local/share/go"
export GOBIN="$GOPATH/bin"
add_to_path "$GOBIN"

# Python
export PYENV_ROOT="$HOME/.local/share/pyenv"
if [ -d "$PYENV_ROOT" ]; then
    add_to_path "$PYENV_ROOT/bin"
    # Shell-specific pyenv initialization
    if command -v pyenv >/dev/null 2>&1; then
        if [ "$SHELL_TYPE" = "zsh" ]; then
            eval "$(pyenv init - zsh)"
        elif [ "$SHELL_TYPE" = "bash" ]; then
            eval "$(pyenv init - bash)"
        else
            eval "$(pyenv init -)"
        fi
    fi
fi

# nvm - node tool
export NVM_DIR="$HOME/.local/nvm"
ifsource "$NVM_DIR/nvm.sh"

# Other tools
add_to_path "$HOME/.local/share/solana/install/active_release/bin"

# Local bins
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.npm-global/bin"
add_to_path "$HOME/bin"

# Tool configs
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

export K9S_CONFIG_DIR="$HOME/.config/k9s"
