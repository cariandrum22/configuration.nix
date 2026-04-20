{
  config,
  lib,
  ...
}:

{
  boot = {
    # Match the current AWS instance layout: BIOS boot, GRUB, serial console.
    growPartition = true;
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
        enable = true;
        device = "/dev/nvme0n1";
        extraConfig = ''
          serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
          terminal_output console serial
          terminal_input console serial
        '';
      };
      timeout = 1;
    };
    extraModulePackages = [ config.boot.kernelPackages.ena ];
    kernelParams = [
      "panic=1"
      "boot.panic_on_fail"
      "vga=0x317"
      "nomodeset"
      "console=ttyS0,115200n8"
      "random.trust_cpu=on"
    ];
    blacklistedKernelModules = [
      "nouveau"
      "xen_fbfront"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 8192;
    };
  };

  systemd = {
    enableEmergencyMode = false;
    services = {
      "serial-getty@ttyS0".enable = true;
      "serial-getty@hvc0".enable = false;
      "getty@tty1".enable = false;
      "autovt@".enable = false;
    };
  };
}
