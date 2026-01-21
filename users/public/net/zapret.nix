let
  LISTS = "/var/lib/zapret/lists";
  BIN = "/var/lib/zapret/bin";
  GameFilter = "1024-65535";
in
{
  services.zapret = {
    enable = true;
    httpSupport = false;
    udpSupport = true;
    udpPorts = [
      "443"
      "1024:65535"
    ];
    configureFirewall = true;
    params = [
      ''--filter-tcp=${GameFilter} --dpi-desync=syndata --dpi-desync-fake-syndata="${BIN}/tls_clienthello_4pda_to.bin" --new''
      ''--filter-udp=443 --hostlist="${LISTS}/list-general.txt" --hostlist-exclude="${LISTS}/list-exclude.txt" --ipset-exclude="${LISTS}/ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="${BIN}/quic_initial_www_google_com.bin" --new''
      "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new"
      "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=www.google.com --new"
      ''--filter-tcp=443 --hostlist="${LISTS}/list-google.txt" --ip-id=zero --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts --dpi-desync-hostfakesplit-mod=host=www.google.com --new''
      ''--filter-tcp=80,443 --hostlist="${LISTS}/list-general.txt" --hostlist-exclude="${LISTS}/list-exclude.txt" --ipset-exclude="${LISTS}/ipset-exclude.txt" --dpi-desync=hostfakesplit --dpi-desync-repeats=4 --dpi-desync-fooling=ts,md5sig --dpi-desync-hostfakesplit-mod=host=ozon.ru --new''
      ''--filter-udp=443 --ipset="${LISTS}/ipset-all2.txt" --hostlist-exclude="${LISTS}/list-exclude.txt" --ipset-exclude="${LISTS}/ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="${BIN}/quic_initial_www_google_com.bin" --new''
      ''--filter-tcp=80,443,${GameFilter} --ipset="${LISTS}/ipset-all2.txt" --hostlist-exclude="${LISTS}/list-exclude.txt" --ipset-exclude="${LISTS}/ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=654 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="${BIN}/tls_clienthello_max_ru.bin" --dpi-desync-fake-tls="${BIN}/tls_clienthello_max_ru.bin" --new''
      ''--filter-udp=${GameFilter} --ipset="${LISTS}/ipset-all2.txt" --ipset-exclude="${LISTS}/ipset-exclude.txt" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="${BIN}/quic_initial_www_google_com.bin" --dpi-desync-cutoff=n2''
    ];
  };
}
