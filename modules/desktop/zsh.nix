{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    fzf
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto -lh";
      lsa = "ls --color=auto -lah";
      ll = "ls -l";
      lg = "lazygit";
      vim = "nvim";
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
