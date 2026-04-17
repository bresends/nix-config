{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "8bbm-sgp-ws02";
  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.99.160";
      prefixLength = 24;
    }];
  };

  # Timezone & Locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
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
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # Desktop Environment
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Disable sleep
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # Fonts & OnlyOffice
  fonts.packages = with pkgs; [ corefonts ];
  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
    mpv
    p7zip
    unrar
    google-chrome
  ];

  # Users
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  users.users.adminbm = {
    isNormalUser = true;
    description = "AdminBM";
    hashedPassword = "$6$2RcOy9WpfoK2wvWc$Jhf6hJjurxUc1SK7LohKr37KqOiSvmDCSiQ8S/qSehLP/2Z/iK2TbyQ0u2X5oxehAwENVas2fjO0W5crQPjYq0";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZDuRq5OFIzlLEk5jxwPj73WrXtls26vZ2NBmkij/8N bruno@nixos"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "adminbm" ];

  # Passwordless sudo for Colmena
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

  system.stateVersion = "25.05";
}
