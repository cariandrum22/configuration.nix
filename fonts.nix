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
      noto-fonts-cjk-sans
      ipafont
      libertine
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Linux Libertine"
          "IPAMincho"
        ];
        sansSerif = [
          "Fira Code"
          "Source Han Code JP"
        ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
