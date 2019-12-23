{
  networking = {
    hostName = "redmagic";

    # It's under the control of the Wicd.
    wireless.enable = false;
    useDHCP = false;

    # Enable Wireless interface connection daemon.
    wicd.enable = true;

    # Firewall
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 3389 ];
    # firewall.allowedUDPPorts = [ ... ];

    # Hosts
    extraHosts =
      ''
        # For the development environment of codeTakt Inc.
        127.0.0.1 schooltakt.test
        127.0.0.1 node1.schooltakt.test
        127.0.0.1 node2.schooltakt.test
        127.0.0.1 webpack.schooltakt.test
        127.0.0.1 portal.test
        127.0.0.1 org1.portal.test
      '';
  };
}
