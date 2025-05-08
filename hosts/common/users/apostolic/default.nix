{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.apostolic = {
    isNormalUser = true;
    createHome = true;
    uid = 1001;
    hashedPasswordFile = config.sops.secrets.passwd.path;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "wheel"
      "video"
      "input"
      "systemd-journal"
      "pipewire"
      "gamemode"
    ];
  };

  home-manager.users.apostolic = import ../../../../home/apostolic;

  security.pam.services.swaylock = {};
  security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "niri-session";
        user = "apostolic";
      };
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --remember --cmd niri-session";
    };
  };

  services.dbus.packages = [ pkgs.gcr ];  # for pinentry-gnome3

  services.upower.enable = true;
}
