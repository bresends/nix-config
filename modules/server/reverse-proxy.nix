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
    restartUnits = [ "acme-order-renew-home.cbmgo.org.service" ];
  };

  # Template to create the credentials file in the format ACME expects
  sops.templates."cloudflare-credentials".content = ''
    CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
  '';
  sops.templates."cloudflare-credentials".owner = "acme";

  # Configure ACME with Cloudflare DNS - Wildcard certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "bruno@cbmgo.org";
    certs."home.cbmgo.org" = {
      domain = "*.home.cbmgo.org";
      extraDomainNames = [ "home.cbmgo.org" ];
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      # Radarr
      "radarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Sonarr
      "sonarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Bazarr
      "bazarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };

  # Open firewall for HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
