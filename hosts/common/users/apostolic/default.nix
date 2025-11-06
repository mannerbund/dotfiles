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

  nixpkgs = {
    overlays = [
      inputs.niri.overlays.niri
      inputs.emacs-overlay.overlays.default
      inputs.nixpkgs-wayland.overlay
    ];
  };

  users.users.apostolic = {
    shell = pkgs.zsh;
    isNormalUser = true;
    createHome = true;
    uid = 1001;
    hashedPasswordFile = config.sops.secrets.apostolic-pass.path;
    extraGroups = ifTheyExist [
      "wheel"
      "video"
      "input"
      "systemd-journal"
      "pipewire"
      "gamemode"
      "transmission"
      "wireshark"
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

  security = {
    pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
    pam.services.swaylock = {};
    polkit.enable = true;
  };
}
