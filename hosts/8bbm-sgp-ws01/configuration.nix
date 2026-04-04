{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/kde-plasma.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/fcitx5.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/onlyoffice.nix
  ];

  # Hostname
  networking.hostName = "nixos";

  # Static IP configuration
  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.0.99.22";
        prefixLength = 24;
      }
    ];
    ipv4.routes = [
      {
        address = "0.0.0.0";
        prefixLength = 0;
        via = "10.0.99.1";
      }
    ];
  };

  networking.nameservers = [
    "10.242.254.70"
    "10.242.254.71"
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
    keyboardLayout = "us";
    keyboardVariant = "intl";
    consoleKeyMap = "us-acentos";
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
