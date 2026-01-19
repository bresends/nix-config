{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    unzip
    htop
  ];

  programs.git = {
    enable = true;
    config = {
      user.name = "Bruno Resende";
      user.email = "bruno.resende@gmx.com";
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.starship.enable = true;

  # This assumes a user 'bruno' is defined in the main configuration
  users.users.bruno.packages = with pkgs; [
    stow
    ghostty
    starship
    gh
    fzf
    rsync
    zoxide
    tmux
    lazygit
    python3
    nodejs
    claude-code
    gemini-cli
  ];

  programs.ssh.startAgent = true;
}
