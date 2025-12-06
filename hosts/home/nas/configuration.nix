{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/common/base.nix
    ../../../modules/common/locale.nix
    ../../../modules/common/audio.nix
    ../../../modules/desktop/kde-plasma.nix
    ../../../modules/server/ssh.nix
    ../../../modules/server/docker.nix
    ../../../modules/server/tailscale.nix
    ../../../modules/server/no-sleep.nix
    ../../../modules/server/samba.nix
  ];

  # Hostname
  networking.hostName = "nixos";

  # Static IP configuration
  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.0.10";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Open firewall port for Syncthing web GUI
  networking.firewall.allowedTCPPorts = [ 8384 ];

  # Locale configuration
  myLocale = {
    defaultLocale = "en_US.UTF-8";
    keyboardLayout = "us";
    keyboardVariant = "intl";
    consoleKeyMap = "us-acentos";
  };

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "bruno";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
      rsync
      neovim
      gh
    ];
  };

  # Enable automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "bruno";

  # System packages
  environment.systemPackages = with pkgs; [
    git
    mpv
    htop
  ];

  # Install firefox
  programs.firefox.enable = true;

  # Mount additional drive
  fileSystems."/mnt/tank" = {
    device = "/dev/disk/by-uuid/afa4df74-f0ef-479f-92e3-1f9314e153d5";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "bruno";
    group = "users";
    dataDir = "/home/bruno";
    configDir = "/home/bruno/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
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
        "create mode" = "0777";
        "directory mode" = "0777";
      };
    };
  };
}
