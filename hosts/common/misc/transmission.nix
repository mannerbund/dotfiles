{config, ...}: {
  environment.persistence."/persist".directories = [
    "${config.services.transmission.home}"
  ];

  services.transmission = {
    enable = true;
  };
}
