{
  config,
  pkgs,
  ...
}:

let
  externalInterface = "ens5";
  wireguardInterface = "wg0";
  wireguardAddress = "10.77.0.1";
  iphoneAddress = "10.77.0.2";
  wireguardPort = 51820;
  evenTerminalPort = 3456;
  privateKeySecret = "chetter/even-terminal-wireguard/private-key";
in
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  sops.secrets.${privateKeySecret} = {
    sopsFile = ./even-terminal-wireguard.secrets.yaml;
    owner = "root";
    group = "root";
    mode = "0400";
    restartUnits = [ "wireguard-${wireguardInterface}.service" ];
  };

  networking = {
    networkmanager.unmanaged = [ "interface-name:${wireguardInterface}" ];

    wireguard.interfaces.${wireguardInterface} = {
      ips = [ "${wireguardAddress}/24" ];
      listenPort = wireguardPort;
      privateKeyFile = config.sops.secrets.${privateKeySecret}.path;

      peers = [
        {
          publicKey = "IobwH6TBCi9xR/YjOdcUJ/pq0vHFow7yCTnMXlY0CnM=";
          allowedIPs = [ "${iphoneAddress}/32" ];
        }
      ];
    };

    nftables = {
      enable = true;
      tables."even-terminal-wireguard-isolation" = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority -10; policy accept;

            iifname "${wireguardInterface}" ip saddr != ${iphoneAddress} counter drop comment "reject spoofed WireGuard source"
            iifname "${wireguardInterface}" meta l4proto != tcp counter drop comment "restrict WireGuard to Even Terminal"
            iifname "${wireguardInterface}" tcp dport != ${toString evenTerminalPort} counter drop comment "restrict WireGuard to Even Terminal"
          }

          chain forward {
            type filter hook forward priority -10; policy accept;

            iifname "${wireguardInterface}" counter drop comment "block WireGuard access to VPC"
            oifname "${wireguardInterface}" counter drop comment "block routed traffic to WireGuard"
          }
        '';
      };
    };

    firewall.interfaces = {
      ${externalInterface}.allowedUDPPorts = [ wireguardPort ];
      ${wireguardInterface}.allowedTCPPorts = [ evenTerminalPort ];
    };
  };
}
