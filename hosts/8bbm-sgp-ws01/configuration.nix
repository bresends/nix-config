{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/niri-desktop.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/fcitx5.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/onlyoffice.nix
    ../../modules/nixos/zsh.nix
  ];

  # Hostname
  networking.hostName = "8bbm-sgp-ws01";

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
  };

  # Fix cedilla for Brazilian keyboard users
  i18n.extraLocaleSettings = {
    LC_CTYPE = "pt_BR.UTF-8";
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Resende";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      obsidian
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    mpv
  ];

  # Steam
  programs.steam = {
    enable = true;
  };

}
