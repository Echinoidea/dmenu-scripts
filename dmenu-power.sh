#!/bin/sh

result=$(echo -e "sleep\nsuspend\nreboot\npower off" | dmenu -l 4 -i -p "system:")

if [ "${result}" = "power off" ]; then
  systemctl poweroff -i
elif [ "${result}" = "sleep" ]; then
  systemctl sleep
elif [ "${result}" = "suspend" ]; then
  systemctl suspend
elif [ "${result}" = "reboot" ]; then
  systemctl reboot
fi
