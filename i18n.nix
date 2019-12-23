{pkgs, ...}:

{
  # Configure internationalisation properties.
  i18n = {
    consoleFont = "fira-code";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "fcitx";
    inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };
}
