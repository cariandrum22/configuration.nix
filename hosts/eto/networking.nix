{
  networking = {
    hostName = "eto";

    networkmanager = {
      enable = true;
      wifi.powersave = false;
      unmanaged = [
        "interface-name:docker0"
        "interface-name:br-*"
        "interface-name:veth*"
        "interface-name:virbr*"
      ];
    };

    # Firewall
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        445
        139
        5432
      ];
      allowedUDPPorts = [
        137
        138
      ];
    };
  };
}
