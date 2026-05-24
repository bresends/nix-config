{
  description = "Bruno's NixOS configurations";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";

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
      llm-agents = inputs.llm-agents.packages.${system};
    in
    {
      nixosConfigurations = {
        "home-ws01" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-ws01/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs pkgs-unstable llm-agents; };
                users.bruno = import ./modules/home/common.nix;
              };
            }
          ];
        };

        "home-srv01" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-unstable; };
          modules = [
            ./hosts/home-srv01/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs pkgs-unstable llm-agents; };
                users.bruno = import ./hosts/home-srv01/home.nix;
              };
            }
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
                extraSpecialArgs = { inherit inputs pkgs-unstable llm-agents; };
                users.bruno = import ./modules/home/common.nix;
              };
            }
          ];
        };

      };
    };
}
