#!/bin/bash

# Optimized for Plasma 6 / CachyOS
SERVICE="org.kde.KWin"
PATH_VD="/VirtualDesktopManager"
IFACE="org.kde.KWin.VirtualDesktopManager"

# Function to get and format workspaces
print_workspaces() {
    # 1. Fetch current and all UUIDs using busctl (faster than qdbus)
    current_uuid=$(busctl --user get-property $SERVICE $PATH_VD $IFACE "current" | awk '{print $2}' | tr -d '"')

    # We fetch the list of desktops. We use a simpler grep to keep it snappy.
    all_uuids=$(busctl --user get-property $SERVICE $PATH_VD $IFACE "desktops" | grep -oE '[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}')

    total=$(echo "$all_uuids" | wc -l)
    output=""
    current_idx=0
    index=0

    for uuid in $all_uuids; do
        index=$((index + 1))
        if [ "$uuid" == "$current_uuid" ]; then
            output+=" "
            current_idx=$index
        else
            output+=" "
        fi
    done

    # JSON for Waybar
    echo "{\"text\": \"$output\", \"class\": \"ws-$current_idx\", \"tooltip\": \"<b>Workspace $current_idx</b> of $total\"}"
}

# 1. Initial run
print_workspaces

# 2. Efficient Monitoring
# We use 'busctl monitor' which is lighter than dbus-monitor
# We use 'grep' to ensure the loop ONLY fires when the signal actually happens
busctl --user monitor $SERVICE | grep --line-buffered "currentChanged" | while read -r _; do
    print_workspaces
done
