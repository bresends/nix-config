#!/usr/bin/env bash
set -euo pipefail

# List of bookmarks (Format: Name | URL)
bookmarks_data=$(cat <<EOF
Gmail | https://mail.google.com
Google Calendar | https://calendar.google.com
Bastter System | https://bastter.com/bs2
FMHY Audio Ripping | https://fmhy.net/audio#audio-ripping
Sonarr | http://sonarr.local.cbmgo.org
Radarr | http://radarr.local.cbmgo.org
Lidarr | http://lidarr.local.cbmgo.org
Bazarr | http://bazarr.local.cbmgo.org
qBittorrent | http://qbittorrent.local.cbmgo.org
EOF
)

# Show menu
selected=$(echo "$bookmarks_data" | vicinae dmenu --placeholder "Go to ")

if [ -n "$selected" ]; then
    url="${selected##* | }"
    xdg-open "$url"
fi
