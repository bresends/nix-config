{ config, pkgs, ... }:

{
  imports = [
    ../../common/zsh.nix
  ];

  programs.zsh = {
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell"; # Basic theme for servers
    };
  };
}
