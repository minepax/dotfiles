#!/bin/bash

# Define the options with icons
OPTIONS="\n\n\n\n󰗼"

# Launch Rofi
# I've set a slim width (15%) to make it look like a vertical power strip
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -no-show-icons -theme-str '
    window {
        fullscreen: true;
        location: center;
        anchor: center;
        border: 0px;
        border-radius: 0px;
    }
    
    mainbox {
        children: [ "listview" ];
    }

    listview {
        columns: 5;
        spacing: 50px;
        margin: 35% 0;
        fixed-columns: true;
    }

    element {
        orientation: horizontal;
        padding: 90px 50px;
    }

    element-text {
        font: "JetBrains Nerd Font 48";
        vertical-align: 0.5;
        horizontal-align: 0.5;
    }
')

case "$CHOICE" in
*)
    systemctl poweroff
    ;;
*)
    systemctl reboot
    ;;
*)
    systemctl suspend
    ;;
*)
    loginctl lock-session
    ;;
*󰗼)
    qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
    ;;
*)
    exit 0
    ;;
esac
