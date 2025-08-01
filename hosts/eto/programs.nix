{
  programs = {
    fish.enable = true;

    # Gnome3
    dconf.enable = true;
    seahorse.enable = true;

    # Game
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;

    _1password = {
      enable = true;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "claude" ];
    };
  };
}
