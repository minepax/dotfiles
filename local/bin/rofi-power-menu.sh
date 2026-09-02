#!/bin/bash

# Define the options with icons
OPTIONS="󰐥\n\n\n\n󰗼"

# Launch Rofi
# I've set a slim width (15%) to make it look like a vertical power strip
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -theme-str '
    window {
        width: 800px;
        location: center;
        anchor: center;
    }

    mainbox {
        children: [ "listview" ];
    }

    listview {
        columns: 5;
        lines: 1;
        spacing: 20px;
        margin: 0 0;
    }

    element {
        padding: 50px;
    }

    element-text {
        font: "JetBrains Nerd Font 24";
        vertical-align: 0.5;
        horizontal-align: 0.5;
    }
')

case "$CHOICE" in
*󰐥)
    systemctl poweroff
    ;;
*)
    systemctl reboot
    ;;
*)
    systemctl suspend
    ;;
*)
    hyprlock
    ;;
*󰗼)
    loginctl terminate-user $USER
    ;;
*)
    exit 0
    ;;
esac
