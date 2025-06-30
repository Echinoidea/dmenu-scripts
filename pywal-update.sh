#!/bin/sh

xrdb -merge ~/.cache/wal/Xresources

killall -s SIGKILL polybar
killall -s SIGKILL launch.sh 

wait

~/.config/polybar/launch.sh 

wait

killall sxhkd 
killall sxhkd-listener

~/.config/sxhkd/scripts/sxhkd-start &
~/.config/sxhkd/scripts/sxhkd-listener &

killall pywal-update.sh
