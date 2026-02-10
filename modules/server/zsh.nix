{ config, pkgs, ... }:

{
  imports = [
    ../common/zsh.nix
  ];

  programs.zsh = {
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto -lh";
      lsa = "ls --color=auto -lah";
      lg = "lazygit";
      vim = "nvim";
    };

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
