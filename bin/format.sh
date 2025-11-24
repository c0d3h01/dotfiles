#!/usr/bin/env bash
set -euo pipefail

declare -A FORMATTERS=(
  [".py"]="black '' isort ''"
  [".r"]="Rscript -e \"styler::style_file('{file}')\""
  [".go"]="gofmt -w"
  [".java"]="google-java-format -i"
  [".rs"]="rustfmt ''"
  [".php"]="php-cs-fixer fix"
  [".scala"]="scalafmt ''"
  [".pl"]="perltidy -b"
  [".lua"]="stylua ''"
  [".dart"]="dart format"
  [".xml"]="xmllint --format -o {file} {file}"
  [".js"]="prettier --write"
  [".ts"]="prettier --write"
  [".json"]="prettier --write"
  [".md"]="prettier --write"
  [".yaml"]="prettier --write"
  [".yml"]="prettier --write"
  [".sh"]="shfmt -w"
  [".c"]="clang-format -i"
  [".cpp"]="clang-format -i"
  [".h"]="clang-format -i"
  [".hpp"]="clang-format -i"
)

usage() {
  echo "Usage: $0 <target_folder>"
  exit 1
}

[[ $# -lt 1 ]] && usage

TARGET="$1"
[[ ! -d $TARGET ]] && {
  echo "Error: $TARGET is not a directory."
  exit 1
}

declare -A summary=([ok]=0 [fail]=0 [not_found]=0)

find_files() {
  find "$1" -type f | while read -r file; do
    ext="${file##*.}"
    ext=".$ext"
    [[ ${FORMATTERS[$ext]+x} ]] && echo "$file"
  done
}

format_file() {
  local file="$1"
  local ext
  ext=".$(basename "$file" | awk -F. '{print $NF}')"

  local cmds="${FORMATTERS[$ext]}"
  for cmd in $cmds; do
    local cmd_expanded="${cmd//\{file\}/$file}"

    local bin_name
    bin_name=$(echo "$cmd_expanded" | awk '{print $1}')

    if ! command -v "$bin_name" &>/dev/null; then
      echo "  [$bin_name] not found"
      ((summary[not_found]++))
      continue
    fi

    echo "  [$bin_name] running..."
    if eval "$cmd_expanded" &>/dev/null; then
      echo "  [$bin_name] ok"
      ((summary[ok]++))
    else
      echo "  [$bin_name] fail"
      ((summary[fail]++))
    fi
  done
}

# Properly read files into array
files=()
while IFS= read -r line; do
  files+=("$line")
done < <(find_files "$TARGET")

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No supported files to format."
  exit 0
fi

echo "Found ${#files[@]} files to format."

for f in "${files[@]}"; do
  echo "Formatting: $f"
  format_file "$f"
  echo
done

echo "Summary:"
echo "  Successfully formatted: ${summary[ok]}"
echo "  Errors:                ${summary[fail]}"
echo "  Formatter not found:   ${summary[not_found]}"
