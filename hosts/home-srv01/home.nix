{ ... }:

{
  imports = [
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/neovim.nix
    ../../modules/home-manager/starship.nix
    ../../modules/home-manager/zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Match the version from your other configurations
  home.stateVersion = "26.05";
}
