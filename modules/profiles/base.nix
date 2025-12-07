# Base configuration for all hosts
# This module contains settings common to all machines
{
  config,
  lib,
  pkgs,
  inputs,
  hostName,
  hostType ? "physical",
  hostRoles ? [ ],
  ...
}:

{
  imports = [
    ../system/nix.nix
    ../services/ssh.nix
    ../profiles/japanese.nix
  ];

  # Host identification
  networking.hostName = hostName;

  # Base modules configuration
  modules = {
    system.nix = {
      enable = true;
      trustedUsers = [
        "root"
        "claude"
      ];
      maxJobs = lib.mkDefault 4; # Can be overridden per host
      allowUnfree = true;
    };

    services.ssh = {
      enable = true;
      extraConfig = ''
        StreamLocalBindUnlink yes
        UseDNS no
      '';
    };

    profiles.japanese = {
      enable = true;
      defaultLocale = "en_US.UTF-8";
      timezone = "Asia/Tokyo";
    };
  };

  # Unstable overlay (common to all hosts)
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (pkgs) system;
        inherit (config.nixpkgs) config;
      };
    })
  ];

  # Base system packages common to all hosts
  environment.systemPackages = with pkgs; [
    # NixOS specific
    home-manager

    # System monitoring
    lm_sensors
    pciutils

    # File management
    p7zip
    unzip

    # System utilities
    dool
    file
    htop
    tree

    # Terminal multiplexers
    tmux
    screen

    # Shells
    elvish

    # Network utilities
    wget
    curl
    nettools
  ];

  # System state version
  system.stateVersion = "25.11";
}
