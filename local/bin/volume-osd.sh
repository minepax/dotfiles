#!/bin/bash

# Function to get the current volume
get_volume() {
    pamixer --get-volume
}

# Function to check if muted
is_mute() {
    pamixer --get-mute
}

# Handle the volume change
case $1 in
up)
    pamixer -i 5 --unmute
    ;;
down)
    pamixer -d 5 --unmute
    ;;
mute)
    pamixer -t
    ;;
esac

VOLUME=$(get_volume)
MUTE=$(is_mute)

# Determine the icon and message
if [ "$MUTE" == "true" ] || [ "$VOLUME" -eq 0 ]; then
    icon="audio-volume-muted-symbolic"
    msg="Muted"
    val=0
else
    val=$VOLUME
    if [ "$VOLUME" -lt 33 ]; then
        icon="audio-volume-low-symbolic"
    elif [ "$VOLUME" -lt 66 ]; then
        icon="audio-volume-medium-symbolic"
    else
        icon="audio-volume-high-symbolic"
    fi
    msg="Volume: ${VOLUME}%"
fi

# The magic command:
# -h int:value:$val -> Creates the slider
# -h string:x-canonical-private-synchronous:vol_notif -> Updates the same bubble
# -u low -> Prevents it from cluttering the notification history
notify-send -h int:value:"$val" -h string:x-canonical-private-synchronous:vol_notif -u low -i "$icon" -t 1500 "$msg"
