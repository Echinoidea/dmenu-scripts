#!/usr/bin/env sh

result=$(echo -e "new\nopen\n" | dmenu -c -l 8 -i -p "notes:")

if [[ "${result}" = "new" ]]; then
    filename=$(echo "" | dmenu -c -p "enter note name (default: date):")
    if [ -z "$filename" ]; then
        filename=$(date "+%Y-%m-%d_%H-%M-%S").org
    else
        filename="$filename.org"
    fi

    emacsclient -r "$HOME/org/notes/$filename"
fi

if [[ "$result" = "open" ]]; then
    files=$(ls -1tu "$HOME/org/notes")
    # TODO Make ls sort by accessed, for some reason

    filename=$(echo "$files" | dmenu -c -l 16 -i -p "open note:")
    if [ -z "$filename" ]; then
        exit 0
    fi
    emacsclient -r "$HOME/org/notes/$filename"
fi
