{ ... }:

{
  # Hostname
  networking.hostName = "servidor-1";

  # Static IP configuration
  networking.interfaces.enp0s25 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.99.25";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "10.0.99.1";
  networking.nameservers = [ "10.242.254.70" "10.242.254.71" ];
}
