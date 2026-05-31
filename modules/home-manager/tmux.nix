{
  pkgs,
  lib,
  ...
}:

let
  monokaiPro = (import ./colors.nix).monokaiPro;

  bg = monokaiPro.Blackcurrant; # Blends with Ghostty background (#2D2A2E)
  activeBorder = monokaiPro.Sunglow; # Highlight active pane border (#FFD866)

  # Pill default dark background and yellow text
  pillBgDefault = monokaiPro.Onyx; # (#403E41)
  pillFgDefault = monokaiPro.Sunglow; # Yellow text color (#FFD866)

  # Active window bright yellow background and dark text
  activeBg = monokaiPro.Sunglow; # (#FFD866)
  activeFg = monokaiPro.EerieBlack; # (#19181A)

  ro = "";
  rc = "";
  clockIcon = "󰥔";
  sessionIcon = ""; # Solid 3D Cube (f1b2)
  pill =
    pillBg: pillFg: content:
    "#[bg=${bg},fg=${pillBg}]${ro}#[bg=${pillBg},fg=${pillFg}]${content}#[bg=${bg},fg=${pillBg}]${rc}";

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
          set -g status-right "${pill pillBgDefault pillFgDefault "${clockIcon} #{uptime}"}"
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
      set-option -sa terminal-features ",xterm*:extkeys"
      set-option -g renumber-windows on
      set -s extended-keys always

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

      # Styling (Monokai Pro)
      set -g status-style "bg=${bg},fg=${pillFgDefault}"
      set -g pane-border-style "fg=${pillBgDefault}"
      set -g pane-active-border-style "fg=${activeBorder}"
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-justify "absolute-centre"
      set -g window-status-separator " "

      set -g status-left "${pill pillBgDefault pillFgDefault "${sessionIcon} #S"}"

      set -g window-status-current-format "${pill activeBg activeFg "#I:#W"}"

      set -g window-status-format "${pill pillBgDefault pillFgDefault "#I:#W"}"

    '';
  };
}
