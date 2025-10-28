{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/Anki2"
    ];
  };

  home.sessionVariables = {
    ANKI_WAYLAND = "1";
  };

  programs.anki = {
    enable = true;
    theme = "dark";
    addons = [pkgs.ankiAddons.anki-connect];
  };
}
