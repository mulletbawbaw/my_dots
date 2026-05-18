#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/wallpapers"
LAST_WALL="$HOME/.config/hypr/current_wallpaper"

pgrep -x awww-daemon >/dev/null || awww-daemon &

sleep 0.5

if [ -f "$LAST_WALL" ] && [ -f "$(cat "$LAST_WALL")" ]; then
  awww img "$(cat "$LAST_WALL")" \
    --transition-type fade \
    --transition-duration 0.5
else
  FIRST_WALL="$(find "$WALL_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" -o \
    -iname "*.gif" \
  \) | sort | head -n 1)"

  [ -n "$FIRST_WALL" ] && awww img "$FIRST_WALL" --transition-type fade
fi
