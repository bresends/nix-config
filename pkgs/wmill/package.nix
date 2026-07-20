{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_24,
}:

(buildNpmPackage.override { nodejs = nodejs_24; }) rec {
  pname = "windmill-cli";
  version = "1.763.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/windmill-cli/-/windmill-cli-${version}.tgz";
    hash = "sha512-pofXZ7Z+tKsAdkH+hWINddCzZRCTyD+5sHT/ARXLM77sJbmKXJVkB3qUFSpyRdBdpMry9gsr6EmsvzdfR9Jb/g==";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-wGftOiNOdx7jZQ4Nq7ecGG2175DRyQjcR0xSR0nuGFw=";
  dontNpmBuild = true;

  meta = {
    description = "CLI for Windmill";
    homepage = "https://www.windmill.dev/docs/advanced/cli";
    license = lib.licenses.asl20;
    mainProgram = "wmill";
  };
}
