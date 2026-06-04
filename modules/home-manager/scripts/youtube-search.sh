#!/usr/bin/env bash
set -euo pipefail

# Prompt the user for a search query using vicinae dmenu
query=$(vicinae dmenu --placeholder "Search YouTube")

# If a query was entered, encode it and open it in the default browser
if [ -n "$query" ]; then
    encoded_query=$(echo -n "$query" | jq -sRr @uri)
    xdg-open "https://www.youtube.com/results?search_query=${encoded_query}"
fi
