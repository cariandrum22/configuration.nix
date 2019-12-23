{ config, pkgs, fetchurl, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Keybase service.
  services.keybase.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable PC/SC daemon.
  #services.pcscd.enable = true;

  # For YubiKey and Ledger
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.ledger-udev-rules ];
  hardware.ledger.enable = true;

  # Configure the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # For natural crawling
    libinput.enable = true;

    # I'm currently using a nVidia Graphics Card.
    videoDrivers = [ "nvidia" ];

    # Configure Display Manager.
    displayManager.lightdm = {
      enable = true;
      extraSeatDefaults = ''
        display-setup-script=${pkgs.writeScript "lightdm-display-setup" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 3840x2160 --rate 60.0 --primary --output DP-4 --mode 3840x2160 --rate 60.0 --left-of DP-2
          ${pkgs.xorg.xinput}/bin/xinput set-prop 'Kensington Expert Wireless TB Mouse' 'libinput Natural Scrolling Enabled' 1
        ''}
      '';
    };

    # Configure Window Manager
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };

    displayManager.defaultSession = "none+xmonad";
  };

#  services.xrdp = {
#    enable = true;
#    defaultWindowManager = "xterm";
#  };
}
