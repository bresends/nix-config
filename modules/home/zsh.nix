{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto -lh";
      lsa = "ls --color=auto -lah";
      ll = "ls -l";
      lg = "lazygit";
      vim = "nvim";
      tmux = "tmux attach 2>/dev/null || tmux";
    };

    history.ignoreDups = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };

    initContent = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # SSH hostname completion from ~/.ssh/config
      complete -o default -o nospace -W "$(grep "^Host" $HOME/.ssh/config | cut -d" " -f2)" scp sftp ssh rsync
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
