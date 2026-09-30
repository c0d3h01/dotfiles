#!/bin/bash
# macOS defaults, idempotent. Writes only differing keys. Run: ./scripts/macos-defaults.sh
set -u
changed=0
set_kv() { # set_kv <domain> <key> <type> <want> (bool want as 1/0)
  local cur
  cur="$(defaults read "$1" "$2" 2>/dev/null || echo __MISSING__)"
  if [ "$cur" != "$4" ]; then
    if [ "$3" = -bool ]; then
      defaults write "$1" "$2" "$3" "$([ "$4" = 1 ] && echo true || echo false)"
    else defaults write "$1" "$2" "$3" "$4"; fi
    changed=$((changed + 1))
  fi
}

set_kv NSGlobalDomain KeyRepeat -int 2
set_kv NSGlobalDomain InitialKeyRepeat -int 15
set_kv NSGlobalDomain ApplePressAndHoldEnabled -bool 0

mkdir -p ~/Pictures/Screenshots
set_kv com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
set_kv com.apple.screencapture type -string png

set_kv com.apple.finder AppleShowAllFiles -bool 1
set_kv com.apple.finder ShowPathbar -bool 1
set_kv com.apple.finder ShowStatusBar -bool 1

set_kv com.apple.dock autohide -bool 1
set_kv com.apple.dock tilesize -int 36
set_kv com.apple.dock show-recents -bool 0

if [ "$changed" -gt 0 ]; then
  killall Dock Finder SystemUIServer 2>/dev/null || true
  echo "macOS defaults applied ($changed changed)"
else
  echo "macOS defaults already set"
fi
