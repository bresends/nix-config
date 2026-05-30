{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home-manager/development.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/lazygit.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  programs.tmux.prefix = "C-b";

  programs.home-manager.enable = true;

  # Match the version from your other configurations
  home.stateVersion = "25.05";
}
