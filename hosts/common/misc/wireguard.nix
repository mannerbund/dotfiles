{lib, ...}: {
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["192.168.6.112/32"];
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      privateKey = "6HXTLZ4MXLwi6s2VKzsrgx4G4PYjPieBubqFzpcTB1g=";
      peers = [
        {
          publicKey = "OxuczEDPtabvj+hACzXuUpvRIs0IVWyrHzT4j0qcHj8=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "lv1.vpnjantit.com:1024";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  # Prevent starting on boot
  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];
}
