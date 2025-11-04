{
  config,
  pkgs,
  ...
}: {
  environment.persistence."/persist".directories = [
    "${config.services.transmission.home}"
  ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
  };
}
