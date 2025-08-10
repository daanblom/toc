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
    local titles=()
    local indent=" "
    local prefix=""

    while IFS= read -r line; do
        if [[ "$line" =~ ^# ]]; then
          if [[ $(echo "$line" | grep -c "^# ") -eq 1 ]]; then
                indent=""
                prefix="- "
              elif [[ $(echo "$line" | grep -c "^## ") -eq 1 ]]; then
                indent=" "
                prefix="* "
              elif [[ $(echo "$line" | grep -c "^### ") -eq 1 ]]; then
                indent="  "
                prefix="* "
              elif [[ $(echo "$line" | grep -c "^#### ") -eq 1 ]]; then
                indent="   "
                prefix="* "
              elif [[ $(echo "$line" | grep -c "^##### ") -eq 1 ]]; then
                indent="    "
                prefix="* "
              elif [[ $(echo "$line" | grep -c "^###### ") -eq 1 ]]; then
                indent="     "
                prefix="* "
            else
                indent=""
                prefix=""
            fi
            title=$(echo "$line" | sed 's/^#* //')
            Fulltitle=$(echo "$line")
            echo "$indent$prefix[$title](#$(echo $title | sed 's/ /-/g'))"
        fi
    done < "$file"
}

createTOC "$file"
