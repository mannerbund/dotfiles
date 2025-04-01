{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
    };
  };
}
