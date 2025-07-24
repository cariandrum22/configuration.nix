{
  networking = {
    hostName = "eto";

    networkmanager.enable = true;

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
