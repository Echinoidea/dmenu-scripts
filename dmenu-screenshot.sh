#!/bin/bash

result=$(echo -e "eDP-1\nHDMI-1" | dmenu -l 8 -i -p "screenshot:")

if [ -z "$result" ]; then
    exit 0
fi

take_screenshot() {
    local geometry="$1"
    local filename="$2"

    maim -g "$geometry" "$filename"

    if [ $? -eq 0 ]; then
        notify-send -t 3000 "Screenshot saved: $filename"
        echo "$filename"
    else
        notify-send -t 3000 "Screenshot failed"
        exit 1
    fi
}

# Get filename from user
filename=$(echo "" | dmenu -p "enter file name (default: date):")

# Default filename is date
if [ -z "$filename" ]; then
    filename=$(date "+%Y-%m-%d_%H-%M-%S").jpg
else
    filename="$filename.jpg"
fi

filename="$HOME/Pictures/screenshots/bspwm/$filename"

# Set geometry based on display
if [[ "${result}" = "eDP-1" ]]; then
    geometry="1920x1080+0+0"
    screenshot_path=$(take_screenshot "$geometry" "$filename")
elif [[ "${result}" = "HDMI-1" ]]; then
    geometry="1920x1080+1920+0" # HDMI-1 is to the right
    screenshot_path=$(take_screenshot "$geometry" "$filename")
fi
