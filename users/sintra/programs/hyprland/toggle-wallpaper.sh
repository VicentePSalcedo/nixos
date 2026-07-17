#!/usr/bin/env bash
# Rotate through all wallpapers in the wallpapers directory
WALLPAPER_DIR="/home/sintra/nixos/wallpapers"
STATE_FILE="/tmp/current-wallpaper"

# Read current wallpaper name (or start at first)
CURRENT=""
if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
fi

# Collect wallpapers (non-hidden image files, sorted)
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    exit 1
fi

# Find index of current wallpaper, default to -1 (start at 0)
IDX=-1
for i in "${!WALLPAPERS[@]}"; do
    if [ "$(basename "${WALLPAPERS[$i]}")" = "$CURRENT" ]; then
        IDX=$i
        break
    fi
done

NEXT_IDX=$(( (IDX + 1) % ${#WALLPAPERS[@]} ))
NEXT="${WALLPAPERS[$NEXT_IDX]}"

killall swaybg 2>/dev/null
swaybg -i "$NEXT" -m fill &
echo "$(basename "$NEXT")" > "$STATE_FILE"
