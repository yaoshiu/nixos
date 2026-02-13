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
  };

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    {
      nixosConfigurations.zgo-la = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
          ./disk-config.nix
        ];
      };
    };
}
