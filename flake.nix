{
  description = "Bruno's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
    colmena.url = "github:zhaofengli/colmena";
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
        home-ws01 = nixpkgs.lib.nixosSystem {
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

        home-srv01 = nixpkgs.lib.nixosSystem {
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

        "8bbm-sgp-ws02" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.disko.nixosModules.disko
            ./modules/nixos/network.nix
            ./hosts/8bbm-sgp-ws02/configuration.nix
          ];
        };

        "8bbm-sad-srv01" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/8bbm-sad-srv01/configuration.nix
          ];
        };

        "8bbm-sad-srv02" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.disko.nixosModules.disko
            ./modules/nixos/network.nix
            ./hosts/8bbm-sad-srv02/configuration.nix
          ];
        };
      };

      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            inherit system;
          };
        };

        defaults = { pkgs, ... }: {
          imports = [ ./modules/nixos/network.nix ];
          environment.systemPackages = with pkgs; [
            neovim
            wget
            curl
            htop
          ];

          # Auto upgrade
          system.autoUpgrade = {
            enable = true;
            allowReboot = true;
            dates = "04:00";
          };

          # Garbage collection
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 15d";
          };
        };

        "8bbm-sad-srv02" = { pkgs, ... }: {
          deployment = {
            targetHost = "10.0.99.101";
            targetUser = "adminbm";
          };

          imports = [
            inputs.disko.nixosModules.disko
            ./hosts/8bbm-sad-srv02/configuration.nix
          ];
        };

        "8bbm-sgp-ws02" = { pkgs, ... }: {
          deployment = {
            targetHost = "10.0.99.160";
            targetUser = "adminbm";
          };

          imports = [
            inputs.disko.nixosModules.disko
            ./hosts/8bbm-sgp-ws02/configuration.nix
          ];
        };
      };
    };
}
