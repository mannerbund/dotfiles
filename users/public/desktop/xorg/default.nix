{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "ctrl:nocaps,grp:win_space_toggle";
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
      dpi = 120; # TODO: move it to host
    };
  };
}
