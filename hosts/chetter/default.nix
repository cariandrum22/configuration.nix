# chetter - Physical headless machine configuration
{ pkgs, ... }:

{
  imports = [
    ../../modules/profiles/developer.nix
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./virtualisation.nix
    ./users.nix
    ./programs.nix
    ./security.nix
    ./services.nix
  ];

  modules = {
    # CPU-specific optimization
    system.nix.maxJobs = 28;

    profiles = {
      developer = {
        enable = true;
        languages = [
          "c"
          "nix"
        ];
        editor = "emacs";
        enableContainers = false;
      };

      # Headless hosts do not need a desktop input method daemon.
      japanese.inputMethod = "none";
    };
  };

  environment.systemPackages = with pkgs; [
    yubico-pam
  ];
}
