{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Bruno Resende";
    userEmail = "bruno.resendesantos45@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
