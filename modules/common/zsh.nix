{ config, pkgs, ... }:

{
  # ZSH configuration
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    fzf
  ];
}
