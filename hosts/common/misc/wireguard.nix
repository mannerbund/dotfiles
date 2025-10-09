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
      address = [""];
      dns = ["127.0.0.1"];
      privateKeyFile = "/var/lib/wireguard/wireguard-privkey";

      peers = [
        {
          publicKey = "";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];
}
