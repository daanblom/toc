#!/bin/bash

file="$1"

fileCheck () {
  local firstLine=$(cat "$1" | head -n 1)

  if [[ ! "$1" =~ \.(md|markdown|mdown)$ ]]; then
    echo "This is not a markdown file, exitting..." & exit 1
  fi
  if [[ ( ! "$firstLine" =~ ^(#|---) ) || "$firstLine" =~ ^#! ]]; then
  echo "Error! This Markdown file doest not start with a '# Title 1' or a YAML block"
  fi

}

extractTitles() {
    local file="$1"
    local line level title indent prefix

    while IFS= read -r line; do
        if [[ $line =~ ^(#{1,6})[[:space:]]+(.*) ]]; then
            level=${#BASH_REMATCH[1]}      # heading level = number of '#'
            title=${BASH_REMATCH[2]}       # actual heading text

            # Indent: 0 for h1, 1 space for h2, etc.
            indent=$(printf '%*s' $((level - 1)) '')

            # Prefix: dash for h1, asterisk otherwise
            if (( level == 1 )); then
                prefix="- "
            else
                indent=""
                prefix=""
            fi

            # Anchor: lowercase, spaces -> '-', remove non-alphanum except '-'
            anchor=$(echo "$title" | tr '[:upper:]' '[:lower:]' \
                     | sed -E 's/[^a-z0-9 -]//g; s/[[:space:]]+/-/g')

            echo "${indent}${prefix}[${title}](#${anchor})"
        fi
    done < "$file"
}

createTOC "$file"
