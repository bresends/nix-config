{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."herdr/config.toml".text = ''
    [theme]
    name = "terminal"

    [theme.custom]
    panel_bg = "#2d2a2e"
    accent = "#ffd866"
    green = "#a9dc76"
    blue = "#78dce8"
    red = "#ff6188"
    yellow = "#ffd866"

    [keys]
    prefix = "ctrl+space"
  '';
}
