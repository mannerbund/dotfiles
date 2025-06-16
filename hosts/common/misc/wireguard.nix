{lib, ...}: {
  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/wireguard";
      user = "root";
      group = "keys";
      mode = "u=rwx,g=,o=";
    }
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["192.168.6.58/32"];
      dns = ["127.0.0.1"];
      privateKeyFile = "/var/lib/wireguard/wireguard-privkey";

      peers = [
        {
          publicKey = "OxuczEDPtabvj+hACzXuUpvRIs0IVWyrHzT4j0qcHj8=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "92.118.170.240:1024";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];
}
