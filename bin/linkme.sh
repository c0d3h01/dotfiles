#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles/home"
TARGET="$HOME"

linked=()
skipped=()
removed=()

# Recursive linking function
link_recursive() {
  local src="$1"
  local dest="$2"

  if [ -d "$src" ]; then
    mkdir -p "$dest"
    for f in "$src"/* "$src"/.*; do
      [[ $(basename "$f") == "." || $(basename "$f") == ".." ]] && continue
      link_recursive "$f" "$dest/$(basename "$f")"
    done
  else
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      skipped+=("$dest")
    else
      ln -s "$src" "$dest" && linked+=("$dest")
    fi
  fi
}

# Recursive unlinking function
unlink_recursive() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$src" ]; then
    rm "$dest" && removed+=("$dest")
  elif [ -d "$src" ]; then
    for f in "$src"/* "$src"/.*; do
      [[ $(basename "$f") == "." || $(basename "$f") == ".." ]] && continue
      unlink_recursive "$f" "$dest/$(basename "$f")"
    done
  fi
}

# Main
case "$1" in
--link)
  for item in "$DOTFILES"/* "$DOTFILES"/.*; do
    [[ $(basename "$item") == "." || $(basename "$item") == ".." ]] && continue
    link_recursive "$item" "$TARGET/$(basename "$item")"
  done

  echo "Linked files:"
  for f in "${linked[@]}"; do echo "  $f"; done

  echo
  echo "Skipped files (already exist):"
  for f in "${skipped[@]}"; do echo "  $f"; done
  ;;
--unlink)
  for item in "$DOTFILES"/* "$DOTFILES"/.*; do
    [[ $(basename "$item") == "." || $(basename "$item") == ".." ]] && continue
    unlink_recursive "$item" "$TARGET/$(basename "$item")"
  done

  echo "Removed symlinks:"
  for f in "${removed[@]}"; do echo "  $f"; done
  ;;
*)
  echo "Usage: $0 --link | --unlink"
  exit 1
  ;;
esac
