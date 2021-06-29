{ config, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true; };
in {
  imports =
    [
      ./hardware-configuration.nix
      ./hardware.nix
      ./boot.nix
      ./environment.nix
      ./fileSystems.nix
      ./fonts.nix
      ./i18n.nix
      ./networking.nix
      ./programs.nix
      ./time.nix
      ./security.nix
      ./services.nix
      ./sound.nix
      ./users.nix
      ./virtualisation.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # NixOS Utilities
      patchelf

      # home-manager
      home-manager

      # Security and Privacy
      yubico-pam
      openssl
      gnupg

      # Utility
      lm_sensors
      pciutils
      htop
      file
      p7zip
      unzip
      appimage-run
      virtmanager
      dstat

      # Network
      dnsutils
      whois
      netcat
      dhcp

      # Benchmark
      stress-ng
      geekbench

      # Development
      git
      gcc
      gnumake
      emacs
      zlib

      # Terminal Multiplexer
      tmux
      screen

      # X
      xorg.xev
      xorg.xmodmap
      xorg.xrandr
      xorg.xmessage
      xsel

      # Gnome3
      gnome3.networkmanagerapplet
      gnome3.networkmanager_openvpn
      gnome3.nautilus
      gnome3.dconf
      gnome3.evince
      gnome3.gnome-keyring
      gnome3.zenity
      lxappearance
    ];
    shellInit = ''
      export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
    '';
  };

  nix.trustedUsers = [ "root" "claude" ];

  system.stateVersion = "21.05";
}
