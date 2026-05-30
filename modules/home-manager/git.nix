{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Bruno Resende";
      user.email = "bruno.resendesantos45@gmail.com";
      init.defaultBranch = "main";
    };
  };
}
