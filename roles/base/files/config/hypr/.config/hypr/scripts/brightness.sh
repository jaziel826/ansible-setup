#!/usr/bin/env bash

iDIR="$HOME/.config/swaync/icons"

# Get brightness
get_backlight() {
	LIGHT=$(printf "%.0f\n" $(brightnessctl i))
	echo "${LIGHT}%"
}

# Get icons
get_icon() {
	backlight="$(brightnessctl g)"
	current="${backlight%%%}"
	if [[ ("$current" -ge "0") && ("$current" -le "40") ]]; then
		icon="$iDIR/brightness-1.svg"
	elif [[ ("$current" -ge "40") && ("$current" -le "80") ]]; then
		icon="$iDIR/brightness-2.svg"
	elif [[ ("$current" -ge "80") && ("$current" -le "120") ]]; then
		icon="$iDIR/brightness-3.svg"
	elif [[ ("$current" -ge "120") && ("$current" -le "160") ]]; then
		icon="$iDIR/brightness-4.svg"
	elif [[ ("$current" -ge "160") && ("$current" -le "200") ]]; then
		icon="$iDIR/brightness-5.svg"
	elif [[ ("$current" -ge "200") && ("$current" -le "240") ]]; then
		icon="$iDIR/brightness-6.svg"
	elif [[ ("$current" -ge "240") && ("$current" -le "255") ]]; then
		icon="$iDIR/brightness-7.svg"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$icon" "Brightness : $(brightnessctl g)"
}

# Increase brightness
inc_backlight() {
	brightnessctl set 5+ && get_icon && notify_user
}

# Decrease brightness
dec_backlight() {
	brightnessctl set 5- && get_icon && notify_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	brightnessctl g
elif [[ "$1" == "--inc" ]]; then
	inc_backlight
elif [[ "$1" == "--dec" ]]; then
	dec_backlight
else
	get_backlight
fi
