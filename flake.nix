{
  description = "A collection of my NixOS configurations for various machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
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
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # Nix
            nixfmt-rfc-style.enable = true;
            deadnix = {
              enable = true;
              settings = {
                noLambdaArg = true;
                noLambdaPatternNames = true;
              };
            };
            statix.enable = true;

            # Markdown
            markdownlint = {
              enable = true;
              settings = {
                configuration = {
                  MD013 = false; # Line length
                  MD033 = false; # Inline HTML
                  MD041 = false; # First line in file should be a top level heading
                };
              };
            };
            prettier = {
              enable = true;
              types_or = [ "markdown" ];
              excludes = [ "^.pre-commit-config\\.yaml$" ];
            };

            # Commit message
            commitizen = {
              enable = true;
              stages = [ "commit-msg" ];
            };
          };
        };
      });
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs =
            with nixpkgs.legacyPackages.${system};
            [
              nil
            ]
            ++ self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });
    };
}
