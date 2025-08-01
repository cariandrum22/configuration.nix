{ pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_6_15;
    kernelParams = [ "console=ttyS0,115200" ];
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 8192;
    };
    supportedFilesystems = [ "ntfs" ];
  };
}
