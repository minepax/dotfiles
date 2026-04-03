#!/bin/bash
SEARCH_DIR="$HOME"
CACHE_FILE="$HOME/.cache/rofi-file-cache.txt"

fd . "$SEARCH_DIR" \
    "$HOME/.config" \
    "$HOME/.local/bin" \
    --type f \
    --exclude .git \
    --exclude .cache \
    --exclude node_modules \
    --exclude .mozilla \
    --exclude mnt \
    --exclude .config/BraveSoftware |
    awk '
{
    full_path = $0
    n_path = split(full_path, path_parts, "/")
    filename = path_parts[n_path]

    # Safer way to get the directory path without Regex
    dir_path = full_path
    len_full = length(full_path)
    len_file = length(filename)
    dir_path = substr(full_path, 1, len_full - len_file)
    
    # Clean up the home tilde
    sub("^" ENVIRON["HOME"], "~", dir_path)

    n_ext = split(filename, ext_parts, ".")
    ext = (n_ext > 1) ? tolower(ext_parts[n_ext]) : ""

    icon = "document"
    if (ext == "pdf") icon = "application-pdf"
    else if (ext ~ /^(jpg|jpeg|png|gif|svg|webp)$/) icon = "image-x-generic"
    else if (ext ~ /^(mp4|mkv|avi|mov|webm)$/) icon = "video-x-generic"
    else if (ext ~ /^(mp3|wav|flac|ogg|m4a)$/) icon = "audio-x-generic"
    else if (ext ~ /^(xlsx|xls|ods|csv)$/) icon = "libreoffice-calc"
    else if (ext ~ /^(docx|doc|odt)$/) icon = "libreoffice-writer"
    else if (ext ~ /^(pptx|ppt|odp)$/) icon = "libreoffice-impress"
    else if (ext ~ /^(txt|md|json|yaml|conf|ini)$/) icon = "text-x-generic"
    else if (ext ~ /^(sh|py|js|cpp|rs|go)$/) icon = "text-x-script"

    display_text = filename "  <span weight=\"light\" size=\"small\" alpha=\"50%\">" dir_path "</span>"
    print full_path "\x00display\x1f" display_text "\x1ficon\x1f" icon
}' >"$CACHE_FILE"
