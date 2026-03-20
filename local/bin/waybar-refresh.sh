# Kill all workspaces.sh process to bypass the lag
pkill -f workspaces.sh

# Restart Waybar
if pgrep -x "waybar" >/dev/null; then
    killall "waybar"
fi
waybar &
