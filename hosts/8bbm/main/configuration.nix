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
  ];

  # Hostname
  networking.hostName = "nixos";

  # Static IP configuration
  networking.interfaces.enp0s31f6 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.99.160";
      prefixLength = 24;
    }];
   ipv4.routes = [{
     address = "0.0.0.0";
     prefixLength = 0;
     via = "10.0.99.1";
   }];
  };

  networking.nameservers = [ "10.242.254.70" "10.242.254.71" "1.1.1.1" "8.8.8.8" ];

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

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$fsjTRv2WFb3PuQy5Dg8850$X5eEEg8ROFA5Uf1lZxgzhjrHyduTRtwWRHpnEHgYh58";
    description = "Bruno Resende";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      stow
      google-chrome
      keepassxc
      ghostty
      gh
      fzf
      rsync
      zoxide
      tmux
      lazygit
      python3
      nodejs
      claude-code
      gemini-cli
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    gcc
    unzip
    git
    htop
  ];

  # SSH
  programs.ssh.startAgent = true;

  # Install Starship
  programs.starship.enable = true;

    # Git
  programs.git = {
    enable = true;
    config = {
      user.name = "Bruno Resende";
      user.email = "bruno.resende@gmx.com";
      init.defaultBranch = "main";
    };
  };

  # Neovim
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

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
