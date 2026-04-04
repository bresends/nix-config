{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/bruno";
    configDir = "/home/bruno/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };
}
