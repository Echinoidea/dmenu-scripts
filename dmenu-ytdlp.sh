#!/usr/bin/env sh
prompt=$(echo -e "album\nsplit\n" | dmenu -c -l 2 -p "ytdlp - video form:")

if [[ -z "$prompt" ]]; then
    exit 0
fi

if [[ "$prompt" = "album" ]]; then
    url=$(echo "" | dmenu -c -p "url: <C-S-y>")
    if [[ -z "$url" ]]; then
        exit 0
    fi

    directory=$(echo "" | dmenu -c -p "directory:")
    if [[ -z "$directory" ]]; then
        exit 0
    fi

    artist=$(echo "" | dmenu -c -p "artist name:")
    if [[ -z "$artist" ]]; then
        exit 0
    fi

    album=$(echo "" | dmenu -c -p "album name:")
    if [[ -z "$album" ]]; then
        exit 0
    fi

    mkdir -p "$directory"

    notify-send "yt-dlp started" "Downloading $artist - $album"

    if yt-dlp -f "bestaudio[ext=m4a]/bestaudio/best" \
        --extract-audio \
        --audio-format mp3 \
        --embed-thumbnail \
        --add-metadata \
        --metadata-from-title "%(title)s" \
        --postprocessor-args "ffmpeg:-metadata album='$album' -metadata artist='$artist'" \
        -o "$HOME/Music/$directory/%(title)s.%(ext)s" \
        "$url"; then
        notify-send "yt-dlp finished" "Download completed successfully"
    else
        notify-send "yt-dlp failed" "Download failed - check your URL and connection"
    fi
fi
