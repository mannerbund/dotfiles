{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../common/core

    ../common/misc/niri.nix
    ../common/misc/bemenu.nix
    ../common/misc/stylix.nix
    ../common/misc/music.nix
    ../common/misc/texlive.nix
    ../common/misc/imv.nix
    ../common/misc/direnv.nix
    ../common/misc/zathura.nix
    ../common/misc/yt-dlp.nix
    ../common/misc/mpv.nix
    ../common/misc/librewolf.nix
    ../common/misc/syncthing.nix
    ../common/misc/profanity.nix
    ../common/misc/lf.nix
    ../common/misc/weechat.nix
    ../common/misc/newsraft.nix
  ];

  home = {
    username = lib.mkDefault "apostolic";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/Anki2"
      ".local/state/wireplumber"
    ];
  };

  home.packages = with pkgs; [
    anki-bin
    xdg-utils
    transmission_4-qt6
    sc-im
    libnotify
  ];

  home.sessionVariables = {
    LESS = "-R --mouse";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    ANKI_WAYLAND = "1";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
