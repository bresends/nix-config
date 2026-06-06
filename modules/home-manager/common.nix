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
    ./mpv.nix
    ./neovim.nix
    ./scripts.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
    ./satty.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    bibata-cursors
    kdePackages.dolphin
    kdePackages.kate
    keepassxc
    qview
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs-unstable.vicinae
    pkgs-unstable.obsidian
    hyprpicker
    playerctl
  ];

  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
