{ config, pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
