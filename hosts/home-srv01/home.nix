{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/tmux.nix
    ../../modules/home/git.nix
    ../../modules/home/direnv.nix
    ../../modules/home/starship.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    htop
    rsync
    unzip
    # Add your NAS-specific packages here
  ];

  programs.home-manager.enable = true;

  # Match the version from your other configurations
  home.stateVersion = "25.05";
}
