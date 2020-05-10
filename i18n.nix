{pkgs, ...}:

{
  # Configure internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "fcitx";
    inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  console = {
    font = "fira-code";
    keyMap = "us";
  };
}
