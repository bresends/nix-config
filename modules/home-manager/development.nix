{
  config,
  pkgs,
  pkgs-unstable,
  llm-agents,
  ...
}:

let
  wmill = pkgs.callPackage ../../pkgs/wmill/package.nix { };

  cliTools = with pkgs; [
    wmill
    bat
    gcc
    unzip
    btop
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
    tree-sitter
  ];

  runtimes = with pkgs; [
    python3
    nodejs_24
    postgresql
  ];

  lsp = with pkgs; [
    luarocks
    lua-language-server
    nixd
    vscode-langservers-extracted
    emmet-ls
    tailwindcss-language-server
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
    llm-agents.opencode
    llm-agents.codex
    llm-agents.antigravity-cli
  ];

in
{
  home.packages = cliTools ++ runtimes ++ lsp ++ formatters ++ linters ++ editors ++ aiTools;

  services.ssh-agent.enable = true;
}
