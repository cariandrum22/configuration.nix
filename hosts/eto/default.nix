{
  config,
  lib,
  pkgs,
  inputs,
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

    # Common modules
    ../../modules/system/nix.nix
    ../../modules/profiles/desktop.nix
    ../../modules/profiles/developer.nix
    ../../modules/profiles/japanese.nix
    ../../modules/services/ssh.nix
    ../../modules/security/certificates.nix

    # User configuration
    ./users.nix

    # Remaining host-specific configurations
    ./environment.nix
    ./programs.nix
    ./security.nix
    ./services.nix
  ];

  # Host identification
  networking.hostName = "eto";

  # Enable modules
  modules = {
    system.nix = {
      enable = true;
      trustedUsers = [
        "root"
        "claude"
      ];
      maxJobs = 28; # CPU-specific
      allowUnfree = true;
    };

    profiles = {
      desktop = {
        enable = true;
        windowManager = "xmonad";
        displayManager = "lightdm";
        enableGnomeKeyring = true;
        naturalScrolling = true;
      };

      developer = {
        enable = true;
        languages = [
          "c"
          "nix"
        ];
        editor = "emacs";
        enableContainers = false;
      };

      japanese = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        timezone = "Asia/Tokyo";
        inputMethod = "fcitx5";
      };
    };

    services.ssh = {
      enable = true;
      extraConfig = ''
        StreamLocalBindUnlink yes
        UseDNS no
      '';
    };

    security.certificates = {
      enableInternalCAs = true;
    };
  };

  # Unstable overlay
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (pkgs) system;
        inherit (config.nixpkgs) config;
      };
    })
  ];

  # System packages that don't fit into profiles
  environment.systemPackages = with pkgs; [
    # NixOS specific
    home-manager

    # Security tools
    yubico-pam

    # System monitoring
    lm_sensors
    liquidctl
    pciutils

    # File management
    p7zip
    unzip

    # Virtualization
    virt-manager

    # System utilities
    dool
    file
    stress-ng
    geekbench

    # Terminal multiplexers
    tmux
    screen

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

    # QEMU with UEFI
    qemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
  ];

  # System state version
  system.stateVersion = "25.05";
}
