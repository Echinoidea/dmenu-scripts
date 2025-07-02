#!/bin/bash

# Fetch the list of projects from projectile
projects=$(emacsclient -e '(mapcar (lambda (dir) (abbreviate-file-name dir)) (projectile-relevant-known-projects))' | tr -d '()\"\n')

# Use dmenu to select a project
selected_project=$(echo "$projects" | tr ' ' '\n' | dmenu -l 10 -i -p "open project:")

# Check if there's an existing emacs frame
existing_frame=$(emacsclient -e '(>= (length (frame-list)) 2)' 2>/dev/null)

# Switch to the selected project
if [ -n "$selected_project" ]; then
    if [ "$existing_frame" == "t" ]; then
        # an existing client frame is available
        emacsclient -e "(progn (counsel-projectile-switch-project-by-name \"$selected_project\") (switch-to-buffer (window-buffer (selected-window))))"
    elif [ -n "$DISPLAY" ]; then
        # no frame, create a graphical frame
        emacsclient -c -e "(progn (counsel-projectile-switch-project-by-name \"$selected_project\") (switch-to-buffer (window-buffer (selected-window))))"
    else
        # no frame and running in terminal, open terminal mode
        emacsclient -t -e "(progn (projectile-switch-project-by-name \"$selected_project\") (dired \"$selected_project\") (switch-to-buffer (window-buffer (selected-window))))"
    fi
fi
