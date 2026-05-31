#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"

choice=$(printf 'Suspend\nShutdown\nUpdate System\nRebuild System' | fuzzel --dmenu --prompt="Power: ")

case "$choice" in
    Suspend) systemctl suspend ;;
    Shutdown) systemctl poweroff ;;
    "Update System") ghostty -e bash -c "cd $flake_dir && nix flake update; echo; echo 'Done. Press Enter to close.'; read" ;;
    "Rebuild System") ghostty -e bash -c "sudo nixos-rebuild switch --flake $flake_dir#$(hostname); echo; echo 'Done. Press Enter to close.'; read" ;;
esac
