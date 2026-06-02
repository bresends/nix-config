#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"

choice=$(vicinae dmenu --placeholder "Select Action" <<EOF
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
            notify-send -t 2000 "Nix GC" "Starting garbage collection..."
            if nix-collect-garbage -d; then
                notify-send -t 2000 "Nix GC" "Garbage collection complete!"
            else
                notify-send -t 2000 "Nix GC" "Garbage collection failed!" --urgency=critical
            fi
        ) & disown
        ;;
    "󰏗  Update System") 
        (
            notify-send -t 2000 "System Update" "Starting flake and flatpak updates..."
            
            flatpak_success=true
            if ! flatpak update -y; then
                flatpak_success=false
                notify-send -t 2000 "System Update" "Flatpak update failed!" --urgency=critical
            fi

            cd "$flake_dir"
            if nix flake update; then
                if git diff --quiet flake.lock; then
                    if [ "$flatpak_success" = true ]; then
                        notify-send -t 2000 "System Update" "All updates complete! (Flake inputs were already up to date)"
                    fi
                else
                    git add flake.lock
                    if git commit -m "chore(system): update flake"; then
                        notify-send -t 2000 "System Update" "System updates complete and committed!"
                    else
                        notify-send -t 2000 "System Update" "Flake updated, but git commit failed." --urgency=critical
                    fi
                fi
            else
                notify-send -t 2000 "System Update" "nix flake update failed!" --urgency=critical
            fi
        ) & disown
        ;;
    "󰜉  Rebuild System") ghostty -e bash -c "if sudo nixos-rebuild switch --flake $flake_dir#\$(hostname); then notify-send -t 3000 'NixOS Rebuild' 'Rebuild and switch successful!'; else notify-send -t 3000 'NixOS Rebuild' 'Rebuild failed!' --urgency=critical; fi; echo; echo 'Done. Press Enter to close.'; read" ;;
esac
