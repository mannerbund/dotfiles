{
  services = {
    timesyncd.enable = false;
    ntpd-rs = {
      enable = true;
      settings = {
        observability.log-level = "warn";
      };
    };
  };
}
