{
  systemd.network = {
    enable = true;
    netdevs = {
      "5-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/var/lib/wireguard/wireguard-privkey";
        };
        wireguardPeers = [
          {
            PublicKey = "";
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."wg0" = {
      matchConfig.Name = "wg0";
      address = [ "" ];
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;  # Disable IPv6 autoconfig
      };
    };
  };
}
