#!/usr/bin/env zsh

export ZDOTDIR="$HOME/.config/zsh"
export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
