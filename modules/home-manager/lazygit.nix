{ config, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
  };

  programs.zsh.shellAliases.lg = "lazygit";
}
