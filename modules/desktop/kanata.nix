{ config, lib, pkgs, ... }:

{
  hardware.uinput.enable = true;

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    DynamicUser = lib.mkForce false;
    SupplementaryGroups = [ "input" "uinput" ];
    DeviceAllow = [ "/dev/uinput rw" "char-input r" ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [ ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps
          )
          (defalias
           caps (tap-hold 200 200 esc lctl)
          )
          (deflayer base
           @caps
          )
        '';
      };
    };
  };
}
