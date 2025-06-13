{
  services.openssh = {
    enable = true;
    ports = [58530];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["apostolic"];
    };
  };

  services.fail2ban.enable = true;
}
