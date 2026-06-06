{ pkgs, ... }:

{
  home.packages = with pkgs; [
    satty
  ];

  home.file.".config/satty/config.toml".text = ''
    [color-palette]
    palette = [
      "#eb4d4b", # Red (Default)
      "#00ffff",
      "#a52a2a",
      "#dc143c",
      "#ff1493",
      "#ffd700",
      "#008000"
    ]
  '';
}
