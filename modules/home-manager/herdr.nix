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
    onboarding = false

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
    navigate_workspace_up = "ctrl+p"
    navigate_workspace_down = "ctrl+n"

    [[keys.command]]
    key = "prefix+alt+g"
    type = "popup"
    command = "lazygit"
    description = "run lazygit"
    width = "80%"
    height = "80%"

    [[keys.command]]
    key = "prefix+t"
    type = "popup"
    command = "exec \"''${SHELL:-sh}\""
    description = "open scratch terminal"
    width = "80%"
    height = "80%"
  '';
}
