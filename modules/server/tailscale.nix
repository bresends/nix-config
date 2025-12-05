{ config, pkgs, ... }:

{
  # Enable Tailscale
  services.tailscale.enable = true;
}
