# Hardware configuration wrapper
# This file conditionally imports the system's hardware-configuration.nix if it exists
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Path to the system's auto-generated hardware configuration
  systemHardwareConfig = /etc/nixos/hardware-configuration.nix;

  # Check if the system hardware configuration exists
  hasSystemConfig = builtins.pathExists systemHardwareConfig;
in
{
  imports = lib.optional hasSystemConfig systemHardwareConfig;

  # Hardware-related configuration that's safe to version control
  # These settings complement the auto-generated hardware configuration

  hardware = {
    # Enable firmware updates
    enableRedistributableFirmware = lib.mkDefault true;

    # CPU microcode updates
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    ledger.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
    bluetooth.enable = true;
    xone.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };
}
