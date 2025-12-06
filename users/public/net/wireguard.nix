{ lib, ... }:
{
  environment.persistence."/persist".directories = [
    "/var/lib/wireguard"
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ ];
      dns = [ ];
      privateKeyFile = "";
      peers = [
        {
          publicKey = "";
          allowedIPs = [  ];
          endpoint = "";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
}
