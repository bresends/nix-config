{
  config,
  pkgs,
  pkgs-unstable,
  claude-code-flake,
  ...
}:

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
      user.email = "bruno.resendesantos45@gmail.com";
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
    ripgrep
    rsync
    zoxide
    tmux
    lazygit
    claude-code-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs-unstable.gemini-cli
    pkgs-unstable.opencode
    python3
    nodejs
    postgresql
    # Language Servers (Neovim)
    lua5_1
    luarocks
    lua-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    emmet-ls
    dockerfile-language-server
    biome
    marksman
    # Formatters (Neovim)
    stylua
    prettierd
    ruff
    fixjson
    nixfmt-rfc-style
    # Linters (Neovim)
    markdownlint-cli2
    hadolint
    # Pomodoro
    timer
    lolcat
    libnotify
  ];

  programs.ssh.startAgent = true;
}
