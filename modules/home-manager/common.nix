{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    ./development.nix
    ./direnv.nix
    ./ghostty.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    bibata-cursors
    kdePackages.dolphin
    kdePackages.kate
    keepassxc
    mpv
    qview
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs-unstable.obsidian
    hyprpicker
    playerctl
  ];

  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
