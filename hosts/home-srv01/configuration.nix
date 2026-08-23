{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/kde-plasma.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/no-sleep.nix
    ../../modules/nixos/samba.nix
    ../../modules/nixos/zsh.nix
  ];

  # Bootloader and state version are properties of this host, not shared
  # policy.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

  # This host still runs KDE, so retain its existing desktop defaults while
  # keeping them out of the shared server foundation.
  networking.networkmanager.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Hostname
  networking.hostName = "home-srv01";

  # Static IP configuration
  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.0.10";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "bruno";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyqjAM2C8L3YZFWD/hnrPLiPx6Et6U2f201vs8PdTPd bruno@home-nas"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Enable automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "bruno";

  # System packages
  environment.systemPackages = with pkgs; [
    mpv
  ];

  # Install firefox
  programs.firefox.enable = true;

  # Mount additional drive
  fileSystems."/mnt/tank" = {
    device = "/dev/disk/by-uuid/afa4df74-f0ef-479f-92e3-1f9314e153d5";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Samba configuration
  mySamba = {
    enable = true;
    shares = {
      "media" = {
        "path" = "/mnt/tank/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "bruno";
        "force group" = "users";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
    };
  };
}
