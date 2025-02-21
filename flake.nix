{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      agenix,
      flake-utils,
      treefmt-nix,
    }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            {
              nix = {
                channel.enable = false;
                registry.nixpkgs.flake = nixpkgs;
                settings.nix-path = [ "nixpkgs=${nixpkgs}" ];
              };
            }

            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
            }

            agenix.nixosModules.default
            {
              environment.systemPackages = [
                agenix.packages."${system}".default
              ];
            }
            ./secrets

            ./system
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      formatter = treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.${system} {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    });
}
