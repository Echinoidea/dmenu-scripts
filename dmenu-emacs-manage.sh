#!/usr/bin/env sh

result=$(echo -e "start server\nrunning\nkill server\nkill clients" | dmenu -l 4 -i -p "manage emacs:")

if [ "${result}" = "start server" ]; then
    if pgrep -x "emacs" >/dev/null 2>&1; then
        notify-send -t 3000 "Emacs server is already running"
    else
        notify-send -t 3000 "Starting Emacs server"
        emacs --daemon
    fi
elif [ "${result}" = "kill server" ]; then
    killall emacs
elif [ "${result}" = "kill clients" ]; then
    killall emacsclient
elif [ "${result}" = "running" ]; then
    if pgrep -x "emacs" >/dev/null 2>&1; then
        notify-send -t 3000 "Emacs server is running"
    else
        notify-send -t 3000 "No Emacs server found"
    fi
fi
