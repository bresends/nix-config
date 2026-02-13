{
  description = "Bruno's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    claude-code-flake.url = "github:sadjow/claude-code-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, claude-code-flake, ... }: let
    pkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      home-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code-flake pkgs-unstable; };
        modules = [
          ./hosts/home/desktop/configuration.nix
        ];
      };

      home-nas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/home/nas/configuration.nix
        ];
      };

      "8bbm-main" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code-flake pkgs-unstable; };
        modules = [
          ./hosts/8bbm/main/configuration.nix
        ];
      };
      "8bbm-nas" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/8bbm/nas/configuration.nix
        ];
      };

      "8bbm-sgp" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/8bbm/sgp-desktop/configuration.nix
        ];
      };
    };
  };
}
