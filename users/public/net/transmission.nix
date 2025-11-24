{
  config,
  pkgs,
  username,
}:
{
  environment.persistence."/persist".directories = [
    "${config.services.transmission.home}"
  ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
  };

  users.users.${username}.extraGroups = [ "transmission" ];
}
