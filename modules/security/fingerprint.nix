{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.security.fingerprint;
in
{
  options.modules.security.fingerprint = {
    enable = mkEnableOption "fingerprint scanner support";

    package = mkOption {
      type = types.package;
      default = pkgs.fprintd;
      description = "The fprintd package to use";
    };

    enablePAM = mkOption {
      type = types.bool;
      default = true;
      description = "Enable PAM integration for fingerprint authentication";
    };

    pamServices = mkOption {
      type = types.listOf types.str;
      default = [
        "login"
        "sudo"
        "polkit-1"
      ];
      example = [
        "login"
        "lightdm"
        "gdm"
        "sddm"
        "xscreensaver"
        "sudo"
        "polkit-1"
      ];
      description = "PAM services to enable fingerprint authentication for";
    };

    autoDetectDisplayManager = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically detect and configure the active display manager";
    };
  };

  config = mkIf cfg.enable {
    # Enable fprintd service
    services.fprintd = {
      enable = true;
      inherit (cfg) package;
    };

    # Enable PAM integration
    security.pam.services = mkIf cfg.enablePAM (
      let
        # Auto-detect display manager if enabled
        autoDetectedServices =
          cfg.pamServices
          ++ (
            if cfg.autoDetectDisplayManager then
              (optional config.services.xserver.displayManager.lightdm.enable "lightdm")
              ++ (optional config.services.xserver.displayManager.gdm.enable "gdm")
              ++ (optional config.services.xserver.displayManager.sddm.enable "sddm")
              ++ (optional config.services.xserver.enable "xscreensaver")
            else
              [ ]
          );
      in
      listToAttrs (
        map (service: {
          name = service;
          value = {
            fprintAuth = true;
          };
        }) autoDetectedServices
      )
    );

    # Add fprintd packages
    environment.systemPackages = with pkgs; [
      cfg.package
    ];

    # Ensure the necessary groups exist
    users.groups.plugdev = { };

    # udev rules for fingerprint scanner access
    services.udev.extraRules = ''
      # DigitalPersona 4500 Fingerprint Reader
      SUBSYSTEM=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="0007", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="0008", MODE="0666", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="05ba", ATTRS{idProduct}=="000a", MODE="0666", GROUP="plugdev"

      # General fingerprint reader rules
      SUBSYSTEM=="usb", ATTRS{idVendor}=="08ff", MODE="0666", GROUP="plugdev"
    '';
  };
}
