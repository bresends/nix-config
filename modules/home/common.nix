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
    ./git.nix
    ./lazygit.nix
    ./neovim.nix
    ./starship.nix
    ./syncthing.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  home.packages = with pkgs; [
    kdePackages.kate
    google-chrome
    keepassxc
    mpv
    obsidian
  ];

  home.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
