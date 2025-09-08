# eto - Physical desktop machine configuration
{
  config,
  lib,
  pkgs,
  hostRoles,
  ...
}:

{
  imports = [
    # Hardware
    ./hardware.nix # Handles hardware-configuration.nix conditionally
    ./boot.nix
    ./fileSystems.nix

    # Host-specific services
    ./networking.nix
    ./virtualisation.nix

    # User configuration
    ./users.nix

    # Remaining host-specific configurations
    ./environment.nix
    ./programs.nix
    ./security.nix
    ./services.nix
  ];

  # Module configuration
  modules = {
    # CPU-specific optimization
    system.nix.maxJobs = 28;

    profiles = {
      # Desktop configuration
      desktop = {
        windowManager = "xmonad";
        displayManager = "lightdm";
        enableGnomeKeyring = true;
        naturalScrolling = true;
      };

      # Developer configuration
      developer = {
        languages = [
          "c"
          "nix"
        ];
        editor = "emacs";
        enableContainers = false;
      };

      # Japanese input method for desktop
      japanese.inputMethod = "fcitx5";
    };

    # Security configuration
    security.fingerprint = {
      enable = true;
      enablePAM = true;
      autoDetectDisplayManager = true;
      pamServices = [
        "login"
        "sudo"
        "polkit-1"
        "lightdm-greeter"
      ];
    };
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    # Security tools
    yubico-pam

    # X utilities
    xorg.xev
    xorg.xmodmap
    xorg.xrandr
    xorg.xmessage

    # Desktop utilities
    networkmanagerapplet
    networkmanager-openvpn
    nemo
    evince
    zenity
    lxappearance

    # Gaming
    mangohud
  ];
}
