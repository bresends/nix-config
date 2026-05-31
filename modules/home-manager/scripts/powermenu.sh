#!/usr/bin/env bash
set -euo pipefail

flake_dir="${HOME}/dev/nix-config"

choice=$(fuzzel --dmenu --prompt="Power: " <<EOF
󰏗  NixOS - Update System
󰜉  NixOS - Rebuild System
󰤄  Suspend
󰐥  Shutdown
EOF
)

case "$choice" in
    "󰤄  Suspend") systemctl suspend ;;
    "󰐥  Shutdown") systemctl poweroff ;;
    "󰏗  NixOS - Update System") ghostty -e bash -c "cd $flake_dir && nix flake update; echo; echo 'Done. Press Enter to close.'; read" ;;
    "󰜉  NixOS - Rebuild System") ghostty -e bash -c "sudo nixos-rebuild switch --flake $flake_dir#$(hostname); echo; echo 'Done. Press Enter to close.'; read" ;;
esac
