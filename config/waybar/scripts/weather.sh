#!/bin/bash

# --- CONFIGURATION ---
LOCATION=$(cat "$HOME/.current_location" || echo "Coonoor")
# ---------------------

# 1. Geocoding: Get Lat/Lon
geo_data=$(curl -s "https://geocoding-api.open-meteo.com/v1/search?name=$LOCATION&count=1&language=en&format=json")

if [[ -z "$geo_data" || "$geo_data" == *"\"results\":null"* ]]; then
    echo "{\"text\": \"󰖪 Error\", \"tooltip\": \"Location not found\"}"
    exit 0
fi

lat=$(echo "$geo_data" | jq '.results[0].latitude')
lon=$(echo "$geo_data" | jq '.results[0].longitude')
full_name=$(echo "$geo_data" | jq -r '.results[0].name')

# 2. Weather: Fetch data
weather_data=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true")

if [[ -z "$weather_data" || "$weather_data" == *"error"* ]]; then
    echo "{\"text\": \"󰖪 Error\", \"tooltip\": \"Weather service down\"}"
    exit 0
fi

# Parse weather
temp=$(echo "$weather_data" | jq '.current_weather.temperature' | sed 's/\..*//')
code=$(echo "$weather_data" | jq '.current_weather.weathercode')

# 3. Granular Mapping (Separating 1, 2, and 3)
case "$code" in
0)
    icon="󰖙"
    desc="Sunny"
    ;; # Google: Sunny
1)
    icon="󰖙"
    desc="Mostly Sunny"
    ;; # Google: Mostly Sunny
2)
    icon="󰖕"
    desc="Partly Cloudy"
    ;; # Google: Partly Cloudy
3)
    icon="󰖐"
    desc="Mostly Cloudy"
    ;; # Google: Mostly Cloudy
45 | 48)
    icon="󰖑"
    desc="Mist"
    ;; # Google: Mist
51 | 53 | 55)
    icon="󰖖"
    desc="Showers"
    ;; # Google: Showers
61 | 63 | 65)
    icon="󰖗"
    desc="Rain"
    ;; # Google: Rain
80 | 81 | 82)
    icon="󰖖"
    desc="Rain Showers"
    ;;
95 | 96 | 99)
    icon="󰙾"
    desc="Thunderstorm"
    ;;
*)
    icon=""
    desc="Cloudy"
    ;;
esac

# Return JSON to Waybar
# I added (Code: $code) to the tooltip so you can verify it's changing!
echo "{\"text\": \"$icon ${temp}°C\", \"tooltip\": \"$desc in $full_name\"}"
