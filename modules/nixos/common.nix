{ ... }:

{
  # Keep the Nix command-line and flakes interfaces available on every host.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Reclaim unused store paths without requiring host-specific policy.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

  # The repository uses packages that are not in the free set on more than one
  # host, so this remains a shared package-policy setting rather than a host
  # or desktop assumption.
  nixpkgs.config.allowUnfree = true;
}
