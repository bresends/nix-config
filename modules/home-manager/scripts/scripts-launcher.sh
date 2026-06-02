#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"
notion_music_url="https://app.notion.com/p/brunoresende/Ouvir-a2223b1a75104c56a2bb88f1c94edc45"
youtube_music_url="https://music.youtube.com"

open_music_workspace() {
    niri msg action focus-workspace 2
    niri msg action spawn -- helium --new-window "$notion_music_url"
    niri msg action spawn -- helium --new-window "$youtube_music_url"
}

choice=$(vicinae dmenu --placeholder "Select Action" <<EOF
󰎈  Music
󰜉  Rebuild System
󰏗  Update System
  Garbage Collect
  Suspend
󰐥  Shutdown
EOF
)

case "$choice" in
    "󰎈  Music") open_music_workspace ;;
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
