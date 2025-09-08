{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../modules/system/nix.nix
    ../../modules/profiles/developer.nix
    ../../modules/profiles/japanese.nix
    ../../modules/services/ssh.nix

    # User configuration
    ./users.nix

    # Remaining host-specific configurations
    ./programs.nix
    ./_1passwordWrapper.nix
  ];

  # Host identification
  networking.hostName = "virgil";

  wsl = {
    enable = true;
    defaultUser = "claude";
    interop.register = true;
  };

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
      };
    };

    services.ssh = {
      enable = true;
      extraConfig = ''
        StreamLocalBindUnlink yes
        UseDNS no
      '';
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

  systemd = {
    mounts = [
      {
        # Bind Windows .ssh to Linux home
        what = "/mnt/c/Users/caria/.ssh";
        where = "/home/claude/.ssh";
        type = "none";
        options = "bind";
        wantedBy = [ "multi-user.target" ];
        after = [ "mnt-c.mount" ];
        requires = [ "mnt-c.mount" ];
      }
    ];
    services.fix-ssh-permissions = {
      description = "Fix permissions for ~/.ssh after bind mount";
      after = [ "home-claude-.ssh.mount" ];
      requires = [ "home-claude-.ssh.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/chmod 700 /home/claude/.ssh";
        ExecStartPost = "${pkgs.findutils}/bin/find /home/claude/.ssh -type f -exec chmod 600 {} \\;";
      };
    };
  };

  # System packages that don't fit into profiles
  environment.systemPackages = with pkgs; [
    # NixOS specific
    home-manager

    # System monitoring
    lm_sensors
    liquidctl
    pciutils

    # File management
    p7zip
    unzip

    # System utilities
    dool
    file
    stress-ng
    geekbench

    # Terminal multiplexers
    tmux
    screen

    # Network utilities
    socat
  ];

  # System state version
  system.stateVersion = "25.05";
}
