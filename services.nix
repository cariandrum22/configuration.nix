{ config, pkgs, fetchurl, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Keybase service.
  services.keybase.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable PC/SC daemon.
  services.pcscd.enable = true;

  # For YubiKey and Ledger
  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.ledger-udev-rules
  ];

  # Configure the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # For natural scrolling
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };

    # I'm currently using a nVidia Graphics Card.
    videoDrivers = [ "nvidia" ];

    # Configure Display Manager.
    displayManager.lightdm = {
      enable = true;
      extraSeatDefaults = ''
        display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 3840x2160 --rate 60.0 --primary --output DP-4 --mode 3840x2160 --rate 60.0 --left-of DP-2
        ''}
      '';
    };

    # Configure Window Manager
    windowManager.xmonad.enable = true;
    displayManager.defaultSession = "none+xmonad";
  };

  services.dbus.packages = [
    pkgs.gnome3.gnome-keyring
    pkgs.gcr
  ];

  services.gnome = {
    at-spi2-core.enable = true;
    tracker.enable = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xmonad";
  };

  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      TimeMachine = {
        path = "/mnt/magnetic/disk0/TimeMachine";
        browseable = "yes";
        writable = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
        "fruit:time machine" = "yes";
        "fruit:time machine max size" = "2T";
      };
      Photos = {
        path = "/mnt/magnetic/disk0/Photos";
        browseable = "yes";
        writable = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
      };
    };
  };
}
