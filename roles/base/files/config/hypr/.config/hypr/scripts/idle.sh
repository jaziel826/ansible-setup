#!/bin/sh
pkill swayidle

swayidle\
    timeout 150 '~/.config/sway/scripts/lock.sh --grace 10'\
    timeout 600 'systemctl suspend'\
    timeout 170 'hyprctl dispatch "dpms off"'\
    resume 'hyprctl dispatch "dpms on"' &\
    before-sleep '~/.config/hypr/scripts/lock.sh --fade-in 0'\
kill %%
