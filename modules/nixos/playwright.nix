{ pkgs, ... }:

let
  playwrightBrowsers = pkgs.playwright-driver.browsers;
in
{
  environment.systemPackages = [
    playwrightBrowsers
  ];

  environment.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwrightBrowsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
  };
}
