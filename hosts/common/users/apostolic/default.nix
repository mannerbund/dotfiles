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

  services.getty.autologinUser = "apostolic";

  home-manager.users.apostolic = import ../../../../home/apostolic/${config.networking.hostName}.nix;

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd niri-session";
      user = "apostolic";
    };
  };

  services.upower.enable = true;
}
