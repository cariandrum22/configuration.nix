{
  config,
  pkgs,
  ...
}:

let
  serviceName = "codetakt-staging-provisioning-vpn";
  sopsFile = ./staging-provisioning-vpn.secrets.yaml;
  secretNames = {
    caCertificate = "chetter/staging-provisioning-vpn/ca.crt";
    tlsCryptV2Key = "chetter/staging-provisioning-vpn/client-tc.key";
    authUserPass = "chetter/staging-provisioning-vpn/auth.txt";
  };
  secretPath = name: config.sops.secrets.${name}.path;
  vpnSecret = {
    inherit sopsFile;
    owner = "root";
    group = "root";
    mode = "0400";
    restartUnits = [ "${serviceName}.service" ];
  };
  openvpnConfig = pkgs.writeText "codetakt-staging-provisioning.ovpn" ''
    client
    dev tun-stgprov
    proto udp
    remote openvpn-nlb-staging-apne1-528f572b7699ada1.elb.ap-northeast-1.amazonaws.com 1194
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    remote-cert-tls server
    verify-x509-name remote-access-server1.codetakt.net name
    ca ${secretPath secretNames.caCertificate}
    tls-crypt-v2 ${secretPath secretNames.tlsCryptV2Key}
    auth-user-pass ${secretPath secretNames.authUserPass}
    auth-nocache
    auth-retry nointeract
    setenv CLIENT_CERT 0
    tls-cert-profile suiteb
    tls-version-min 1.3
    tls-ciphersuites TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    tls-groups secp384r1
    data-ciphers AES-256-GCM
    data-ciphers-fallback AES-256-GCM
    tun-mtu 1400
    mssfix 1360
    replay-window 256 30
    pull
    connect-timeout 10
    connect-retry 5 30
    server-poll-timeout 10
    verb 3
    mute 20
    pull-filter ignore "redirect-gateway"
  '';
in
{
  environment.systemPackages = with pkgs; [
    openvpn
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      ${secretNames.caCertificate} = vpnSecret;
      ${secretNames.tlsCryptV2Key} = vpnSecret;
      ${secretNames.authUserPass} = vpnSecret;
    };
  };

  systemd.services.${serviceName} = {
    description = "codeTakt staging provisioning VPN";
    documentation = [ "man:openvpn(8)" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openvpn}/bin/openvpn --config ${openvpnConfig} --status /run/${serviceName}/status 30";
      Restart = "always";
      RestartSec = "10s";
      RuntimeDirectory = serviceName;
      RuntimeDirectoryMode = "0750";
      KillSignal = "SIGTERM";
      TimeoutStopSec = "20s";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "full";
      ProtectHome = true;
      ReadWritePaths = [ "/run/${serviceName}" ];
    };
  };
}
