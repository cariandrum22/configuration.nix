{config, pkgs, ...}:

{
  # Set multiple fonts for different languages
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      fira-mono
      source-han-code-jp
      noto-fonts-cjk
      ipafont
      libertine
    ];

    fontconfig = {
      penultimate.enable = false;
      defaultFonts = {
        serif = [ "Linux Libertine" "IPAMincho" ];
        sansSerif = [ "Fira Code" "Source Han Code JP" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
