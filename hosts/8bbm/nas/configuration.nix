{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/common/base.nix
    ../../../modules/common/locale.nix
    ../../../modules/server/ssh.nix
    ../../../modules/server/docker.nix
    ../../../modules/server/tailscale.nix
    ../../../modules/server/no-sleep.nix
    ../../../modules/server/samba.nix
  ];

  # Hostname
  networking.hostName = "servidor-1";

  # Static IP configuration
  networking.interfaces.enp0s25 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.99.25";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "10.0.99.1";
  networking.nameservers = [ "10.242.254.70" "10.242.254.71" ];

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
    keyboardLayout = "us";
    keyboardVariant = "intl";
    consoleKeyMap = "us-acentos";
  };

  # Define user account
  users.users.adminbm = {
    isNormalUser = true;
    description = "adminbm";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      rsync
      neovim
      gh
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    mpv
    htop
  ];

  fileSystems."/mnt/tank" = {
    device = "/dev/disk/by-uuid/1f0f3d0b-2ddc-416e-a285-e9807ea11a67";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Samba configuration
  mySamba = {
    enable = true;
    shares = {
      "media" = {
        "path" = "/mnt/tank/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mode" = "0777";
        "directory mode" = "0777";
      };
    };
  };
}
