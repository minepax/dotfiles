#!/bin/bash

# 1. Take a screenshot of a selected area and save it to a temporary file
SCR_TEMP="/tmp/ocr_snapshot.png"
maim -s "$SCR_TEMP"

# 2. Check if the file was created (user might have pressed Esc)
if [ ! -f "$SCR_TEMP" ]; then
    exit 1
fi

# 3. Use Tesseract to extract text (sent to stdout)
# We use '-' to tell tesseract to output to terminal, then pipe to wl-copy
tesseract "$SCR_TEMP" - -l eng 2>/dev/null | wl-copy

# 4. Optional: Send a small notification so you know it worked
notify-send "OCR Grabber" "Text copied to clipboard!" -i edit-paste -t 2000

# 5. Clean up
rm "$SCR_TEMP"
