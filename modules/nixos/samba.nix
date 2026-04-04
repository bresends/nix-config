{ config, lib, pkgs, ... }:

{
  options = {
    mySamba = {
      enable = lib.mkEnableOption "Samba file sharing";

      shares = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
        default = {};
        description = "Samba shares configuration";
      };
    };
  };

  config = lib.mkIf config.mySamba.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
      } // config.mySamba.shares;
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
