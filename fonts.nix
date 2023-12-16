{ pkgs, ... }:

{
  # Set multiple fonts for different languages
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      fira-mono
      source-han-code-jp
      noto-fonts-cjk
      ipafont
      libertine
      nerdfonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Linux Libertine" "IPAMincho" ];
        sansSerif = [ "Fira Code" "Source Han Code JP" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
