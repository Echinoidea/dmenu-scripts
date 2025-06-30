#!/bin/sh

result=$(echo -e "toggle\nnext\nprev\nstart\nkill\nshuffle\nstop\nnotify" | dmenu -l 8 -i)

if [[ "${result}" = "start" ]]; then
  mpd
elif [[ "${result}" = "kill" ]]; then
  mpd --kill
elif [[ "${result}" = "toggle" ]]; then
  mpc toggle
elif [[ "${result}" = "next" ]]; then
  mpc next
elif [[ "${result}" = "prev" ]]; then
  mpc prev
elif [[ "${result}" = "shuffle" ]]; then
  mpc random 
elif [[ "${result}" = "notify" ]]; then
  notification=$(mpc current)
  notify-send -t 3000 "$notification"
fi
