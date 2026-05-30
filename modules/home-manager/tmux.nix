{
  pkgs,
  lib,
  ...
}:

let
  monokaiPro = (import ./colors.nix).monokaiPro;

  bg = monokaiPro.EerieBlack;   # Darker background for status bar (#19181A)
  activeBorder = monokaiPro.Sunglow; # Highlight active pane border (#FFD866)

  # Cozy Warm theme colors (Text-only)
  sessionColor = monokaiPro.AtomicTangerine;
  activeColor = monokaiPro.Sunglow;
  inactiveColor = monokaiPro.SonicSilver;
  uptimeColor = monokaiPro.UltraRed;

  clockIcon = "󰥔";
  sessionIcon = ""; # Solid 3D Cube (f1b2)

  # Text-only pill (no capsule backgrounds or round caps)
  pill = color: content: "#[bg=${bg},fg=${color}]${content}";

  tmux-uptime = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-uptime";
    rtpFilePath = "uptime.tmux";
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
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    prefix = lib.mkDefault "C-Space";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      vim-tmux-navigator
      {
        plugin = tmux-uptime;
        extraConfig = ''
          set -g status-right "${pill uptimeColor "${clockIcon}  #{uptime}"} "
        '';
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
    ];
    extraConfig = ''
      set -g @continuum-restore 'on'
      run-shell -b ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux

      # Terminal
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g renumber-windows on
      set -g extended-keys on

      # Remaps
      bind-key c new-window -c "#{pane_current_path}"
      unbind-key %
      bind-key v split-window -h -c "#{pane_current_path}"
      unbind-key '"'
      bind-key h split-window -v -c "#{pane_current_path}"

      bind-key x kill-window
      bind-key q kill-pane

      bind-key -n M-n next-window
      bind-key -n M-p previous-window
      bind-key -n M-\; last-window

      # Popups
      bind-key o switch-client -T open
      bind-key -T open t display-popup -d "#{pane_current_path}" -w 70% -h 90% -E "${pkgs.zsh}/bin/zsh"
      bind-key -T open l display-popup -d "#{pane_current_path}" -w 70% -h 90% -E "lazygit"

      # Styling (Monokai Pro Cozy Warm - Text Only)
      set -g status-style "bg=${bg},fg=${inactiveColor}"
      set -g pane-border-style "fg=${monokaiPro.Onyx}"
      set -g pane-active-border-style "fg=${activeBorder}"
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-justify "absolute-centre"
      set -g window-status-separator " "

      set -g status-left " ${pill sessionColor "${sessionIcon}  #S"}"

      set -g window-status-current-format "${pill activeColor "#I:#W"}"

      set -g window-status-format "${pill inactiveColor "#I:#W"}"

    '';
  };
}
