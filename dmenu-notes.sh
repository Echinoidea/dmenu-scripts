#!/usr/bin/env sh

# Create, manage, and search for notes using emacs deft

notes_dir="$HOME/org/deft"

result=$(echo -e "new\nopen\nsearch\ndeft\n" | dmenu -c -l 4 -i -p "notes:")

if [[ "${result}" = "new" ]]; then
    filename=$(echo "" | dmenu -c -p "enter note name (default: date):")
    if [ -z "$filename" ]; then
        filename=$(date "+%Y-%m-%d_%H-%M-%S").org
    else
        filename="$filename.org"
    fi
    emacsclient -r "$notes_dir/$filename"
fi

if [[ "$result" = "open" ]]; then
    search_term=$(echo "" | dmenu -c -p "search to open (leave empty for recent):")

    if [ -z "$search_term" ]; then
        # show recent files
        files=$(ls -1tu "$notes_dir")
        filename=$(echo "$files" | dmenu -c -l 16 -i -p "recent notes:")
    else
        # Search file contents
        matches=$(grep -l -i "$search_term" "$notes_dir"/* 2>/dev/null | xargs basename -a)
        if [ ! -z "$matches" ]; then
            filename=$(echo "$matches" | dmenu -c -l 16 -i -p "files containing '$search_term':")
        else
            notify-send "No matches found for: $search_term"
            exit 0
        fi
    fi

    if [ ! -z "$filename" ]; then
        emacsclient -r "$notes_dir/$filename"
    fi
fi

if [[ "$result" = "search" ]]; then
    search_term=$(echo "" | dmenu -c -p "search notes:")
    if [ ! -z "$search_term" ]; then
        emacsclient -r -e "(progn (deft) (deft-filter \"$search_term\" t))"
    fi
fi

if [[ "$result" = "deft" ]]; then
    emacsclient -r -e "(deft)"
fi
