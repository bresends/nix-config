{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

  # Passwordless sudo for wheel users
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable Network Manager
  networking.networkmanager.enable = true;

  # Default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # System state version
  system.stateVersion = "25.05";
}
