{
  description = "Bruno's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }: {
    nixosConfigurations = {
      home-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
