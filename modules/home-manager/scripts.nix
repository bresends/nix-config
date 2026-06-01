{ config, pkgs, ... }:

let
  launcher = pkgs.writeShellScriptBin "scripts-launcher" (builtins.readFile ./scripts/scripts-launcher.sh);
in {
  home.packages = [ launcher pkgs.libnotify ];

  home.file."dev/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}

