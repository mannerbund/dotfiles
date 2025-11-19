{
  pkgs,
  lib,
  config,
  ...
}: {
  console = {
    packages = [pkgs.terminus_font];
    font = "ter-v22b";
    useXkbConfig = lib.mkIf (config.services.xserver.enable) true;
  };
}
