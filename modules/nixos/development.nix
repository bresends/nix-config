{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    unzip
    htop
  ];

  programs.ssh.startAgent = true;
}
