#!/bin/bash

STATE_FILE="$HOME/.current_location"

# 1. Define your favorite/frequent locations here
OPTIONS="Sharjah\nDubai\nCoonoor\nCoimbatore\nCustom..."

# 2. Get user selection via Rofi
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -theme-str '
    window {
        width: 20ch;
    }

    mainbox {
        children: [ "listview" ];
    }

    listview {
        dynamic: true;
        fixed-height: false;
    }
')

# 3. Handle the selection
if [ -z "$CHOICE" ]; then
    exit 0 # User pressed Esc
elif [ "$CHOICE" == "Custom..." ]; then
    NEW_LOC=$(rofi -dmenu -theme-str '
        mainbox {
            children: [ "inputbar" ];
        }

        entry {
            placeholder: "Enter City Name...";
        }
    ')
    [ -z "$NEW_LOC" ] && exit 0
    echo "$NEW_LOC" >"$STATE_FILE"
else
    echo "$CHOICE" >"$STATE_FILE"
fi

# 4. Refresh Waybar to update the weather immediately
# Using SIGRTMIN+n if you use signals, or just pkill -USR2
pkill -USR2 waybar

notify-send -a "Waybar Weather Widget" "Location Updated" "Weather is now tracking $(cat $STATE_FILE)" -i weather-clear
