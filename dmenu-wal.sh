#!/bin/sh

# dmenu script for pywal which lets you select a wallpaper or a pywal defined theme. Based on BreadOnPenguin's pywal dmenu script

FOLDER=~/Pictures/wallpapers
SCRIPT=/home/gabriel/dmenu-scripts/pywal-update.sh # pywal post-run script

menu() {
    # find image files recursively and ignore hidden directories
    CHOICES=$(echo -e "random\ntheme\n$(find "$FOLDER" -type f -regex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\|tif\|tiff\)$' -printf '%P\n' | sort -V)")

    CHOICE=$(echo "$CHOICES" | dmenu -l 20 -i -p "pywal:")

    case $CHOICE in
    random)
        FILES=$(find "$FOLDER" -type f -regex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\|tif\|tiff\)$')
        RANDOM_FILE=$(printf '%s\n' "$FILES" | shuf -n 1)
        wal -i "$RANDOM_FILE" -e
        killall dunst
        $SCRIPT
        dunst
        notify-send -t 3000 "pywal $(dirname "$RANDOM_FILE" | xargs basename)/$(basename "$RANDOM_FILE")"
        ;;
    theme) select_theme ;;
    *.*)
        wal -i "$FOLDER/$CHOICE"
        $SCRIPT
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
