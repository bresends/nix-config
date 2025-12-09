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
  ];

  # Hostname
  networking.hostName = "nixos";

  # Enable NetworkManager
  networking.networkmanager.enable = true;

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
      ghostty
      keepassxc
      starship
      gh
      fzf
      rsync
      stow
      google-chrome
      zoxide
      tmux
      lazygit
      python3
      nodejs
      claude-code
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    gcc
    unzip
    htop
    lutris
    mpv
  ];

  # SSH
  programs.ssh.startAgent = true;

  # ZSH configuration
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };

  # Starship
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
}
