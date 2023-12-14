#!/usr/bin/env bash

dir="$HOME/.config/bspwm/rofi/"
theme='power5'

# Get information
lastLogin="$(last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7)"
upTime="$(uptime -p | sed -e 's/up //g')"
hostName=$(hostname)

# Icon
shutdown=''
reboot=''
lock=''
logout=''
yes='󰋔'
no='󰣐'

# Open powermenu
rofi_cmd() {
  dunstify -u low "  Openning power menu ..."
	rofi -dmenu \
		-p " $USER@$hostName" \
		-mesg " Last Login: $lastLogin |  Uptime: $upTime" \
		-theme ~/.config/bspwm/rofi/powermenu.rasi
}

# Confirm message 
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 450px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
    -mesg 'You want to leave me :(' \
		-theme ~/.config/bspwm/rofi/powermenu.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
      dunstify -u low "  Shutting down..." 
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
      dunstify -u low "  Rebooting..."
      systemctl reboot
		elif [[ $1 == '--logout' ]]; then
      dunstify -u low "  Logging out..."
      bspc quit
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
	run_cmd --shutdown
	;;
$reboot)
	run_cmd --reboot
	;;
$lock)
  dunstify -u low "  Locking..."
	betterlockscreen -l
	;;
$logout)
	run_cmd --logout
	;;
esac
