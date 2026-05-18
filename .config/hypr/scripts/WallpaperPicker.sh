#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/wallpapers"
LAST_WALL="$HOME/.config/hypr/current_wallpaper"

mkdir -p "$WALL_DIR"

pgrep -x awww-daemon >/dev/null || awww-daemon &

sleep 0.2

mapfile -t WALLS < <(find "$WALL_DIR" -type f \( \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.png" -o \
  -iname "*.webp" -o \
  -iname "*.gif" \
\) | sort)

if [ "${#WALLS[@]}" -eq 0 ]; then
  notify-send "Wallpaper Picker" "Nenhum wallpaper encontrado em $WALL_DIR"
  exit 1
fi

SELECTED="$(
  printf '%s\n' "${WALLS[@]}" \
  | sed "s|$WALL_DIR/||" \
  | rofi -dmenu -i -p "Wallpaper"
)"

[ -z "$SELECTED" ] && exit 0

WALL="$WALL_DIR/$SELECTED"

if [ ! -f "$WALL" ]; then
  notify-send "Wallpaper Picker" "Arquivo não encontrado: $WALL"
  exit 1
fi

awww img "$WALL" \
  --transition-type grow \
  --transition-pos 0.5,0.5 \
  --transition-duration 0.8 \
  --transition-fps 60

echo "$WALL" > "$LAST_WALL"

notify-send "Wallpaper alterado" "$(basename "$WALL")"
