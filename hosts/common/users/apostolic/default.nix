{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  users.users.apostolic = {
    shell = pkgs.zsh;
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

  home-manager = {
    users.apostolic = import ../../../../home/apostolic;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  services = {
    upower.enable = true;
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "niri-session";
          user = "apostolic";
        };
        default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd niri-session";
      };
    };
  };

  sops.secrets.apostolic_passwd.neededForUsers = true;

  security = {
    pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
    pam.services.swaylock = {};
    polkit.enable = true;
  };
}
