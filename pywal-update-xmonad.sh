#!/usr/bin/env sh

xrdb -merge ~/.cache/wal/Xresources

killall -s SIGKILL polybar
killall -s SIGKILL launch.sh

wait

~/.config/polybar/launch-xmonad.sh

wait

killall pywal-update.sh
