{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts."test.home.cbmgo.org" = {
      locations."/" = {
        return = "200 'Hello from NixOS nginx!'";
        extraConfig = ''
          add_header Content-Type text/plain;
        '';
      };
    };
  };

  # Open firewall for HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
