{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = mkEnableOption "SSH server";

    port = mkOption {
      type = types.port;
      default = 22;
      description = "Port on which to listen for SSH connections";
    };

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow password authentication";
    };

    permitRootLogin = mkOption {
      type = types.enum [
        "yes"
        "no"
        "prohibit-password"
        "without-password"
      ];
      default = "no";
      description = "Whether and how to allow root login";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines for sshd_config";
    };

    authorizedKeys = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      description = "Authorized SSH keys by user";
      example = literalExpression ''
        {
          alice = [ "ssh-rsa AAAAB3Nza..." ];
          bob = [ "ssh-ed25519 AAAAC3Nza..." ];
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        PermitRootLogin = cfg.permitRootLogin;
        # Security hardening
        KbdInteractiveAuthentication = false;
        X11Forwarding = mkDefault false;
      };
      inherit (cfg) extraConfig;
    };

    # Set up authorized keys
    users.users = mapAttrs (user: keys: {
      openssh.authorizedKeys.keys = keys;
    }) cfg.authorizedKeys;

    # Open firewall port
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
