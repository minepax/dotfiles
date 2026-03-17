#!/bin/bash

CACHE_FILE="$HOME/.cache/rofi-file-cache.txt"
SEARCH_DIR="$HOME"

# If no argument is passed, show the list
if [ -z "$1" ]; then
    if [ -f "$CACHE_FILE" ]; then
        cat "$CACHE_FILE"
    else
        # Fallback if cache doesn't exist yet
        echo "Cache not found. Run update-script first."
    fi
else
    # If an argument is passed, open it
    xdg-open "$1" >/dev/null 2>&1 &
    disown
fi
