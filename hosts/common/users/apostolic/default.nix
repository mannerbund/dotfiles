{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;
  users.users.apostolic = {
    isNormalUser = true;
    createHome = true;
    uid = 1001;
    hashedPasswordFile = config.sops.secrets.apostolic_passwd.path;
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

  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
  security.pam.services.swaylock = {};
  security.polkit.enable = true;

  services.logind = {
    powerKey = "poweroff";
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchDocked=ignore
    '';
  };

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

  services.dbus.packages = [pkgs.gcr]; # for pinentry-gnome3

  services.upower.enable = true;
}
