{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
