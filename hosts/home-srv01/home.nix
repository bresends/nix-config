{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home/development.nix
    ../../modules/home/direnv.nix
    ../../modules/home/git.nix
    ../../modules/home/lazygit.nix
    ../../modules/home/neovim.nix
    ../../modules/home/starship.nix
    ../../modules/home/tmux.nix
    ../../modules/home/zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Match the version from your other configurations
  home.stateVersion = "25.05";
}
