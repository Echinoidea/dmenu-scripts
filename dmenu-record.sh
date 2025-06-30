PID_FILE="$HOME/.cache/.ffmpeg_screen_recording_pid"

result=$(echo -e "eDP-1\nHDMI-1\nstop\n" | dmenu -l 8 -i -p "screen record:")

monitor_info=$(xrandr | grep -w connected)
geometry=""
offset=""

start_recording() {
  notify-send -t 3000 "recording started"
  ffmpeg -f x11grab -video_size "$geometry" -framerate 30 -i "$DISPLAY+$offset" \
    -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac "$filename" &
  echo $! > "$PID_FILE"
}

if [[ "${result}" = "stop" ]]; then
  if [ -f "$PID_FILE" ]; then
    ffmpeg_pid=$(cat "$PID_FILE")
    if kill "$ffmpeg_pid" 2>/dev/null; then
      echo "recording stopped."
      notify-send -t 3000 "recording stopped"
      rm "$PID_FILE"  # kill this ffmpeg
    else
      echo "failed to stop recording. check if ffmpeg is running."
    fi
  else
    echo "no recording is currently active."
  fi
else
  # input file name, automatically appends .mp4
  filename=$(echo "" | dmenu -p "enter file name (default: date):")
  
  # default filename: $(date).mp4
  if [ -z "$filename" ]; then
    filename=$(date "+%Y-%m-%d_%H-%M-%S").mp4
  else
    filename="$filename.mp4"
  fi

  if [[ "${result}" = "eDP-1" ]]; then
    geometry=$(echo "$monitor_info" | grep -w "eDP-1" | awk '{print $3}' | cut -d'+' -f1)
    offset=$(echo "$monitor_info" | grep -w "eDP-1" | awk '{print $3}' | cut -d'+' -f2,3)
    start_recording
  elif [[ "${result}" = "HDMI-1" ]]; then
    geometry=$(echo "$monitor_info" | grep -w "HDMI-1" | awk '{print $3}' | cut -d'+' -f1)
    offset=$(echo "$monitor_info" | grep -w "HDMI-1" | awk '{print $3}' | cut -d'+' -f2,3)
    start_recording
  fi
fi
