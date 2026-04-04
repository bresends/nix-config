{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "bruno";
    group = "users";
    dataDir = "/home/bruno";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
  };
}
