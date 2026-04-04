{ config, pkgs, ... }:

{
  # Input method for dead keys support
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-with-addons
      fcitx5-m17n
    ];
  };
}
