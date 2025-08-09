#!/bin/bash

file="$1"

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

extractTitles "$file"
