{pkgs, ...}: {
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd"; # "scx_rustland" "scx_lavd"
}
