{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/kde-plasma.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/no-sleep.nix
    ../../modules/nixos/onlyoffice.nix
  ];

  # Hostname
  networking.hostName = "nixos";

  # Static IP configuration
  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.99.160";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "10.0.99.1";
  networking.nameservers = [ "10.242.254.70" "10.242.254.71" ];

  # Locale configuration
  myLocale = {
    defaultLocale = "pt_BR.UTF-8";
    keyboardLayout = "br";
    keyboardVariant = "";
    consoleKeyMap = "br-abnt2";
  };

  # Define user account
  users.users.adminbm = {
    isNormalUser = true;
    description = "AdminBM";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    htop
  ];

  # Install firefox
  programs.firefox.enable = true;
}
