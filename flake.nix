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
        home-ws01 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-ws01/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
                users.bruno = import ./modules/home/common.nix;
              };
            }
          ];
        };

        home-srv01 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-srv01/configuration.nix
          ];
        };

        "8bbm-sgp-ws01" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/8bbm-sgp-ws01/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
                users.bruno = import ./modules/home/common.nix;
              };
            }
          ];
        };

        "8bbm-sgp-ws02" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/8bbm-sgp-ws02/configuration.nix
          ];
        };

        "8bbm-sad-srv01" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/8bbm-sad-srv01/configuration.nix
          ];
        };
      };
    };
}
