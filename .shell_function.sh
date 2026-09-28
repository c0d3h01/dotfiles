#!/bin/zsh

# extract <archive> [dest] — bsdtar autodetects format, no deps
extract() { bsdtar -xf "$1" ${2:+-C "$2"}; }

# mkcd <dir>
mkcd() { mkdir -p "$1" && cd "$1"; }
