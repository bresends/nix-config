{ config, pkgs, ... }:

{
  imports = [
    ../../common/zsh.nix
  ];

  # ZSH configuration
  # The common/zsh.nix already enables zsh and sets defaultUserShell
  programs.zsh = {
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "agnoster"; # Added agnoster theme as requested for desktops
    };

    interactiveShellInit = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };
}
