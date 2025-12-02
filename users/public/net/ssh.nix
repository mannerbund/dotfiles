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

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3iQZ1SnReJfbr9u3LMJPm4Sfy6Mz5NlndCE/Zpw4tX u0_a228@localhost"
  ];

  home-manager.users.${username} = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "ssh.github.com";
          port = 443;
        };
        "pixel" = {
          hostname = "192.168.31.240";
          user = "pixel";
          port = 58530;
        };
      };
    };
  };

  services.fail2ban.enable = true;
}
