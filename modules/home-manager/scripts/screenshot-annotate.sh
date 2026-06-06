#!/usr/bin/env bash
set -euo pipefail

# Create screenshots directory in /tmp
DIR="/tmp/Screenshots"
mkdir -p "$DIR"

# Generate filename with date/time
FILENAME="${DIR}/screenshot-$(date '+%y-%d-%m-%H:%M').png"

# Clear clipboard so we don't pick up a stale image
wl-copy --clear

# Run Niri's interactive screenshot tool
niri msg action screenshot

# Wait for clipboard to populate with the screenshot (up to 30s)
for i in $(seq 1 60); do
  wl-paste --list-types 2>/dev/null | grep -q "image/png" && break
  sleep 0.5
done

# Check if clipboard has image data; exit early if not
wl-paste --list-types | grep -q "image/png" || exit 0

# Paste clipboard image into satty and save to /tmp/Screenshots (exit early if cancelled)
wl-paste --type image/png | satty --filename - --output-filename "$FILENAME" --early-exit --initial-tool arrow || exit 0

# Copy path to clipboard if file was successfully created
[ -f "$FILENAME" ] && echo -n "$FILENAME" | wl-copy
