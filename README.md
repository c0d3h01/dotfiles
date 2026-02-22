# linux dotfiles

Managed with GNU Stow directly from repository root.

## layout

- top-level home files in root (for example `.zprofile`, `.gdbinit`)
- app configs under `.config/`

## install

```bash
git clone --recurse-submodules https://github.com/c0d3h01/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
stow -nv --target="$HOME" .
stow --restow --target="$HOME" .
```

If Stow reports conflicts (existing real files in `$HOME`), move those files out first
or run a one-time adopt flow:

```bash
stow --target="$HOME" --adopt .
```
