{ username, ... }:
{
  home-manager.users.${username} =
    { config, ... }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/state/mpv"
        ];
      };

      programs.mpv = {
        enable = true;
        config = {
          sub-scale = 1.2;
          sub-auto = "fuzzy";
          sub-bold = true;
          volume = 50;
          ytdl-format = "bestvideo+bestaudio";
          keep-open = true;
          save-position-on-quit = true;
        };
      };
    };
}
