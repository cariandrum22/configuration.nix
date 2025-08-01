{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.services.polkitAgent;
in
{
  options.modules.services.polkitAgent = {
    enable = mkEnableOption "Polkit authentication agent for standalone window managers";

    package = mkOption {
      type = types.package;
      default = pkgs.polkit_gnome;
      example = literalExpression ''
        pkgs.lxqt.lxqt-policykit  # Qt-based, modern UI
        pkgs.mate.mate-polkit      # MATE desktop agent
      '';
      description = "Polkit agent package to use. Different agents have varying fingerprint UI support.";
    };

    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically start the agent via systemd user service";
    };
  };

  config = mkIf cfg.enable {
    # Ensure polkit is enabled
    security.polkit.enable = true;

    # Add polkit agent to system packages
    environment.systemPackages = [ cfg.package ];

    # Add polkit rules for 1Password
    security.polkit.extraConfig = ''
      // Allow users in wheel group to authenticate with 1Password
      polkit.addRule(function(action, subject) {
        if ((action.id == "com.1password.1Password.authorizeCLI" ||
            action.id == "com.1password.1Password.authorizeSshAgent" ||
            action.id == "com.1password.1Password.unlock") &&
            subject.isInGroup("wheel")) {
          return polkit.Result.AUTH_SELF;
        }
      });
    '';

    # Create systemd user service for automatic startup
    systemd.user.services.polkit-agent = mkIf cfg.autostart {
      description = "Polkit authentication agent";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
