{
  config,
  pkgs,
  pkgs-unstable,
  llm-agents,
  ...
}:

let
  cliTools = with pkgs; [
    gcc
    unzip
    htop
    stow
    ghostty
    gh
    infisical
    fzf
    ripgrep
    rsync
    zoxide
    jq
    wl-clipboard
    pastel
    nerd-fonts.jetbrains-mono
  ];

  runtimes = with pkgs; [
    python3
    nodejs
    postgresql
  ];

  androidTools = with pkgs; [
    android-studio
    android-tools
    flutter
    firebase-tools
  ];

  languageServers = with pkgs; [
    lua5_1
    luarocks
    lua-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    emmet-ls
    dockerfile-language-server
    biome
    markdown-oxide
    clang-tools
  ];

  formatters = with pkgs; [
    stylua
    prettierd
    ruff
    fixjson
    nixfmt
  ];

  linters = with pkgs; [
    markdownlint-cli2
    hadolint
    cpplint
  ];

  editors = [
    pkgs-unstable.vscode
  ];

  aiTools = [
    llm-agents.claude-code
    llm-agents.pi
    llm-agents.opencode
    llm-agents.codex
    llm-agents.antigravity-cli
  ];
in
{
  home.packages =
    cliTools
    ++ runtimes
    ++ androidTools
    ++ languageServers
    ++ formatters
    ++ linters
    ++ editors
    ++ aiTools;

  services.ssh-agent.enable = true;
}
