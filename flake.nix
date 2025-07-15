{
  description = "A collection of my NixOS configurations for various machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/eto/default.nix
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
                noUnderscore = true; # Enforce explicit naming
                quiet = false; # Show all potential issues
              };
            };
            statix = {
              enable = true;
              settings = {
                # Statix checks for anti-patterns by default
                format = "stderr"; # Default error format
              };
            };

            # Markdown
            markdownlint = {
              enable = true;
              settings = {
                configuration = {
                  # Start with default rules
                  default = true;
                  # Line length with reasonable limits
                  MD013 = {
                    line_length = 100;
                    heading_line_length = 100;
                    code_block_line_length = 120; # Code can be longer
                    tables = false; # Tables are exempt
                  };
                  # Necessary exceptions for technical documentation
                  MD033 = false; # Allow inline HTML (badges, etc.)
                  MD041 = false; # First line doesn't need to be heading
                  MD014 = false; # Allow $ without showing output
                  # Stricter rules for consistency
                  MD003 = {
                    style = "atx";
                  }; # ATX-style headings only
                  MD004 = {
                    style = "dash";
                  }; # Consistent unordered list style
                  MD007 = {
                    indent = 2;
                  }; # 2-space list indentation
                  MD009 = {
                    br_spaces = 2;
                    strict = true;
                  }; # Trailing spaces
                  MD010 = true; # No hard tabs
                  MD012 = {
                    maximum = 1;
                  }; # Max 1 consecutive blank line
                  MD022 = true; # Headings surrounded by blank lines
                  MD024 = {
                    siblings_only = false;
                  }; # No duplicate headings
                  MD025 = {
                    level = 1;
                    front_matter_title = "^\\s*title\\s*[:=]";
                  }; # Single H1
                  MD026 = true; # No trailing punctuation in headings
                  MD030 = true; # Spaces after list markers
                  MD031 = true; # Fenced code blocks surrounded by blank lines
                  MD032 = true; # Lists surrounded by blank lines
                  MD034 = true; # No bare URLs
                  MD040 = true; # Fenced code blocks must have language
                  MD046 = {
                    style = "fenced";
                  }; # Code block style
                  MD048 = {
                    style = "backtick";
                  }; # Code fence style
                  MD049 = {
                    style = "asterisk";
                  }; # Emphasis style
                  MD050 = {
                    style = "asterisk";
                  }; # Strong style
                };
              };
            };
            prettier = {
              enable = true;
              types_or = [
                "markdown"
                "yaml"
              ];
              excludes = [ "^.pre-commit-config\\.yaml$" ];
              settings = {
                prose-wrap = "always"; # Wrap markdown at print width
                print-width = 100;
                tab-width = 2;
                use-tabs = false;
                trailing-comma = "all";
              };
            };

            # EditorConfig compliance check
            editorconfig-checker = {
              enable = true;
              always_run = true;
            };

            yamllint = {
              enable = true;
              settings = {
                preset = "default";
                configuration = ''
                  extends: default
                  rules:
                    line-length:
                      max: 100
                      level: error
                    comments:
                      min-spaces-from-content: 2
                      require-starting-space: true
                    comments-indentation: enable
                    document-start: disable # GitHub Actions don't use ---
                    document-end: disable
                    indentation:
                      spaces: 2
                      indent-sequences: true
                      check-multi-line-strings: false
                    trailing-spaces: enable
                    truthy:
                      allowed-values: ['true', 'false', 'on'] # 'on' for GitHub Actions
                      check-keys: true
                      level: error
                    key-duplicates: enable
                    new-line-at-end-of-file: enable
                    new-lines:
                      type: unix
                    octal-values:
                      forbid-implicit-octal: true
                      forbid-explicit-octal: true
                    quoted-strings:
                      quote-type: any
                      required: only-when-needed
                      extra-required: []
                      extra-allowed: []
                      allow-quoted-quotes: false
                    empty-lines:
                      max: 1
                      max-start: 0
                      max-end: 0
                    brackets:
                      min-spaces-inside: 0
                      max-spaces-inside: 0
                    commas:
                      max-spaces-before: 0
                      min-spaces-after: 1
                      max-spaces-after: 1
                '';
              };
            };

            # GitHub Actions
            actionlint = {
              enable = true;
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
              # Nix development tools
              nil
              nix-tree
              nix-diff

              # Editor support
              editorconfig-core-c

              # Git tools
              git
              gh

              # General development tools
              ripgrep
              fd
              jq
            ]
            ++ self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });
    };
}
