#!/bin/sh
pkill swayidle

swayidle\
    timeout 150 '~/.config/sway/scripts/lock.sh --grace 10'\
    timeout 170 'swaymsg "output * dpms off"'\
    resume 'swaymsg "output * dpms on"' &\
    before-sleep '~/.config/sway/scripts/lock.sh --fade-in 0'\
kill %%
