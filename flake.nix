{
  description = "Bruno's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";
    claude-code-flake.url = "github:sadjow/claude-code-nix";
  };

  outputs = { self, nixpkgs, sops-nix, claude-code-flake, ... }: {
    nixosConfigurations = {
      home-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code-flake; };
        modules = [
          ./hosts/home/desktop/configuration.nix
        ];
      };

      home-nas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit sops-nix; };
        modules = [
          ./hosts/home/nas/configuration.nix
        ];
      };

      "8bbm-main" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code-flake; };
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
