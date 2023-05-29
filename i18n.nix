{ pkgs, ... }:

{
  # Configure internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
    };
  };

  console = {
    font = "fira-code";
    keyMap = "us";
  };
}
