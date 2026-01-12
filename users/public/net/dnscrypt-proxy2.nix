{
  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = true;
    settings = {
      listen_addresses = [ "127.0.0.1:53" ];
      require_dnssec = true;
      require_nofilter = true;
      require_nolog = true;

      block_ipv6 = true;
      ipv6_servers = false;

      cache_size = 2048;
      cache_min_ttl = 3600;
      cache_max_ttl = 86400;
      cache_neg_min_ttl = 60;
      cache_neg_max_ttl = 300;

      server_names = [ "NextDNS-c8df27" ];

      static = {
        "NextDNS-c8df27" = {
          stamp = "sdns://AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8HL2M4ZGYyNw";
        };
      };
    };
  };
}
