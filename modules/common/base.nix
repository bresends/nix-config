{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # System state version
  system.stateVersion = "25.05";
}
