#!/bin/zsh

# extract <archive> [dest] — bsdtar autodetects format, no deps
extract() { bsdtar -xf "$1" ${2:+-C "$2"}; }

# mkcd <dir>
mkcd() { mkdir -p "$1" && cd "$1"; }

# y — yazi wrapper, cds on exit
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  [ -f "$tmp" ] && cd -- "$(cat -- "$tmp")" 2>/dev/null
  rm -f -- "$tmp"
}
