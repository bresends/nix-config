{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/common/base.nix
    ../../../modules/common/locale.nix
    ../../../modules/common/audio.nix
    ../../../modules/common/printing.nix
    ../../../modules/desktop/kde-plasma.nix
    ../../../modules/desktop/flatpak.nix
    ../../../modules/desktop/fcitx5.nix
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

  # Define user account
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Resende";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      keepassxc
      ghostty
      starship
      gh
      fzf
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
    htop
  ];

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

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
}
