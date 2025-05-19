{
  #inputs,
  #lib,
  #config,
  ...
}: {
  #programs.ssh.startAgent = true;
  #services.openssh = {
  #  enable = true;
  #  settings = {
  #    PasswordAuthentication = true;
  #    PermitRootLogin = "no";
  #    AcceptEnv = "WAYLAND_DISPLAY";
  #    X11Forwarding = true;
  #  };
  #};

  programs.ssh = {
    startAgent = true;
  };
}
