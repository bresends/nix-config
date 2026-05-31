{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Monokai Pro";
      font-family = "JetBrainsMonoNL Nerd Font";
      background-opacity = 0.9;
      confirm-close-surface = false;
      app-notifications = "no-clipboard-copy";
      cursor-invert-fg-bg = true;
      keybind = "shift+enter=text:\\x1b\\r";
      shell-integration-features = "ssh-terminfo";
      window-padding-balance = true;
      window-padding-color = "extend";
      window-padding-x = 0;
      window-padding-y = 0;
      adjust-cell-height = -1;
    };
  };
}
