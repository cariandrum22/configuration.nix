{
  networking = {
    hostName = "redmagic";

    networkmanager.enable = true;

    # Firewall
    firewall= {
      enable = true;
      checkReversePath = false;
      allowedTCPPorts = [ 3389 ];
      # allowedUDPPorts = [ ... ];
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
