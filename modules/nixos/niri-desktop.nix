{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.displayManager.ly = {
    enable = true;
    x11Support = false;
  };
  security.pam.services.ly.enableGnomeKeyring = true;

  xdg.portal.xdgOpenUsePortal = true;

  home-manager.users.bruno.imports = [
    inputs.noctalia.homeModules.default
    ../../modules/home-manager/niri.nix
    ../../modules/home-manager/noctalia.nix
  ];
}
