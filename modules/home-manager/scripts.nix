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
  transcribeWhatsappAudio = pkgs.writeShellApplication {
    name = "transcribe-whatsapp-audio";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      ffmpeg
      findutils
      libnotify
      wl-clipboard
    ];
    text = builtins.readFile ./scripts/transcribe-whatsapp-audio.sh;
  };
in
{
  home.packages = [
    launcher
    youtubeSearch
    bookmarksScript
    screenshotAnnotate
    transcribeWhatsappAudio
    pkgs.libnotify
    pkgs.grim
    pkgs.slurp
  ];

  home.file."dev/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
