#!/bin/sh

# List available sinks with their IDs and descriptions, including all soundcards
SINKS=$(pactl list short sinks | awk '{print $1 " : " $2}')

# Get the ID of the currently active (default) sink
CURRENT_SINK_NAME=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Find the description of the current sink
CURRENT_SINK_DESC=$(pactl list sinks short | grep "$CURRENT_SINK_NAME" | awk '{print $2}')

# Prepend the current sink to the list
SINKS=$(echo -e "Current: $CURRENT_SINK_DESC\n$SINKS")

# Use dmenu to select the new sink
CHOSEN_LINE=$(echo "$SINKS" | dmenu -l 10 -p "Select Audio Output:")

# Extract the chosen sink's ID
CHOSEN_SINK=$(echo "$CHOSEN_LINE" | awk '{print $1}')

# If the user made a selection, change the default sink
if [ -n "$CHOSEN_SINK" ] && [ "$CHOSEN_SINK" != "Current:" ]; then
    pactl set-default-sink "$CHOSEN_SINK"
    # Move all currently playing audio streams to the new sink
    pactl list short sink-inputs | while read -r stream; do
        STREAM_ID=$(echo "$stream" | awk '{print $1}')
        pactl move-sink-input "$STREAM_ID" "$CHOSEN_SINK"
    done
fi
