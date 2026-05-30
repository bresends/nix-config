{ ... }:

let
  noctaliaState = builtins.fromJSON (builtins.readFile ./noctalia.json);
in

{
  programs.noctalia-shell = {
    enable = true;
    settings = noctaliaState.settings;
  };
}
