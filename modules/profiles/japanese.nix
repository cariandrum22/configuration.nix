{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.profiles.japanese;
in
{
  options.modules.profiles.japanese = {
    enable = mkEnableOption "Japanese language support";

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "Default system locale";
    };

    timezone = mkOption {
      type = types.str;
      default = "Asia/Tokyo";
      description = "System timezone";
    };

    inputMethod = mkOption {
      type = types.enum [
        "fcitx5"
        "ibus"
        "none"
      ];
      default = "fcitx5";
      description = "Input method framework to use";
    };

    fontPreferences = {
      serif = mkOption {
        type = types.listOf types.str;
        default = [
          "Linux Libertine"
          "IPAMincho"
        ];
        description = "Preferred serif fonts";
      };

      sansSerif = mkOption {
        type = types.listOf types.str;
        default = [
          "Fira Code"
          "Source Han Code JP"
        ];
        description = "Preferred sans-serif fonts";
      };

      monospace = mkOption {
        type = types.listOf types.str;
        default = [ "Fira Code" ];
        description = "Preferred monospace fonts";
      };
    };
  };

  config = mkIf cfg.enable {
    # Timezone
    time.timeZone = cfg.timezone;

    # Locale settings
    i18n = {
      inherit (cfg) defaultLocale;

      # Input method configuration
      inputMethod = mkIf (cfg.inputMethod != "none") {
        enable = true;
        type = cfg.inputMethod;
        fcitx5 = mkIf (cfg.inputMethod == "fcitx5") {
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
          ];
        };
      };
    };

    # Console configuration
    console.keyMap = mkDefault "us";

    # Font configuration
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        # Japanese fonts
        source-han-code-jp
        noto-fonts-cjk-sans
        ipafont
        ipaexfont

        # Additional fonts for better coverage
        noto-fonts
        noto-fonts-color-emoji

        # Programming fonts with Japanese support
        fira-code
        fira-code-symbols
        fira-mono
        nerd-fonts.fira-code
        nerd-fonts.fira-mono

        # Other fonts
        libertine
      ];

      fontconfig = {
        defaultFonts = {
          inherit (cfg.fontPreferences) serif sansSerif monospace;
        };

        # Better font rendering for CJK
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <match target="font">
              <test name="family" compare="contains">
                <string>Han</string>
              </test>
              <edit name="hinting" mode="assign">
                <bool>true</bool>
              </edit>
              <edit name="autohint" mode="assign">
                <bool>false</bool>
              </edit>
              <edit name="hintstyle" mode="assign">
                <const>hintslight</const>
              </edit>
              <edit name="antialias" mode="assign">
                <bool>true</bool>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };

    # Environment variables for Japanese support
    environment.variables = {
      LANG = cfg.defaultLocale;
      LC_CTYPE = cfg.defaultLocale;
    };
  };
}
