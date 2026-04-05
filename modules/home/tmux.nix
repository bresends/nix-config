{ config, pkgs, ... }:

let
  tmux-uptime = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-uptime";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "robhurring";
      repo = "tmux-uptime";
      rev = "master";
      sha256 = "sha256-hKVx9MIpuoa0bnv6CsW2pD/kOmggbdBipyWj3pKMDR4=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      resurrect
      continuum
      vim-tmux-navigator
      tmux-uptime
    ];
    extraConfig = ''
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
    '';
  };
}
