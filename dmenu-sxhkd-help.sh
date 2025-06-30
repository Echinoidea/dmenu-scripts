#!/bin/sh

# This scrapes your sxhkdrc file and displays each keybind and the comment above it as the description

awk '/^[a-z]/ && last {print "",$0,"\t",last,""} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc |
    column -t -s $'\t' |
    dmenu -l 20 -i
