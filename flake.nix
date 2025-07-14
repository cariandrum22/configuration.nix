{
  description = "A collection of my NixOS configurations for various machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
      };
    in
    {
      nixosConfigurations = {
        eto = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/eto/configuration.nix
          ];
        };
      };
    };
}
