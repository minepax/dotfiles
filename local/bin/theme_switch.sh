#!/bin/bash

STATE_FILE="$HOME/.current_theme"

# 1. Define your themes here (Add more here later!)
OPTIONS="Hmm\nMeh\nGrr"

# 2. Get user selection via Rofi
# We use -i for case-insensitive and -p for the prompt
THEME=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -p "Theme")

# 3. Exit if the user presses Esc (THEME will be empty)
if [ -z "$THEME" ]; then
    exit 0
fi

# 4. Apply the Konsave profile
echo "Applying $THEME..."
konsave -a "$THEME"

# 5. Update the state file
echo "$THEME" >"$STATE_FILE"

# 6. Refresh the Plasma Shell
# We run this in the background so the script doesn't hang
plasmashell --replace >/dev/null 2>&1 &

# 7. Refresh Waybar
if pgrep -x "waybar" >/dev/null; then
    killall "waybar"
    sleep 1
fi
waybar &

# 8. Send the notification
sleep 2
notify-send -a "Theme Switcher" "Theme Switched!" "Your desktop is now using the '$THEME' profile." -i preferences-desktop-theme -t 5000
