{
  networking = {
    hostName = "chan";
    useNetworkd = true;
    nameservers = [ "127.0.0.1" ];
    firewall = {
      allowedTCPPorts = [
        51413
        53317
        22000
      ];
      allowedUDPPorts = [
        51413
        53317
        22000
      ];
    };
    useDHCP = false;
    wireless.iwd.enable = true;
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-wireless" = {
        name = "wlan0";
        DHCP = "yes";
        dhcpConfig.UseDNS = false;
      };
      "20-ethernet" = {
        name = "enp0s31f6";
        DHCP = "yes";
        dhcpConfig.UseDNS = false;
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

}
