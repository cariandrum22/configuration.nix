# chetter - Physical headless machine configuration
{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../modules/profiles/developer.nix
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./virtualisation.nix
    ./users.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./staging-provisioning-vpn.nix
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
        extraPackages = with pkgs; [
          yubico-pam
        ];
      };

      # Headless hosts do not need a desktop input method daemon.
      japanese.inputMethod = "none";
    };
  };
}
