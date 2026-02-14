{
  nixConfig = {
    extra-substituters = [
      "https://fayash.cachix.org"
    ];
    extra-trusted-public-keys = [
      "fayash.cachix.org-1:HEe2dZgeO/EhH10JnWQRXPFWNQ7fSzoYOo9fVE7ECeY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [
          disko.flakeModules.default
        ];
        flake = {
          nixosConfigurations.zgo-la = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              ./disk-config.nix
            ];
          };

          diskoConfigurations.zgo-la = ./disk-config.nix;
        };
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        perSystem = { pkgs, ... }: {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixos-rebuild-ng
            ];
          };
        };
      }
    );
}
