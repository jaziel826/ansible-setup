#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 30; done

# Launch bar1 and bar2
if [ "$1" == "light" ]
then
	#polybar -c $HOME/.config/polybar/light-config nord-top &
	#polybar -c $HOME/.config/polybar/light-config nord-down &
	sleep 10
else
	polybar -c $HOME/.config/polybar/dark-config nord-top &
	#polybar -c $HOME/.config/polybar/dark-config nord-down &
	notify-send --icon=/home/jaziel/.local/share/icons/Zafiro-Icons-Dark-Blue-f/status/22/dialog-warning.svg -a Polybar "Polybar Initialized..."

fi

