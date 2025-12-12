{ config, pkgs, ... }:

{
  imports = [
    ../common/zsh.nix
  ];

  programs.zsh = {
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell"; # Basic theme for servers
    };
    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };
}
