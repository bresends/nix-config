#!/usr/bin/env bash
set -euo pipefail

# Create screenshots directory in /tmp
DIR="/tmp/Screenshots"
mkdir -p "$DIR"

# Generate filename with date/time
FILENAME="${DIR}/screenshot-$(date '+%y-%d-%m-%H:%M').png"

# Select region and capture screenshot (exits if cancelled)
GEOMETRY=$(slurp) || exit 0
grim -g "$GEOMETRY" - | satty --filename - --output-filename "$FILENAME" --early-exit --initial-tool arrow || exit 0

# Copy path to clipboard if file was successfully created
[ -f "$FILENAME" ] && echo -n "$FILENAME" | wl-copy
