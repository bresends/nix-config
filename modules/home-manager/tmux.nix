{
  pkgs,
  lib,
  ...
}:

let
  monokaiPro = (import ./colors.nix).monokaiPro;

  bg = "default"; # Let Ghostty's transparent background show through.
  activeBorder = monokaiPro.Sunglow; # Highlight active pane border (#FFD866)

  sessionBg = monokaiPro.YellowGreen;
  inactiveBg = monokaiPro.Sunglow;
  activeBg = monokaiPro.AtomicTangerine;
  uptimeBg = monokaiPro.UltraRed;
  pillFg = monokaiPro.EerieBlack;

  ro = "";
  rc = "";
  clockIcon = "󱫠";
  sessionIcon = ""; # Solid 3D Cube (f1b2)
  pill =
    pillBg: content:
    "#[bg=default,fg=${pillBg}]${ro}#[bg=${pillBg},fg=${pillFg},bold]${content}#[bg=default,fg=${pillBg}]${rc}";

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
      set -g status-style "bg=${bg},fg=${pillFg}"
      set -g pane-border-style "fg=${monokaiPro.Blackcurrant}"
      set -g pane-active-border-style "fg=${activeBorder}"
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-justify "centre"
      set -g window-status-separator " "

      set -g status-left "${pill sessionBg "${sessionIcon} #S"}"
      set -g status-right "${pill uptimeBg "${clockIcon} #(uptime | awk -F, '{print $1,$2}' | sed 's/:/h/g;s/^.*up *//; s/ *[0-9]* user.*//;s/[0-9]$/&m/;s/ day. */d/g')"}"

      set -g window-status-current-format "${pill activeBg "#I:#W"}"

      set -g window-status-format "${pill inactiveBg "#I:#W"}"

    '';
  };
}
