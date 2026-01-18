{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/common/base.nix
    ../../../modules/common/locale.nix
    ../../../modules/common/audio.nix
    ../../../modules/desktop/kde-plasma.nix
    ../../../modules/desktop/flatpak.nix
    ../../../modules/server/tailscale.nix
    ../../../modules/desktop/zsh.nix
    ../../../modules/common/development.nix
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

  # Fix dead keys for GTK apps (like Ghostty)
  environment.sessionVariables = {
    GTK_IM_MODULE = "simple";
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
    options = [ "guest" "nofail" "uid=1000" "gid=100" "file_mode=0664" "dir_mode=0775" ];
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Resende";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      calibre
      google-chrome
      keepassxc
      lutris
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    mpv
  ];

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "bruno";
    group = "users";
    dataDir = "/home/bruno";
    configDir = "/home/bruno/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
  };

    # Steam
  programs.steam = {
    enable = true;
  };

}

