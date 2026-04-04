{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    gcc
    unzip
    htop
  ];


  # This assumes a user 'bruno' is defined in the main configuration
  users.users.bruno.packages = with pkgs; [
    vscode
    stow
    ghostty
    gh
    infisical
    fzf
    ripgrep
    rsync
    zoxide
    inputs.claude-code-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    markdown-oxide
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
