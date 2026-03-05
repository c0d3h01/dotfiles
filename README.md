# linux dotfiles

Managed with GNU Stow directly from repository root.

## install

```bash
git clone --recurse-submodules https://github.com/c0d3h01/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow -nv --target="$HOME" .
stow --restow --target="$HOME" .
```

If Stow reports conflicts (existing real files in `$HOME`), move those files out first
or run a one-time adopt flow:

```bash
stow --target="$HOME" --adopt .
```
