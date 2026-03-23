#!/bin/bash

STATE_FILE="$HOME/.current_theme"
OPTIONS="Meh\nHmm\nGrr"

THEME=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -p "Theme")

if [ -z "$THEME" ]; then
    exit 0
fi

# 1. Apply the Konsave profile
echo "Applying $THEME..."
konsave -a "$THEME"
echo "$THEME" >"$STATE_FILE"

# 2. THE TRIGGER: Tell KDE to broadcast the color change
# This is the "magic" command that forces Qt apps to repaint
CURRENT_SCHEME=$(grep 'ColorScheme=' "$HOME/.config/kdeglobals" | cut -d'=' -f2)
plasma-apply-colorscheme "$CURRENT_SCHEME"

# 3. Refresh KWin (Fixes titlebars and shadows)
qdbus6 org.kde.KWin /KWin reconfigure

# 4. Restart the Shell & Waybar (You already had this)
plasmashell --replace >/dev/null 2>&1 &
sleep 0.5
sh ~/.local/bin/waybar-refresh.sh

# 5. Send the notification
notify-send -a "Theme Switcher" "Theme Switched!" "'$THEME' Theme Applied!" -i preferences-desktop-theme -t 3000
