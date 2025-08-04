#!/bin/sh

# dmenu script for pywal which lets you select a wallpaper or a pywal defined theme. Based on BreadOnPenguin's pywal dmenu script

FOLDER=~/Pictures/wallpapers
SCRIPT_BSPWM=/home/gabriel/dmenu-scripts/pywal-update.sh         # pywal post-run script
SCRIPT_XMONAD=/home/gabriel/dmenu-scripts/pywal-update-xmonad.sh # pywal post-run script

WM_NAME=$(wmctrl -m | awk -F: '/Name/ {print tolower($2)}' | xargs)

case "$WM_NAME" in
bspwm)
    SCRIPT="$SCRIPT_BSPWM"
    ;;
xmonad)
    SCRIPT="$SCRIPT_XMONAD"
    ;;
*)
    echo "Unknown window manager: $WM_NAME"
    SCRIPT=""
    ;;
esac

menu() {
    # find image files recursively and ignore hidden directories
    CHOICES=$(echo -e "random\ntheme\n$(find "$FOLDER" -type f -regex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\|tif\|tiff\)$' -printf '%P\n' | sort -V)")

    CHOICE=$(echo "$CHOICES" | dmenu -l 20 -i -p "pywal:")

    case $CHOICE in
    random)
        FILES=$(find "$FOLDER" -type f -regex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\|tif\|tiff\)$')
        RANDOM_FILE=$(printf '%s\n' "$FILES" | shuf -n 1)
        wal -i "$RANDOM_FILE" -e -n
        feh --bg-fill "$RANDOM_FILE"
        killall dunst
        $SCRIPT_BSPWM
        dunst
        notify-send -t 3000 "pywal $(dirname "$RANDOM_FILE" | xargs basename)/$(basename "$RANDOM_FILE")"
        ;;
    theme) select_theme ;;
    *.*)
        wal -i "$FOLDER/$CHOICE" -n -e
        feh --bg-fill "$FOLDER/$CHOICE"
        $SCRIPT_BSPWM
        ;;
    *) exit 0 ;;
    esac

}

select_theme() {
    THEMES=$(wal --theme -e -o ~/.config/dunst/launch.sh | grep -E '^ - [^()]*' | awk '{print $2}' | sed 's/[[:space:]].*//')

    THEME_CHOICE=$(echo "$THEMES" | dmenu -l 20 -i -p "theme:")

    if [ -n "$THEME_CHOICE" ]; then
        wal --theme "$THEME_CHOICE" -o "$SCRIPT"
    fi
}

case "$#" in
0) menu ;;
1) wal -i "$1" ;;
2) wal -i "$1" --theme "$2" ;;
*) exit 0 ;;
esac
