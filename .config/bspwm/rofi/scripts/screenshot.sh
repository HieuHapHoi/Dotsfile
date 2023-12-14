#!/usr/bin/env bash

# Picture Path
areaPath="$HOME/Pictures/Area/"
fullscreenPath="$HOME/Pictures/Fullscreen/"
time=$(date +%Y%m%d-%H%M%S)
file="Screenshot_${time}.png"

# Rofi command 
rofi_cmd() {
 rofi -theme ~/.config/bspwm/rofi/powermenu.rasi -p 'maim' -dmenu \
  -theme-str 'inputbar { padding: 50px 50px; }' \
  -theme-str 'textbox-prompt-colon { str: "󱣴 Screenshot"; }' \
	-theme-str 'listview {columns: 2; lines: 1;}'\
  -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 450px;}' \ 
}

# Options For Rofi
area=""
fullscreen=""
options="$area\n$fullscreen"
choice="$(echo -e "$options" | rofi_cmd)"

# Notify commands
notify_view() {
  dunstify -u low -I $file "📷 Screenshot taken."
}

# Screenshot Commands
case $choice in 
  $area) 
    cd ${areaPath} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | tee "$file" | xclip -selection clipboard -t image/png
    notify_view
  ;;
  $fullscreen) 
    sleep 1 && cd ${fullscreenPath} && maim -u -f png -b 2 -c 0.35,0.55,0.85,0.25 -l | tee "$file" | xclip -selection clipboard -t image/png
    notify_view
  ;;
esac
  






