{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/kde-plasma.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/syncthing.nix
    ../../modules/nixos/development.nix
    ../../modules/nixos/android-dev.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/onlyoffice.nix
  ];

  # Hostname
  networking.hostName = "nixos";

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

  # Mount additional drive
  fileSystems."/mnt/barracuda" = {
    device = "/dev/disk/by-uuid/35991c62-0cd9-4a34-9e38-aa46f153288f";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Mount NAS Samba share
  fileSystems."/mnt/nas" = {
    device = "//192.168.0.10/media";
    fsType = "cifs";
    options = [
      "guest"
      "nofail"
      "uid=1000"
      "gid=100"
      "file_mode=0664"
      "dir_mode=0775"
    ];
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Resende";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
    ];
    packages = with pkgs; [
      calibre
      lutris
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
