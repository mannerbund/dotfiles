{
  config,
  lib,
  ...
}: {
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [""];
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      privateKey = "";
      peers = [
        {
          publicKey = "";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  # Prevent starting on boot
  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];
}
