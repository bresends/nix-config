{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Monokai Pro colors
  bg = "#2d2a2e";
  fg = "#403E41";
  muted = "#727072";
  accent = "#FFD866";

  # Helper scripts for unicode chars (tmux strips backslashes from #() args)
  print-char = code: pkgs.writeShellScript "tmux-char" "printf '\\u${code}'";
  ro = "#(${print-char "e0b6"})";
  rc = "#(${print-char "e0b4"})";
  clockIcon = "#(${print-char "e641"})";
  hostIcon = "#(${print-char "f4a9"})";

  pill =
    color: content:
    "#[bg=${bg},fg=${fg}]${ro}#[bg=${fg},fg=${color}]${content}#[bg=${bg},fg=${fg}]${rc}";

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
          set -g status-right "${pill accent "${clockIcon} #{uptime}"} ${pill accent "${hostIcon} #H"}"
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
      bind-key -T open l display-popup -d "#{pane_current_path}" -w 70% -h 90% -E "lazygit"

      # Styling (Monokai Pro)
      set -g status-style "bg=${bg},fg=${fg}"
      set -g pane-border-style "fg=${fg}"
      set -g pane-active-border-style "fg=${fg}"
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-justify "absolute-centre"
      set -g window-status-separator " "

      set -g status-left "${pill accent "#S"}"

      set -g window-status-current-format "${pill accent "#I:#{pane_title}"}"

      set -g window-status-format "${pill muted "#I:#{pane_title}"}"

    '';
  };
}
