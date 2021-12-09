{
  networking = {
    hostName = "eto";

    networkmanager.enable = true;

    # Firewall
    firewall= {
      enable = true;
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [ 445 139 3389 ];
      allowedUDPPorts = [ 137 138 ];
    };

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
