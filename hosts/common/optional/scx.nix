{pkgs, ...}: {
  services.scx.enable = true;
  services.scx.scheduler = "scx_rustland"; # "scx_rustland" "scx_lavd"
}
