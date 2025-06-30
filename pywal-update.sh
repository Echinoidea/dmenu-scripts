#!/bin/sh
xrdb -merge ~/.cache/wal/Xresources

killall polybar

~/.config/polybar/launch.sh

wait

killall sxhkd 
killall sxhkd-listener

~/.config/sxhkd/scripts/sxhkd-start &
~/.config/sxhkd/scripts/sxhkd-listener &
