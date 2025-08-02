{lib, ...}: {
  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/wireguard";
      user = "root";
      group = "root";
      mode = "u=rwx,g=,o=";
    }
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["192.168.6.217/32"];
      dns = ["127.0.0.1"];
      privateKeyFile = "/var/lib/wireguard/wireguard-privkey";

      peers = [
        {
          publicKey = "FeveuhtZzyHHrza13sIMnsywtRYXZpMDTCnQ1NXbsA8=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "109.206.241.94:1024";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];
}
