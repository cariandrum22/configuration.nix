{
  networking = {
    hostName = "eto";

    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [ 445 139 ];
      allowedUDPPorts = [ 137 138 ];
    };

    # Hosts
    extraHosts = ''
      # For the development environment of codeTakt Inc.
      127.0.0.1 schooltakt.test
      127.0.0.1 node1.schooltakt.test
      127.0.0.1 node2.schooltakt.test
      127.0.0.1 webpack.schooltakt.test
      127.0.0.1 portal.test
      127.0.0.1 org1.portal.test
      # ids
      20.27.6.128     idp1.stg-ed-cl.com
      20.27.6.128     ds.stg-ed-cl.com
      20.27.6.128     api.stg-ed-cl.com
      20.27.6.128     atrp1.stg-ed-cl.com
      # portal
      20.78.119.192   push.stg-ed-cl.com
      # sp1
      20.78.119.241   stg-ed-cl.com
      20.78.119.241   parent.stg-ed-cl.com
      20.78.119.241   admportal.stg-ed-cl.com
    '';
  };
}
