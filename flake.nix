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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      flake-parts,
      sops-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        flake = {
          nixosConfigurations.zgo-la = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              ./disk-config.nix
              ./sing-box.nix
              disko.nixosModules.default
              sops-nix.nixosModules.default
            ];
          };
        };
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        perSystem = { pkgs, ... }: {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixos-rebuild-ng
              ssh-to-age
              sops
            ];
          };
        };
      }
    );
}
