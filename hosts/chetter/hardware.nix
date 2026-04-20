# Hardware configuration wrapper
{
  config,
  lib,
  ...
}:

let
  repoHardwareConfig = ./hardware-configuration.nix;
  systemHardwareConfig = /etc/nixos/hardware-configuration.nix;
  hasRepoHardwareConfig = builtins.pathExists repoHardwareConfig;
  hasSystemHardwareConfig = builtins.pathExists systemHardwareConfig;
in
{
  imports =
    lib.optional hasRepoHardwareConfig repoHardwareConfig
    ++ lib.optional (!hasRepoHardwareConfig && hasSystemHardwareConfig) systemHardwareConfig;

  assertions = [
    {
      assertion = hasRepoHardwareConfig || hasSystemHardwareConfig;
      message = ''
        chetter requires a hardware-configuration.nix that defines the root file system.
        Add hosts/chetter/hardware-configuration.nix to this repository, or ensure
        /etc/nixos/hardware-configuration.nix exists on the target machine.
      '';
    }
  ];

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ledger.enable = true;
  };
}
