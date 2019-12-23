{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 8192;
  };
}
