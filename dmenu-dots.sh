#!/bin/sh

DIR="$HOME/.config"

declare -a options=(
  "sxhkd - $DIR/sxhkd/sxhkdrc"
  "bspwm - $DIR/bspwm/bspwmrc"
  "polybar - $DIR/polybar/config.ini"
  "doomemacs - $DIR/doom/config.ini"
  "picom - $DIR/picom/picom.conf"
  "fish - $DIR/fish/config.fish"
  "dunst - $DIR/dunst/dunstrc"
  "quit"
)

choice=$(printf '%s\n' "${options[@]}" | dmenu -i -l 7 -p "edit config:")

if [[ "$choice" == "quit" ]]; then
  echo "terminated" && exit 1
elif [ -n "$choice" ]; then
  cfg=$(echo "${choice}" | awk -F ' - ' '{print $2}')
  # $EDITOR "$cfg"
  # alacritty -e nvim "$cfg"
  emacsclient -a '' -c "$cfg"
else
  echo "terminated" && exit 1
fi
