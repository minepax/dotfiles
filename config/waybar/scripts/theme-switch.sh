#!/bin/bash
STATE_FILE="$HOME/.current_theme"

if [ -f "$STATE_FILE" ]; then
    THEME=$(cat "$STATE_FILE")
else
    THEME="Unknown"
fi

# This is what will show up in your bar
echo "󰃣 $THEME"
