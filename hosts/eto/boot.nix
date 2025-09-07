{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot = {
    loader.systemd-boot.enable = true;
    # Use latest kernel (6.16+)
    kernelPackages = pkgs.unstable.linuxPackages_latest;
    kernelParams = [ "console=ttyS0,115200" ];
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 8192;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  # Fix for kernel 6.16 module structure changes
  # This is required due to changes between kernel 6.15 and 6.16
  system.modulesTree = [
    (lib.getOutput "modules" config.boot.kernelPackages.kernel)
  ];
}
