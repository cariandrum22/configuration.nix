# WSL profile
# Configuration specific to Windows Subsystem for Linux
{
  config,
  lib,
  pkgs,
  inputs,
  hostRoles ? [ ],
  ...
}:

{
  imports = [
    ./developer.nix
  ];

  # WSL specific configuration
  wsl = {
    enable = true;
    defaultUser = "claude";
    interop.register = true;

    # WSL-specific settings
    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };
  };

  # Enable developer profile if in roles
  modules.profiles.developer = {
    enable = lib.mkDefault (lib.elem "development" hostRoles);
    # No containers in WSL by default
    enableContainers = false;
  };

  # WSL specific packages
  environment.systemPackages = with pkgs; [
    # WSL utilities
    wslu

    # Network tools for WSL
    socat
  ];

  # Systemd configuration for WSL
  systemd = {
    # WSL doesn't support all systemd features
    enableEmergencyMode = false;

    # Common WSL mount for SSH keys
    mounts = lib.mkDefault [
      {
        what = "/mnt/c/Users/caria/.ssh";
        where = "/home/claude/.ssh";
        type = "none";
        options = "bind";
        wantedBy = [ "multi-user.target" ];
        after = [ "mnt-c.mount" ];
        requires = [ "mnt-c.mount" ];
      }
    ];

    # Fix SSH permissions after bind mount
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

  # Disable services that don't work well in WSL
  services = {
    # These typically don't work in WSL
    xserver.enable = false;
    printing.enable = false;
    avahi.enable = false;
  };

  # Boot configuration for WSL
  boot = {
    # WSL handles its own kernel
    isContainer = true;
  };
}
