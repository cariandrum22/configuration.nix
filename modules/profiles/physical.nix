# Physical machine profile
# Configuration specific to physical hardware
{
  config,
  lib,
  pkgs,
  hostRoles ? [ ],
  ...
}:

{
  imports = [
    ./desktop.nix
    ./developer.nix
    ../security/certificates.nix
    ../security/fingerprint.nix
    ../services/polkit-agent.nix
  ];

  # Module configuration
  modules = {
    # Enable desktop if in roles
    profiles.desktop.enable = lib.mkDefault (lib.elem "desktop" hostRoles);

    # Enable developer profile if in roles
    profiles.developer.enable = lib.mkDefault (lib.elem "development" hostRoles);

    # Security modules common to physical machines
    security = lib.mkIf (lib.elem "desktop" hostRoles) {
      certificates.enableInternalCAs = true;

      fingerprint = {
        enable = lib.mkDefault false; # Can be enabled per host
        enablePAM = true;
        autoDetectDisplayManager = true;
      };
    };

    # Polkit agent for desktop environments
    services.polkitAgent = lib.mkIf (lib.elem "desktop" hostRoles) {
      enable = true;
      package = lib.mkDefault pkgs.polkit_gnome;
    };
  };

  # Physical machine specific packages
  environment.systemPackages = with pkgs; [
    # Hardware monitoring
    liquidctl
    stress-ng
    geekbench

    # Virtualization (usually on physical machines)
    virt-manager
    qemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
  ];

  # Common physical machine services
  services = {
    # Power management
    thermald.enable = lib.mkDefault true;

    # Hardware management
    fwupd.enable = lib.mkDefault true;
  };
}
