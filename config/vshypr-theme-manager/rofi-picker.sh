#!/usr/bin/env bash
# Lanzador de theme-changer vía Rofi.
# Cada entrada muestra: miniatura del wallpaper + paleta de colores + nombre.
# Temas separados por variante: oscuros / claros.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
STATE_FILE="$SCRIPT_DIR/current-theme.json"

CURRENT_THEME=$(jq -r '.theme // ""' "$STATE_FILE" 2>/dev/null || echo "")

# ── Helpers ────────────────────────────────────────────────────────────────────

get_color() { jq -r ".colors.$2 // \"#888888\"" "$THEMES_DIR/$1/colors.json" 2>/dev/null; }
get_meta()  { jq -r ".meta.$2  // \"\""         "$THEMES_DIR/$1/colors.json" 2>/dev/null; }
swatch()    { printf '<span foreground="%s" background="%s">%s</span>' "$1" "$1" "$2"; }

# Imprime una entrada con icono (null-byte metadata — no almacenar en variable)
build_entry() {
    local theme="$1"
    local colors_file="$THEMES_DIR/$theme/colors.json"
    [[ ! -f "$colors_file" ]] && return

    local bg surface2 accent teal green red fg display_name variant

    bg=$(get_color "$theme" "bg")
    surface2=$(get_color "$theme" "surface2")
    accent=$(get_color "$theme" "accent")
    teal=$(get_color "$theme" "teal")
    green=$(get_color "$theme" "green")
    red=$(get_color "$theme" "red")
    fg=$(get_color "$theme" "fg")
    display_name=$(get_meta "$theme" "display_name")
    [[ -z "$display_name" ]] && display_name=$(get_meta "$theme" "name")
variant=$(get_meta "$theme" "variant")

    local variant_icon
    if [[ "$variant" == "light" ]]; then
        variant_icon="<span foreground='#ddaa44' font_weight='bold'> </span>"
    else
        variant_icon="<span foreground='#7090cc'> </span>"
    fi

    local marker=""
    [[ "$theme" == "$CURRENT_THEME" ]] && \
        marker="  <span foreground='${accent}' font_weight='bold'></span>"

    local palette=""
    palette+="$(swatch "$bg"       "  ")"
    palette+="$(swatch "$surface2" "  ")"
    palette+="$(swatch "$accent"   "    ")"
    palette+="$(swatch "$teal"     "  ")"
    palette+="$(swatch "$green"    "  ")"
    palette+="$(swatch "$red"      "  ")"
    palette+="$(swatch "$fg"       "  ")"

    # Icono: thumb.jpg del tema (miniatura 80x80 del wallpaper)
    local icon_path="$THEMES_DIR/$theme/thumb.jpg"

    # Formato rofi: texto\0icon\x1fruta_icono
    printf '%s  %s  <span font_weight="600">%s</span>%s\0icon\x1f%s\n' \
        "$palette" "$variant_icon" "$display_name" "$marker" "$icon_path"
}

build_header() {
    local label="$1" icon="$2" color="$3"
    printf '<span foreground="%s" font_weight="bold" font_size="small">  %s  %s  </span>\n' \
        "$color" "$icon" "$label"
}

# ── Recolectar temas por variante ──────────────────────────────────────────────

DARK_THEMES=()
LIGHT_THEMES=()

while IFS= read -r -d '' theme_dir; do
    theme=$(basename "$theme_dir")
    [[ "$theme" == dynamic* ]] && continue
    [[ ! -f "$theme_dir/colors.json" ]] && continue

    if [[ "$(get_meta "$theme" "variant")" == "light" ]]; then
        LIGHT_THEMES+=("$theme")
    else
        DARK_THEMES+=("$theme")
    fi
done < <(find "$THEMES_DIR" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

# ── Índice THEME_NAMES (paralelo al stream) ────────────────────────────────────

THEME_NAMES=("__sep__")                          # cabecera OSCUROS
for t in "${DARK_THEMES[@]}";  do THEME_NAMES+=("$t"); done
THEME_NAMES+=("__sep__")                          # cabecera CLAROS
for t in "${LIGHT_THEMES[@]}"; do THEME_NAMES+=("$t"); done
THEME_NAMES+=("__sep__")                          # cabecera DINÁMICOS
THEME_NAMES+=("dynamic-dark")
THEME_NAMES+=("dynamic-light")

# ── Función que genera el stream a rofi ───────────────────────────────────────

stream_entries() {
    build_header "OSCUROS" "" "#7090cc"
    for t in "${DARK_THEMES[@]}";  do build_entry "$t"; done

    build_header "CLAROS" "" "#ddaa44"
    for t in "${LIGHT_THEMES[@]}"; do build_entry "$t"; done

    build_header "DINÁMICO" "󰟷" "#88aa77"

    # Dynamic Dark
    local dd_marker="" dd_accent="#556688"
    [[ "$CURRENT_THEME" == "dynamic-dark" ]] && dd_marker="  <span foreground='${dd_accent}' font_weight='bold'></span>"
    printf '%s  %s  <span foreground="#7788aa" font_weight="600">Dynamic Dark</span>  <span foreground="#556677" font_style="italic" font_size="small">matugen · oscuro</span>%s\n' \
        "$(swatch "#1a1d2a" "  ")$(swatch "#252836" "  ")$(swatch "#556688" "    ")$(swatch "#334455" "  ")$(swatch "#335544" "  ")$(swatch "#664444" "  ")$(swatch "#889099" "  ")" \
        "<span foreground='#7090cc'> </span>" \
        "$dd_marker"

    # Dynamic Light
    local dl_marker="" dl_accent="#886622"
    [[ "$CURRENT_THEME" == "dynamic-light" ]] && dl_marker="  <span foreground='${dl_accent}' font_weight='bold'></span>"
    printf '%s  %s  <span foreground="#886622" font_weight="600">Dynamic Light</span>  <span foreground="#998855" font_style="italic" font_size="small">matugen · claro</span>%s\n' \
        "$(swatch "#f5f0e8" "  ")$(swatch "#e8e0d4" "  ")$(swatch "#cc8833" "    ")$(swatch "#669966" "  ")$(swatch "#557755" "  ")$(swatch "#cc4444" "  ")$(swatch "#333322" "  ")" \
        "<span foreground='#ddaa44'> </span>" \
        "$dl_marker"
}

# ── Mostrar Rofi ───────────────────────────────────────────────────────────────

stream_entries | rofi \
    -dmenu \
    -markup-rows \
    -show-icons \
    -i \
    -matching fuzzy \
    -p "󰸉  tema" \
    -format "i" \
    -kb-custom-1 "alt+Return" \
    -mesg "<span font_size='small' foreground='#8b949e'>Alt+Enter  →  aplicar con wallpaper del tema</span>" \
    -theme ~/.config/rofi/theme-picker.rasi \
    > /tmp/rofi-theme-sel
ROFI_EXIT=$?

[[ ! -s /tmp/rofi-theme-sel ]] && exit 0
SELECTED_IDX=$(cat /tmp/rofi-theme-sel)

[[ -z "$SELECTED_IDX" ]] && exit 0

SELECTED_THEME="${THEME_NAMES[$SELECTED_IDX]}"
[[ -z "$SELECTED_THEME" || "$SELECTED_THEME" == "__sep__" ]] && exit 0

# ROFI_EXIT 0 = Enter normal · 10 = Alt+Enter (aplicar con wallpaper)
WITH_WALLPAPER=0
[[ "$ROFI_EXIT" == "10" ]] && WITH_WALLPAPER=1

echo "[$(date)] idx=$SELECTED_IDX theme=$SELECTED_THEME wp=$WITH_WALLPAPER" >> /tmp/theme-picker.log

# ── Aplicar ────────────────────────────────────────────────────────────────────

# Busca wallpaper del tema estático
find_theme_wallpaper() {
    local theme="$1"
    for ext in jpg png jpeg webp; do
        local f="$THEMES_DIR/$theme/wallpaper.$ext"
        [[ -f "$f" ]] && echo "$f" && return
    done
}

if [[ "$SELECTED_THEME" == "dynamic-dark" || "$SELECTED_THEME" == "dynamic-light" ]]; then
    # Recolectar wallpapers en array indexado
    mapfile -d '' WALLPAPERS < <(find "/home/vhs/Imágenes/wallpapers" \
        -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        -print0 2>/dev/null | sort -z)

    # Generar entradas con miniatura y pipear directo a rofi (los null bytes no sobreviven variables)
    WP_IDX=$(for wp in "${WALLPAPERS[@]}"; do
        printf '%s\0icon\x1f%s\n' "$(basename "$wp")" "$wp"
    done | rofi \
        -dmenu \
        -markup-rows \
        -show-icons \
        -i \
        -p "󰋩  wallpaper" \
        -format "i" \
        -theme ~/.config/rofi/wallpaper-picker.rasi)

    [[ -z "$WP_IDX" ]] && exit 0
    WALLPAPER="${WALLPAPERS[$WP_IDX]}"
    [[ -z "$WALLPAPER" ]] && exit 0

    python3 "$SCRIPT_DIR/vshypr-theme-manager.py" "$SELECTED_THEME" "$WALLPAPER" >> /tmp/theme-picker.log 2>&1
else
    if [[ "$WITH_WALLPAPER" == "1" ]]; then
        THEME_WP=$(find_theme_wallpaper "$SELECTED_THEME")
        if [[ -n "$THEME_WP" ]]; then
            python3 "$SCRIPT_DIR/vshypr-theme-manager.py" "$SELECTED_THEME" "$THEME_WP" >> /tmp/theme-picker.log 2>&1
        else
            python3 "$SCRIPT_DIR/vshypr-theme-manager.py" "$SELECTED_THEME" >> /tmp/theme-picker.log 2>&1
        fi
    else
        python3 "$SCRIPT_DIR/vshypr-theme-manager.py" "$SELECTED_THEME" >> /tmp/theme-picker.log 2>&1
    fi
fi

echo "[$(date)] done" >> /tmp/theme-picker.log
