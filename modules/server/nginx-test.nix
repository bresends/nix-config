{ config, pkgs, sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  # Configure sops to read secrets
  sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/bruno/.config/sops/age/keys.txt";

  # Define the secret that needs to be extracted
  sops.secrets."cloudflare/api_token" = {
    sopsFile = ./../../secrets/secrets.yaml;
    restartUnits = [ "acme-order-renew-test.home.cbmgo.org.service" ];
  };

  # Template to create the credentials file in the format ACME expects
  sops.templates."cloudflare-credentials".content = ''
    CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
  '';
  sops.templates."cloudflare-credentials".owner = "acme";

  # Configure ACME with Cloudflare DNS
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "bruno@cbmgo.org";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."test.home.cbmgo.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "200 'Hello from NixOS nginx with SSL!'";
        extraConfig = ''
          add_header Content-Type text/plain;
        '';
      };
    };
  };

  # Open firewall for HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
