#!/usr/bin/env sh

# Open books in your Documents/books directory with Zathura

BOOKS_DIR=~/Documents/books

BOOKS=$(find "$BOOKS_DIR" -maxdepth 1 -type f \( -name "*.pdf" -o -name "*.epub" \) -exec basename {} \;)

SELECTED_BOOK=$(echo "$BOOKS" | dmenu -l 15 -p "zathura:")

if [ -n "$SELECTED_BOOK" ]; then
    zathura "$BOOKS_DIR/$SELECTED_BOOK"
fi
