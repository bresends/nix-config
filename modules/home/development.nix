{
  config,
  pkgs,
  pkgs-unstable,
  llm-agents,
  ...
}:

{
  home.packages = with pkgs; [
    gcc
    unzip
    htop
    pkgs-unstable.vscode
    stow
    ghostty
    gh
    infisical
    fzf
    ripgrep
    rsync
    zoxide
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
    llm-agents.claude-code
    llm-agents.opencode
    llm-agents.gemini-cli
    llm-agents.codex
  ];

  services.ssh-agent.enable = true;
}
