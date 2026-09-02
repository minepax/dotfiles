#!/bin/bash

STATE_FILE="$HOME/.current_location"
CACHE_FILE="/tmp/waybar_weather_cache.json"
OPTIONS="Sharjah\nDubai\nCoonoor\nCoimbatore\nCustom..."

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -theme-str 'window { width: 20ch; } mainbox { children: [ "listview" ]; }')

if [ -z "$CHOICE" ]; then
    exit 0
elif [ "$CHOICE" == "Custom..." ]; then
    NEW_LOC=$(rofi -dmenu -p "Enter City:" -theme-str 'mainbox { children: [ "inputbar" ]; }')
    [ -z "$NEW_LOC" ] && exit 0
    echo "$NEW_LOC" >"$STATE_FILE"
else
    echo "$CHOICE" >"$STATE_FILE"
fi

# FORCE REFRESH: Delete cache so the script fetches new data immediately
rm -f "$CACHE_FILE"

# Refresh Waybar
pkill -USR2 waybar

notify-send -a "Weather" "Location Updated" "Tracking weather for $(cat $STATE_FILE)"
