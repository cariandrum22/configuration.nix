{ pkgs, ... }:

{
  services = {
    keybase.enable = true;
    pcscd.enable = true;

    udev.packages = [
      pkgs.amazon-ec2-utils
      pkgs.yubikey-personalization
      pkgs.ledger-udev-rules
    ];

    locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };
}
