#!/usr/bin/env bash

BUS=2
STEP=10
CACHE="/tmp/external_monitor_brightness"

# Initialize cache if missing
[ ! -f "$CACHE" ] && echo 50 >"$CACHE"
CURRENT=$(cat "$CACHE")

if [ "$1" == "up" ]; then
    NEW=$((CURRENT + STEP > 100 ? 100 : CURRENT + STEP))
else
    NEW=$((CURRENT - STEP < 0 ? 0 : CURRENT - STEP))
fi

echo "$NEW" >"$CACHE"

# Instant OSD popup
swayosd-client --brightness="$NEW" >/dev/null 2>&1 &

# Non-blocking hardware write
ddcutil --bus=$BUS setvcp 10 $NEW --noverify >/dev/null 2>&1 &
