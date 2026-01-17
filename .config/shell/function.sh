#!/bin/sh

# Display PATH
path() {
    print -l ${(s.:.)PATH} | command bat --language=bash --style=plain 2>/dev/null || print -l ${(s.:.)PATH}
}

# Extract archives
extract() {
    local file="$1" dir="${2:-.}"
    [[ ! -f "$file" ]] && { print -u2 "Error: '$file' not found"; return 1; }

    case "${file:l}" in
        *.tar.bz2|*.tbz2) tar -xjf "$file" -C "$dir" ;;
        *.tar.gz|*.tgz)   tar -xzf "$file" -C "$dir" ;;
        *.tar.xz|*.txz)   tar -xJf "$file" -C "$dir" ;;
        *.tar.zst|*.tzst) tar -xf "$file" -C "$dir" ;;
        *.bz2)            bunzip2 -k "$file" ;;
        *.gz)             gunzip -k "$file" ;;
        *.tar)            tar -xf "$file" -C "$dir" ;;
        *.zip)            unzip -q "$file" -d "$dir" ;;
        *.7z)             7z x "$file" -o"$dir" ;;
        *.xz)             unxz -k "$file" ;;
        *.zst)            unzstd "$file" ;;
        *) print -u2 "Error: Unknown format"; return 1 ;;
    esac && print "✓ Extracted to '$dir'"
}

# Make dir and cd
mkcd() {
    [[ -z "$1" ]] && { print -u2 "Usage: mkcd <dir>"; return 1; }
    mkdir -p "$1" && cd "$1"
}

# Smart make
make() {
    local build_path="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    [[ ! -f "$build_path/Makefile" ]] && build_path="."
    command nice -n 19 make -C "$build_path" -j"$(nproc)" "$@"
}

# Fuzzy edit
fe() {
    local file=$(fd --type f --hidden --exclude .git \
        | fzf --height 40% --reverse --preview 'bat --color=always {}' --preview-window=right:60%)
    [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

# Kill process
fkill() {
    local pid=$(ps -ef | sed 1d | fzf -m --height 40% --reverse | awk '{print $2}')
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -${1:-15} && print "✓ Killed: $pid"
}

# Network
myip() { curl -s https://api.ipify.org && echo; }
localip() { ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1; }

# Docker cleanup
dclean() {
    docker container prune -f
    docker image prune -af
    docker volume prune -f
    print "✓ Docker cleaned"
}
