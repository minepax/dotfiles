#!/bin/bash
DIR_TO_SHOW="$HOME/Pictures/Wallpapers/Grr"

# Loop through common image extensions
for imageFile in "$DIR_TO_SHOW"/*.{jpg,jpeg,png,webp}; do
    [ -e "$imageFile" ] || continue # Handle empty directory case
    echo -en " \0icon\x1f$imageFile\n"
done
