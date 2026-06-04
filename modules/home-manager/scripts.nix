{ config, pkgs, ... }:

let
  launcher = pkgs.writeShellScriptBin "scripts-launcher" (builtins.readFile ./scripts/scripts-launcher.sh);
  youtubeSearch = pkgs.writeShellScriptBin "youtube-search" (builtins.readFile ./scripts/youtube-search.sh);
in {
  home.packages = [ launcher youtubeSearch pkgs.libnotify ];

  home.file."dev/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}

