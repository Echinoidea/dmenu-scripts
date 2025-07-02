#!/bin/bash

# Launch other dmenu scripts with dmenu, like Emacs M-x menu

SCRIPTS_DIR=~/dmenu-scripts

SCRIPTS=$(find "$SCRIPTS_DIR" -maxdepth 1 -name "*.sh" -exec basename {} .sh \;)

SELECTED_SCRIPT=$(echo "$SCRIPTS" | dmenu -l 10 -p "M-x:")

if [ -n "$SELECTED_SCRIPT" ]; then
    bash "$SCRIPTS_DIR/$SELECTED_SCRIPT.sh"
fi
