{ pkgs, ... }:
{
  networking = {
    hostName = "chan";
    enableIPv6 = true;
    useNetworkd = true;
    wireless.iwd.enable = true;
    resolvconf.useLocalResolver = true;
    firewall.enable = false;
    useDHCP = false;
    nftables = {
      enable = true;
      ruleset = ''
        flush ruleset

        table inet filter {
          chain input {
        	type filter hook input priority 0; policy drop;
        	ct state {established, related} counter accept comment "accept all connections related to connections made by us"
        	icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept
        	ct state invalid counter drop comment "early drop of invalid packets"
        	iif lo accept comment "accept loopback"
        	iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
        	iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"
            udp sport 67 udp dport 68 counter accept comment "DHCP client replies"
        	ip protocol icmp counter accept comment "accept all ICMP types"
        	meta l4proto ipv6-icmp counter accept comment "accept all ICMP types"
        	udp dport 53 ip daddr 127.0.0.1 counter accept comment "UDP IPv4 local DNS"
        	tcp dport 53 ip daddr 127.0.0.1 counter accept comment "TCP IPv4 local DNS"
          	udp dport 53 ip6 daddr ::1 counter accept comment "UDP IPv6 local DNS"
        	tcp dport 53 ip6 daddr ::1 counter accept comment "TCP IPv6 local DNS"
            iifname { "enp0s31f6", "wlan0" } tcp dport 53317 accept
            iifname { "enp0s31f6", "wlan0" } udp dport 53317 accept
            iifname { "enp0s31f6", "wlan0" } ip daddr 224.0.0.0/4 udp dport 53317 accept
            # tcp dport 58530 counter accept comment "accept SSH"
            tcp dport 22000 accept comment "Syncthing"
            udp dport { 22000, 21027 } accept comment "Syncthing"
        	counter comment "count dropped packets"
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
            counter comment "count dropped packets"
          }


          chain output {
            type filter hook output priority 0; policy accept;
            oifname "lo" accept
            tcp dport {80, 443, 1024-65535} queue num 220 comment "TCP Zapret QNUM"
            udp dport {443, 1024-65535} queue num 220 comment "UDP Zapret QNUM"
          }
        }
      '';

    };
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

  services = {
    openssh = {
      enable = true;
      ports = [ 58530 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        UseDns = true;
      };
    };

    dnscrypt-proxy = {
      enable = true;
      upstreamDefaults = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];
        require_dnssec = true;
        require_nofilter = true;
        require_nolog = true;
        doh_servers = true;
        block_ipv6 = false;

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
        cloaking_rules = pkgs.writeText "cloaking-rules.txt" ''

        '';
      };
    };
  };
}
