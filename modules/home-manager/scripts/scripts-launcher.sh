#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"

choice=$(fuzzel --dmenu --prompt="Run: " <<EOF
󰜉  Rebuild System
󰏗  Update System
  Garbage Collect
  Suspend
󰐥  Shutdown
EOF
)

case "$choice" in
    "  Suspend") systemctl suspend ;;
    "󰐥  Shutdown") systemctl poweroff ;;
    "  Garbage Collect")
        (
            if nix-collect-garbage -d; then
                notify-send -t 2000 "Nix GC" "Garbage collection complete!"
            else
                notify-send -t 2000 "Nix GC" "Garbage collection failed!" --urgency=critical
            fi
        ) & disown
        ;;
    "󰏗  Update System") 
        (
            notify-send -t 2000 "System Update" "Starting flake update in the background..."
            cd "$flake_dir"
            if nix flake update; then
                if git diff --quiet flake.lock; then
                    notify-send -t 2000 "System Update" "Flake inputs are already up to date!"
                else
                    git add flake.lock
                    if git commit -m "chore(system): update flake"; then
                        notify-send -t 2000 "System Update" "Flake update complete and committed!"
                    else
                        notify-send -t 2000 "System Update" "Flake updated, but git commit failed." --urgency=critical
                    fi
                fi
            else
                notify-send -t 2000 "System Update" "nix flake update failed!" --urgency=critical
            fi
        ) & disown
        ;;
    "󰜉  Rebuild System") ghostty -e bash -c "sudo nixos-rebuild switch --flake $flake_dir#\$(hostname); echo; echo 'Done. Press Enter to close.'; read" ;;
esac
