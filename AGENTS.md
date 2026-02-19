# Repository Guidelines

## Project Structure & Module Organization
This repository is a home-directory dotfiles layout managed from repo root.

- Root files: base shell/profile files and repo metadata (for example `.bashrc`, `.zprofile`, `.stow-local-ignore`).
- `.config/`: primary configs by tool (`zsh/`, `nvim/`, `tmux/`, `git/`, `alacritty/`, etc.).
- `bin/`: operational Bash scripts such as `archinstall.sh`, `postinstall.sh`, and `wifi-manager.sh`.
- `.config/zsh/plugins/`: third-party plugin submodules. Treat these as external dependencies unless intentionally updating upstream code.

## Build, Test, and Development Commands
Use these commands from repository root:

```bash
git clone --recurse-submodules https://github.com/c0d3h01/dotfiles.git ~/.dotfiles
git submodule update --init --recursive
stow -nv --target="$HOME" .      # dry-run symlink plan
stow --restow --target="$HOME" . # apply symlinks
bash -n bin/*.sh                 # shell syntax check
shfmt -w bin/*.sh                # shell formatting
```

## Coding Style & Naming Conventions
- Shell scripts should use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Match the existing style in touched files; run `shfmt` for consistency.
- Use clear, lowercase, hyphenated script names in `bin/` (example: `wifi-manager.sh`).
- Keep tool configs in their dedicated `.config/<tool>/` directory instead of mixing app settings at root.
- Python-related config in this repo follows 88-char lines (`.config/flake8`, `.config/isort.cfg`); keep consistency when editing Python snippets.

## Testing Guidelines
There is no single top-level automated test suite for this dotfiles repo.

- Validate changed shell scripts with `bash -n` and `shellcheck` (if installed).
- Use `stow -nv --target="$HOME" .` before applying links.
- Manually verify affected tools after changes (for example `zsh`, `nvim`, or `tmux` startup).
- For submodule changes, run that submodule's native tests from inside its directory.

## Commit & Pull Request Guidelines
- Follow the history pattern: concise, typed subjects such as `feat(scope): ...`, `fix(scope): ...`, `refactor: ...`, `chore: ...`.
- Keep commits focused to one logical change.
- Example: `fix(export.sh): correct PATH order for pyenv`.
- PRs should include: purpose, key paths changed, validation steps run, and any platform assumptions (Arch Linux, root-required scripts).
