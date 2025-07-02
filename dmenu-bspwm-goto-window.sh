#!/bin/sh

# Original: https://gist.github.com/janx/d08fbc1006f7183b14a4

window_list=$(wmctrl -l)

echo "$window_list" | awk '{$1=$2=$3=""; print substr($0, 4)}' > /tmp/dmenu_goto_windows

selected=$(dmenu -i -l 10 -p "goto window:" < /tmp/dmenu_goto_windows)

win_line=$(echo "$window_list" | grep -F "$selected")
win_id=$(echo "$win_line" | awk '{print $1}')

if [ -n "$win_id" ]; then
  bspc node -f "$win_id"
fi
