# Aliases
def l [] { ls }
def la [] { ls -a }
def ll [] { ls -l }
def vimrc [] { nvim ~/.vimrc }
def nvimrc [] { nvim ~/.config/nvim }
def dotfiles [] { nvim ~/.config/nvim }

alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

alias c = clear
alias vi = nvim
alias rm = rm -i
alias cp = cp -i
alias mv = mv -i

if not (which fd | is-empty) { alias find = fd --color=auto --hidden --follow --exclude .git }
if not (which rg | is-empty) { alias grep = rg --color=auto --smart-case }
if not (which bat | is-empty) { alias cat = bat --style=auto --theme=ansi }
if not (which htop | is-empty) { alias top = htop }
if (which rg | is-empty) { alias grep = grep --color=auto }

alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git pull
alias gd = git diff
alias gco = git checkout
alias gb = git branch
alias glog = git log --oneline --graph --decorate

# --- Direnv Hook ---
use std/config *
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [])
$env.config.hooks.env_change.PWD ++= [{||
    if (which direnv | is-empty) {
        return
    }

    direnv export json | from json | default {} | load-env
    $env.PATH = do (env-conversions).path.from_string $env.PATH
}]
