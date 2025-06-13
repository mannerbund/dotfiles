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
    ../common/misc/irssi.nix
  ];

  home = {
    username = lib.mkDefault "apostolic";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/nix"
      ".local/share/iwctl"
      ".local/share/qBittorrent"
      ".local/share/TelegramDesktop"
      ".local/share/Anki2"
      ".local/state/syncthing"
      ".local/state/wireplumber"
    ];
  };

  home.packages = with pkgs; [
    libreoffice-qt
    qbittorrent-enhanced
    xz
    anki-bin
    clang
    xdg-utils
    nicotine-plus
    telegram-desktop
    syncthing
  ];

  home.sessionVariables = {
    LESS = "-R --mouse";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    ANKI_WAYLAND = "1";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.11";
}
