#!/bin/bash
# Fresh Mac setup, idempotent. Preflight first, act only on gaps.
set -u
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
have() { command -v "$1" >/dev/null 2>&1; }
say() { printf '== %s: %s\n' "$1" "$2"; }

if xcode-select -p >/dev/null 2>&1; then say clt ok; else
  say clt installing
  xcode-select --install
fi
if have brew; then say brew ok; else
  say brew installing
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if brew bundle check --file="$DOTFILES/Brewfile" >/dev/null 2>&1; then say bundle ok; else
  say bundle installing
  brew trust --cask nikitabobko/tap/aerospace 2>/dev/null || true
  brew bundle --file="$DOTFILES/Brewfile"
fi

say stow linking
stow -R -d "$DOTFILES" -t "$HOME" .

if [ -d ~/.tmux/plugins/tpm ]; then say tpm ok; else
  say tpm installing
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
~/.tmux/plugins/tpm/bin/install_plugins || true

[ "$(stat -f %Lp ~/.ssh 2>/dev/null)" = 700 ] && [ "$(stat -f %Lp ~/.ssh/config 2>/dev/null)" = 600 ] && say ssh ok || {
  say ssh fixing
  mkdir -p ~/.ssh/sockets && chmod 700 ~/.ssh && chmod 600 ~/.ssh/config
}

"$DOTFILES/scripts/macos-defaults.sh"
echo "done — restart shell"
