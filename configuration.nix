{ config, lib, pkgs, ... }:

let unstable = import <unstable> { config.allowUnfree = true; };
in
{
  imports = [
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

  nix = {
    package = unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "claude" ];
      max-jobs = lib.mkDefault 28;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <unstable> { config = config.nixpkgs.config; };
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
      libsecret

      # Utility
      lm_sensors
      liquidctl
      pciutils
      htop
      file
      p7zip
      unzip
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

      # Gnome
      networkmanagerapplet
      networkmanager-openvpn
      cinnamon.nemo
      dconf
      evince
      gnome.zenity
      lxappearance
    ];
    shellInit = ''
      export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
    '';
  };

  system.stateVersion = "23.05";
}
