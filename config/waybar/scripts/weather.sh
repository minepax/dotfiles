#!/bin/bash

# --- CONFIGURATION ---
LOCATION=$(cat "$HOME/.current_location" 2>/dev/null || echo "Sharjah")
CACHE_FILE="/tmp/waybar_weather_cache.json"
CACHE_TTL=600 # 10 minutes in seconds
# ---------------------

# Check if cache is fresh
if [ -f "$CACHE_FILE" ]; then
    last_update=$(stat -c %Y "$CACHE_FILE")
    now=$(date +%s)
    if [ $((now - last_update)) -lt $CACHE_TTL ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Fetch new data from wttr.in (JSON format)
# We use --max-time to prevent Waybar from hanging if wttr.in is slow
weather_data=$(curl -s --max-time 7 "https://wttr.in/${LOCATION}?format=j1")

# Check if we got a valid JSON response
if [[ $? -ne 0 || -z "$weather_data" || "$weather_data" == *"toolate"* || "$weather_data" == *"503"* ]]; then
    if [ -f "$CACHE_FILE" ]; then
        # If API fails, serve the old cache
        cat "$CACHE_FILE"
    else
        echo "{\"text\": \"󰤭 N/A\", \"tooltip\": \"Weather service limited\"}"
    fi
    exit 0
fi

# Parse data using jq
temp=$(echo "$weather_data" | jq -r '.current_condition[0].temp_C')
code=$(echo "$weather_data" | jq -r '.current_condition[0].weatherCode')
desc=$(echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value')

# Mapping wttr.in codes to your preferred Nerd Font icons
case "$code" in
113) icon="󰖙" ;;                                                                   # Sunny
116) icon="󰖙" ;;                                                                   # Partly Cloudy
119 | 122) icon="󰖕" ;;                                                             # Cloudy
143 | 248 | 260) icon="󰖑" ;;                                                       # Fog/Mist
176 | 263 | 266 | 293 | 296 | 299 | 302 | 305 | 308 | 353 | 356 | 359) icon="󰖗" ;; # Rain
200 | 386 | 389 | 392 | 395) icon="󰙾" ;;                                           # Thunderstorm
*) icon="" ;;                                                                     # Default Cloudy
esac

# Construct JSON
output="{\"text\": \"$icon ${temp}°C\", \"tooltip\": \"$desc in $LOCATION\"}"

# Save to cache and print
echo "$output" >"$CACHE_FILE"
echo "$output"
