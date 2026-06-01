{ pkgs, ... }:

let
  monokaiPro = (import ./colors.nix).monokaiPro;
  toFuzzelColor = hex: (builtins.substring 1 6 hex) + "ff";
  toFuzzelColorAlpha = hex: alpha: (builtins.substring 1 6 hex) + alpha;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMonoNL Nerd Font:size=14";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        prompt = "\" \"";
        width = 40;
        horizontal-pad = 20;
        vertical-pad = 16;
        inner-pad = 10;
        line-height = 24;
      };
      colors = {
        background = toFuzzelColorAlpha monokaiPro.Blackcurrant "e6";
        text = toFuzzelColor monokaiPro.WhiteSmoke;
        input = toFuzzelColor monokaiPro.WhiteSmoke;
        prompt = toFuzzelColor monokaiPro.Sunglow;
        match = toFuzzelColor monokaiPro.Sunglow;
        selection = toFuzzelColor monokaiPro.Sunglow;
        selection-text = toFuzzelColor monokaiPro.Onyx;
        selection-match = toFuzzelColor monokaiPro.EerieBlack;
        border = "7fc8ffff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
