{
  programs.fish.enable = true;

  # Gnome3
  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  # Game
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
}
