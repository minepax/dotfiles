#!/bin/bash

STATE_FILE="$HOME/.current_theme"

# 1. Determine which theme to apply
if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" == "Meh" ]; then
    THEME="Hmm"
else
    THEME="Meh"
fi

# 2. Apply the Konsave profile
konsave -a "$THEME"

# 3. Update the state file
echo "$THEME" >"$STATE_FILE"

# 4. Refresh the Plasma Shell
plasmashell --replace >/dev/null 2>&1 &

# 5. Refreshing waybar as well
if pgrep -x "waybar" >/dev/null; then
    killall "waybar"
    sleep 1
fi
waybar &

# 6. Wait a moment and then send the notification
sleep 2
notify-send -a "Theme Switcher" "Theme Switched!" "Your desktop is now using the '$THEME' profile." -i preferences-desktop-theme -t 5000
