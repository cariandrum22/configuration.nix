# virgil - WSL development environment configuration
{
  config,
  lib,
  pkgs,
  hostRoles,
  ...
}:

{
  imports = [
    # User configuration
    ./users.nix

    # Host-specific configurations
    ./programs.nix
    ./_1passwordWrapper.nix
  ];

  # Module configuration
  modules = {
    # CPU-specific optimization
    system.nix.maxJobs = 28;

    # Developer configuration
    profiles.developer = {
      languages = [
        "c"
        "nix"
      ];
      editor = "emacs";
    };
  };

  # No special packages needed beyond base and WSL profiles
}
