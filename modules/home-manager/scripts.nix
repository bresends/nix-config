{ config, pkgs, ... }:

let
  scriptDir = "${config.home.homeDirectory}/dev/scripts";

  launcher = pkgs.writeShellScriptBin "scripts-launcher" ''
    chosen=$(
      find "${scriptDir}" -maxdepth 1 -name '*.sh' -print0 \
        | xargs -0 -n1 basename \
        | sed 's/\.sh$//' \
        | sort \
        | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Scripts: "
    )
    [[ -n "$chosen" ]] && exec "${scriptDir}/$chosen.sh"
  '';
in {
  home.packages = [ launcher ];

  home.file."dev/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}

