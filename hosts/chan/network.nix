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
        	ct state invalid counter drop comment "early drop of invalid packets"
        	iif lo accept comment "accept loopback"
            iifname "tailscale0" accept comment "Tailscale"
            udp dport 41641 accept comment "Tailscale UDP"
        	iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
        	iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"
            udp sport 67 udp dport 68 counter accept comment "DHCP client replies"
        	ip protocol icmp counter accept comment "accept all ICMP types"
        	meta l4proto ipv6-icmp counter accept comment "accept all ICMP types"
        	udp dport 53 ip daddr 127.0.0.1 counter accept comment "UDP IPv4 local DNS"
        	tcp dport 53 ip daddr 127.0.0.1 counter accept comment "TCP IPv4 local DNS"
          	udp dport 53 ip6 daddr ::1 counter accept comment "UDP IPv6 local DNS"
        	tcp dport 53 ip6 daddr ::1 counter accept comment "TCP IPv6 local DNS"
            iifname { "enp0s31f6", "wlan0" } tcp dport 53317 accept comment "TCP LocalSend"
            iifname { "enp0s31f6", "wlan0" } udp dport 53317 accept comment "UDP LocalSend"
            iifname { "enp0s31f6", "wlan0" } ip daddr 224.0.0.0/4 udp dport 53317 accept
            #iifname { "enp0s31f6", "wlan0" } tcp dport 1200 accept comment "Python TCP HTTP server"
            #iifname { "enp0s31f6", "wlan0" } udp dport 1200 accept comment "Python UDP"
            tcp dport 58530 iifname "tailscale0" accept comment "accept Tailscale SSH"
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
            tcp dport {80,443,2053,2083,2087,2096,8443} queue num 220 comment "TCP Zapret QNUM"
            udp dport {443,19294-19344,50000-50100} queue num 220 comment "UDP Zapret QNUM"
          }
        }
      '';

    };
  };

  systemd = {
    network = {
      enable = true;
      wait-online.enable = false;
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
    services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
  };

  boot.initrd.systemd.network.wait-online.enable = false;

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
    tailscale = {
      enable = true;
      port = 41641;
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
          ab.chatgpt.com 45.155.204.190
          ab.chatgpt.com 37.230.192.51
          chatgpt.com 45.155.204.190
          chatgpt.com 37.230.192.51
          operator.chatgpt.com 45.155.204.190
          operator.chatgpt.com 37.230.192.51
          sora.chatgpt.com 45.155.204.190
          sora.chatgpt.com 37.230.192.51
          webrtc.chatgpt.com 45.155.204.190
          webrtc.chatgpt.com 37.230.192.51
          www.chatgpt.com 45.155.204.190
          www.chatgpt.com 37.230.192.51

          android.chat.openai.com 45.155.204.190
          android.chat.openai.com 37.230.192.51
          api.openai.com 45.155.204.190
          api.openai.com 37.230.192.51
          auth.openai.com 45.155.204.190
          auth.openai.com 37.230.192.51
          auth0.openai.com 45.155.204.190
          auth0.openai.com 37.230.192.51
          blog.openai.com 45.155.204.190
          blog.openai.com 37.230.192.51
          cdn.openai.com 45.155.204.190
          cdn.openai.com 37.230.192.51
          chat.openai.com 45.155.204.190
          chat.openai.com 37.230.192.51
          community.openai.com 45.155.204.190
          community.openai.com 37.230.192.51
          help.openai.com 45.155.204.190
          help.openai.com 37.230.192.51
          ios.chat.openai.com 45.155.204.190
          ios.chat.openai.com 37.230.192.51
          openai.com 45.155.204.190
          openai.com 37.230.192.51
          platform.api.openai.com 45.155.204.190
          platform.api.openai.com 37.230.192.51
          platform.openai.com 45.155.204.190
          platform.openai.com 37.230.192.51
          tcr9i.chat.openai.com 45.155.204.190
          tcr9i.chat.openai.com 37.230.192.51
          videos.openai.com 45.155.204.190
          videos.openai.com 37.230.192.51
          www.openai.com 45.155.204.190
          www.openai.com 37.230.192.51
          arena.openai.com 45.155.204.190
          arena.openai.com 37.230.192.51
          beta.api.openai.com 45.155.204.190
          beta.api.openai.com 37.230.192.51
          beta.openai.com 45.155.204.190
          beta.openai.com 37.230.192.51
          contest.openai.com 45.155.204.190
          contest.openai.com 37.230.192.51
          debate-game.openai.com 45.155.204.190
          debate-game.openai.com 37.230.192.51
          discuss.openai.com 45.155.204.190
          discuss.openai.com 37.230.192.51
          gym.openai.com 45.155.204.190
          gym.openai.com 37.230.192.51
          jukebox.openai.com 45.155.204.190
          jukebox.openai.com 37.230.192.51
          labs.openai.com 45.155.204.190
          labs.openai.com 37.230.192.51
          microscope.openai.com 45.155.204.190
          microscope.openai.com 37.230.192.51
          spinningup.openai.com 45.155.204.190
          spinningup.openai.com 37.230.192.51
          universe.openai.com 45.155.204.190
          universe.openai.com 37.230.192.51
        '';
      };
    };
  };
}
