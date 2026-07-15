#!/usr/bin/env bash
# Toggle desktop wallpaper between tokyonight.png and waifu.jpg
WALLPAPER_DIR="/home/sintra/nixos/wallpapers"
STATE_FILE="/tmp/current-wallpaper"

if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
else
    CURRENT="tokyonight.png"
fi

if [ "$CURRENT" = "tokyonight.png" ]; then
    NEXT="waifu.jpg"
else
    NEXT="tokyonight.png"
fi

killall swaybg 2>/dev/null
swaybg -i "$WALLPAPER_DIR/$NEXT" -m fill &
echo "$NEXT" > "$STATE_FILE"
