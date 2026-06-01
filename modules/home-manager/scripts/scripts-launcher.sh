#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"

choice=$(fuzzel --dmenu --prompt="Run: " <<EOF
󰏗  Update System
󰜉  Rebuild System
󰤄  Suspend
󰐥  Shutdown
EOF
)

case "$choice" in
    "󰤄  Suspend") systemctl suspend ;;
    "󰐥  Shutdown") systemctl poweroff ;;
    "󰏗  Update System") 
        (
            notify-send "System Update" "Starting flake update in the background..."
            cd "$flake_dir"
            if nix flake update; then
                git add flake.lock
                if git commit -m "chore(system): update flake"; then
                    notify-send "System Update" "Flake update complete and committed!"
                else
                    notify-send "System Update" "Flake updated, but git commit failed." --urgency=critical
                fi
            else
                notify-send "System Update" "nix flake update failed!" --urgency=critical
            fi
        ) & disown
        ;;
    "󰜉  Rebuild System") ghostty -e bash -c "sudo nixos-rebuild switch --flake $flake_dir#\$(hostname); echo; echo 'Done. Press Enter to close.'; read" ;;
esac
