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
    restartUnits = [
      "acme-order-renew-proxmox.home.cbmgo.org.service"
      "acme-order-renew-qbittorrent.home.cbmgo.org.service"
      "acme-order-renew-prowlarr.home.cbmgo.org.service"
      "acme-order-renew-radarr.home.cbmgo.org.service"
      "acme-order-renew-sonarr.home.cbmgo.org.service"
      "acme-order-renew-bazarr.home.cbmgo.org.service"
      "acme-order-renew-lidarr.home.cbmgo.org.service"
      "acme-order-renew-jellyfin.home.cbmgo.org.service"
    ];
  };

  # Template to create the credentials file in the format ACME expects
  sops.templates."cloudflare-credentials".content = ''
    CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
  '';
  sops.templates."cloudflare-credentials".owner = "acme";

  # Configure ACME with Cloudflare DNS
  security.acme = {
    acceptTerms = true;
    defaults.email = "bruno@cbmgo.org";

    certs."proxmox.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."qbittorrent.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."prowlarr.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."radarr.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."sonarr.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."bazarr.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."lidarr.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };

    certs."jellyfin.home.cbmgo.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.templates."cloudflare-credentials".path;
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      # Proxmox
      "proxmox.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "proxmox.home.cbmgo.org";
        locations."/" = {
          proxyPass = "https://127.0.0.1:8006";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_ssl_verify off;
          '';
        };
      };

      # qBittorrent
      "qbittorrent.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "qbittorrent.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Prowlarr
      "prowlarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "prowlarr.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9696";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Radarr
      "radarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "radarr.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Sonarr
      "sonarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "sonarr.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Bazarr
      "bazarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "bazarr.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Lidarr
      "lidarr.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "lidarr.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8686";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };

      # Jellyfin
      "jellyfin.home.cbmgo.org" = {
        forceSSL = true;
        useACMEHost = "jellyfin.home.cbmgo.org";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };

  # Open firewall for HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
