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
    ./tmux.nix
    ./zsh.nix
  ];

  home.username = "bruno";
  home.homeDirectory = "/home/bruno";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    kdePackages.kate
    keepassxc
    mpv
    inputs.helium.packages.${pkgs.system}.default
    pkgs-unstable.obsidian
  ];

  home.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
