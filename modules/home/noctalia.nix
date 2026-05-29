{ ... }:

{
  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density = "compact";
        position = "top";
      };

      general = {
        avatarImage = "/home/bruno/.face";
        radiusRatio = 0.2;
      };
    };
  };
}
