{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/bruno";
    guiAddress = "127.0.0.1:8384";
  };
}
