{
  services.zapret = {
    enable = true;
    configureFirewall = false;
    qnum = 220;
    params = [
      "--filter-tcp=443 --dpi-desync=syndata,multisplit --dpi-desync-split-pos=method+2"
    ];
  };
}
