{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ntn";
  version = "0.18.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/ntn/-/ntn-${version}.tgz";
    hash = "sha512-TW9mUUjLet9YdOIdn/qllYD9LdfOc9ZONEL0cZ0g4qUi7uR97OlYBsM+9aCZ3RDLUEoMsexC3BBCQze8DvxuLA==";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/ntn-linux-x64/ntn $out/bin/ntn
    install -Dm644 LICENSE.md $out/share/licenses/ntn/LICENSE.md
    install -Dm644 README.md $out/share/doc/ntn/README.md

    runHook postInstall
  '';

  meta = {
    description = "Notion CLI";
    homepage = "https://developers.notion.com/cli/get-started/overview";
    license = lib.licenses.mit;
    mainProgram = "ntn";
    platforms = [ "x86_64-linux" ];
  };
}
