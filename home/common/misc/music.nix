{
  pkgs,
  config,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/mpd"
      ".local/share/beets"
    ];
  };

  services.mpd = {
    enable = true;
    network = {
      listenAddress = "127.0.0.1";
      port = 6601;
    };
    musicDirectory = "${config.home.homeDirectory}/Music";
    dataDir = "${config.home.homeDirectory}/.local/share/mpd";
    dbFile = "${config.home.homeDirectory}/.local/share/mpd/database.db";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };

  programs = {
    beets = {
      enable = true;
      mpdIntegration.enableStats = true;
      mpdIntegration.host = "127.0.0.1";
      mpdIntegration.port = 6601;
      settings = {
        directory = "${config.home.homeDirectory}/Music/Albums";
        library = "${config.home.homeDirectory}/.local/share/beets/musiclibrary.db";
      };
    };
  };
}
