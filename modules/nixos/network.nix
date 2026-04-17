{ ... }:
{
  networking.useDHCP = false;
  networking.defaultGateway = "10.0.99.1";
  networking.nameservers = [ "10.242.254.70" "10.242.254.71" ];
}
