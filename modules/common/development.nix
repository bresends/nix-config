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

    # Neovim LSP Servers
    bash-language-server       # bashls
    marksman                   # markdown LSP
    tailwindcss-language-server # tailwindcss
    vscode-langservers-extracted # html, css, jsonls
    emmet-ls                   # emmet_ls
    dockerfile-language-server-nodejs # dockerls
    yaml-language-server       # yamlls
    lua-language-server        # lua_ls
    # Note: pyrefly not yet available in nixpkgs (still in beta)
    # Note: biome LSP is included with the biome formatter below

    # Neovim Formatters
    biome      # JS/TS formatter (also provides LSP)
    stylua     # Lua formatter
    prettierd  # Multi-language formatter
    ruff       # Python formatter
    fixjson    # JSON formatter

    # Neovim Linters
    markdownlint-cli2 # Markdown linter
    hadolint          # Dockerfile linter
  ];

  programs.ssh.startAgent = true;
}
