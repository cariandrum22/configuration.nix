{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.profiles.desktop;
in
{
  options.modules.profiles.desktop = {
    enable = mkEnableOption "desktop environment profile";

    windowManager = mkOption {
      type = types.enum [
        "xmonad"
        "i3"
        "sway"
        "none"
      ];
      default = "none";
      description = "Window manager to use";
    };

    displayManager = mkOption {
      type = types.enum [
        "lightdm"
        "gdm"
        "sddm"
      ];
      default = "lightdm";
      description = "Display manager to use";
    };

    enableGnomeKeyring = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GNOME keyring and related services";
    };

    naturalScrolling = mkOption {
      type = types.bool;
      default = true;
      description = "Enable natural scrolling for mouse";
    };
  };

  config = mkIf cfg.enable {
    # Wayland support for Sway
    programs.sway = mkIf (cfg.windowManager == "sway") {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # Services configuration
    services = mkMerge [
      # X11 configuration
      {
        xserver = {
          enable = true;
          xkb.layout = mkDefault "us";

          # Display manager
          displayManager = mkMerge [
            (mkIf (cfg.displayManager == "lightdm") {
              lightdm.enable = true;
            })
            (mkIf (cfg.displayManager == "gdm") {
              gdm.enable = true;
            })
            (mkIf (cfg.displayManager == "sddm") {
              sddm.enable = true;
            })
            {
              sessionCommands = ''
                dbus-update-activation-environment --systemd DISPLAY
              '';
            }
          ];

          # Window manager
          windowManager = mkMerge [
            (mkIf (cfg.windowManager == "xmonad") {
              xmonad.enable = true;
            })
            (mkIf (cfg.windowManager == "i3") {
              i3.enable = true;
            })
          ];
        };
      }
      # Default session
      {
        displayManager.defaultSession = mkIf (cfg.windowManager != "none") "none+${cfg.windowManager}";
      }

      # Natural scrolling
      {
        libinput = {
          enable = true;
          mouse.naturalScrolling = cfg.naturalScrolling;
        };
      }

      # GNOME services
      (mkIf cfg.enableGnomeKeyring {
        dbus.packages = with pkgs; [
          gnome-keyring
          gcr
        ];

        gnome = {
          at-spi2-core.enable = true;
          tinysparql.enable = true;
          gnome-keyring.enable = true;
          gnome-online-accounts.enable = true;
        };

        gvfs.enable = true;
      })
    ];

    # Basic desktop packages
    environment.systemPackages =
      with pkgs;
      [
        # Core utilities
        xclip
        xsel
      ]
      ++ (optionals cfg.enableGnomeKeyring [
        # Desktop environment components
        gnome-keyring
        libsecret
      ]);
  };
}
