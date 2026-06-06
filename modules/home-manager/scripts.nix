{ pkgs, ... }:

let
  launcher = pkgs.writeShellScriptBin "scripts-launcher" (
    builtins.readFile ./scripts/scripts-launcher.sh
  );
  youtubeSearch = pkgs.writeShellScriptBin "youtube-search" (
    builtins.readFile ./scripts/youtube-search.sh
  );
  bookmarksScript = pkgs.writeShellScriptBin "bookmarks" (builtins.readFile ./scripts/bookmarks.sh);
  screenshotAnnotate = pkgs.writeShellScriptBin "screenshot-annotate" (
    builtins.readFile ./scripts/screenshot-annotate.sh
  );
in
{
  home.packages = [
    launcher
    youtubeSearch
    bookmarksScript
    screenshotAnnotate
    pkgs.libnotify
  ];

  home.file."dev/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
