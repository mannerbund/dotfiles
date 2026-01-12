{ lib, pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      battery_id = "BAT1";
      clear_password = true;
      brightness_up_cmd = "${lib.getExe pkgs.light} -A 10";
      brightness_down_cmd = "${lib.getExe pkgs.light} -U 10";
    };
  };
}
