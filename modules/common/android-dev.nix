{ config, pkgs, ... }:

{
  # Android development packages
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools  # Includes adb, fastboot, etc.
    flutter
    firebase-tools
  ];

  programs.adb.enable = true;

  users.users.bruno = {
    extraGroups = [ "adbusers" ];
  };
}
