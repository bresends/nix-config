{ config, pkgs, ... }:

{
  # Fonts for OnlyOffice
  fonts.packages = with pkgs; [
    corefonts
  ];

  # OnlyOffice Desktop Editors
  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
  ];
}
