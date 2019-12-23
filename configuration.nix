{ config, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true; };
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./environment.nix
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
      unstable = import unstable {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Drivers
    ntfs3g

    # Teminal
    kitty

    # home-manager
    home-manager

    # nix-shell
    any-nix-shell

    # Security
    #yubico-pam

    # System Utility
    lm_sensors
    pciutils
    htop
    file
    p7zip
    appimage-run
    virtmanager
    openssl

    # Benchmark
    stress-ng
    geekbench

    # Network Utility
    dnsutils
    whois
    netcat

    # Development
    git
    gcc
    gnumake
    emacs
    unstable.vscode
    unstable.cachix
    (all-hies.selection { selector = p: { inherit (p) ghc882; }; })
    unstable.jetbrains.datagrip
    jq
    mysql-client
    mongodb-tools
    #postgresql_9_6
    postgresql_10
    zlib
    heroku

    # Deep Learning
    cudatoolkit
    cudnn

    # Compiler and Runtime
    stack
    rustup
    jdk
    unstable.go
    dotnet-sdk
    ruby_2_6
    python3
    nodejs

    # DevOps
    nixops
    docker-compose
    etcdctl
    kubectl
    helm
    vagrant
    vault
    unstable.terraform
    unstable.azure-cli
    unstable.azure-storage-azcopy
    certbot

    # Utility
    patchelf
    tmux
    xsel
    ghq
    direnv
    fzf
    google-drive-ocamlfuse
    yubikey-manager
    conky

    # Xorg
    xorg.xev
    xorg.xmodmap
    xorg.xrandr

    # Desktop Environments
    dmenu
    xmobar
    polybar
    feh
    picom

    # GUI Applications
    google-chrome
    keybase
    ark
    partition-manager
    kdeApplications.okular
    _1password
    slack
    #steam
    robo3t
    xmind
    ledger-live-desktop
    yubikey-manager-qt
    typora
    remmina
    libreoffice
  ];

  # For Steam
  #hardware.opengl.driSupport32Bit = true;

  system.stateVersion = "19.09";
}
