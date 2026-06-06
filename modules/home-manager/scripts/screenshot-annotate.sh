#!/usr/bin/env bash
set -euo pipefail

# Create screenshots directory in /tmp
DIR="/tmp/Screenshots"
mkdir -p "$DIR"

# Generate filename with date/time
FILENAME="${DIR}/screenshot-$(date '+%y-%d-%m-%H:%M').png"

# Run Niri's interactive screenshot tool
niri msg action screenshot

# Wait for clipboard to populate
sleep 0.5

# Check if clipboard has image data; exit early if not
wl-paste --list-types | grep -q "image/png" || exit 0

# Paste clipboard image into satty and save to /tmp/Screenshots (exit early if cancelled)
wl-paste --type image/png | satty --filename - --output-filename "$FILENAME" --early-exit --initial-tool arrow || exit 0

# Copy path to clipboard if file was successfully created
[ -f "$FILENAME" ] && echo -n "$FILENAME" | wl-copy
