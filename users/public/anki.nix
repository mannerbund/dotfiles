{
  config,
  pkgs,
  username,
  ...
}:
{
  home-manager.users.${username} = {

    home.persistence."/persist" = {
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
      addons = [ pkgs.ankiAddons.anki-connect ];
    };
  };
}
