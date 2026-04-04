{
  description = "Bruno's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    claude-code-flake.url = "github:sadjow/claude-code-nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        home-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-desktop/configuration.nix
          ];
        };

        home-nas = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-nas/configuration.nix
          ];
        };

        "8bbm-main" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/8bbm-main/configuration.nix
          ];
        };
        "8bbm-nas" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/8bbm-nas/configuration.nix
          ];
        };

        "8bbm-sgp" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/8bbm-sgp/configuration.nix
          ];
        };
      };
    };
}
