{
  programs.ssh = {
    enable = true;
    extraConfig = "
      Host chan-wlan
        Hostname 192.168.31.200
        Port 22
        User apostolic

      Host chan-eth
        Hostname 192.168.31.100
        Port 22
        User apostolic

      Host github.com
       Hostname ssh.github.com
       Port 443
    ";
  };
}
