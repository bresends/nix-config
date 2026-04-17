{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # Bootloader — disko sets GRUB devices via the EF02 partition
  boot.loader.grub.enable = true;

  networking.hostName = "nixos";
  networking.interfaces.enp0s31f6.ipv4.addresses = [{
    address = "10.0.99.101";
    prefixLength = 24;
  }];

  # Timezone & Locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Users
  users.users.adminbm = {
    isNormalUser = true;
    description = "AdminBM";
    hashedPassword = "$6$2RcOy9WpfoK2wvWc$Jhf6hJjurxUc1SK7LohKr37KqOiSvmDCSiQ8S/qSehLP/2Z/iK2TbyQ0u2X5oxehAwENVas2fjO0W5crQPjYq0";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZDuRq5OFIzlLEk5jxwPj73WrXtls26vZ2NBmkij/8N bruno@nixos"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  # Passwordless sudo for Colmena deployments
  security.sudo.extraRules = [
    {
      users = [ "adminbm" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # Services
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Nix settings for Colmena deployments
  nix.settings.trusted-users = [ "root" "adminbm" ];

  system.stateVersion = "25.11";
}
