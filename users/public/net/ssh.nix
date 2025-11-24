{ username, ... }:
{

  services.openssh = {
    enable = true;
    ports = [ 58530 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "${username}" ];
    };
  };

  # TODO: rewrite, this is host specific
  home-manager.users.${username} = {
    programs.ssh = {
      enable = true;
      extraConfig = "
        Host chan-wlan
        Hostname 192.168.31.200
        Port 22
        User ${username}

      Host chan-eth
        Hostname 192.168.31.100
        Port 22
        User ${username}

      Host github.com
       Hostname ssh.github.com
       Port 443
    ";
    };
  };

  services.fail2ban.enable = true;
}
