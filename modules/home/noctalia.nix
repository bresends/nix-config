{ ... }:

let
  noctaliaState = builtins.fromJSON (builtins.readFile ./noctalia.json);
in

{
  programs.noctalia-shell = {
    enable = true;
    settings = noctaliaState.settings;
  };

  home.file.".config/noctalia/colorschemes/Monokai/Monokai.json".source =
    ./noctalia-colorschemes/Monokai.json;
}
