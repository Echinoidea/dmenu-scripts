#!/bin/sh

FOLDER="$HOME/Videos/"

openvid () { \
  NAME="$(echo "$(command ls $FOLDER)" | dmenu -c -l 15 -p "mpv:")" || exit 0
  mpv "$FOLDER$NAME" >/dev/null 2>&1
}

openvid
