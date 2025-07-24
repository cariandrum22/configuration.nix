{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.system.nix;
in
{
  options.modules.system.nix = {
    enable = mkEnableOption "common Nix configuration";

    flakes = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Nix flakes support";
    };

    trustedUsers = mkOption {
      type = types.listOf types.str;
      default = [ "root" ];
      description = "List of trusted users for Nix";
    };

    maxJobs = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Maximum number of parallel build jobs";
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      description = "Allow unfree packages";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = mkIf cfg.flakes [
          "nix-command"
          "flakes"
        ];
        trusted-users = cfg.trustedUsers;
        max-jobs = mkIf (cfg.maxJobs != null) cfg.maxJobs;
      };
    };

    nixpkgs.config = {
      inherit (cfg) allowUnfree;
    };
  };
}
