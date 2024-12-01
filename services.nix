{ pkgs, ... }:

{
  services = {
    # Configure the OpenSSH daemon.
    openssh = {
      enable = true;
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };

    # Enable the Keybase service.
    keybase.enable = true;

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [ cnijfilter2 ];
    };

    # Enable Avahi daemon.
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # Enable PC/SC daemon.
    pcscd.enable = true;

    # For YubiKey and Ledger
    udev.packages = [
      pkgs.yubikey-personalization
      pkgs.ledger-udev-rules
    ];

    # Configure the X11 windowing system.
    xserver = {
      enable = true;
      xkb.layout = "us";

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
    };

    # For natural scrolling
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };

    displayManager.defaultSession = "none+xmonad";

    dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];

    gnome = {
      at-spi2-core.enable = true;
      tinysparql.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    gvfs.enable = true;

    samba = {
      enable = true;
      settings = {
        global.Security = "user";
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

    locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
