{ username, ... }:
{
  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/mpd"
          ".local/share/beets"
        ];
      };

      home.packages = [ pkgs.mpc ];

      services.mpd = {
        enable = true;
        network = {
          listenAddress = "localhost";
          port = 6600;
        };
        musicDirectory = "${config.home.homeDirectory}/Music";
        dataDir = "${config.home.homeDirectory}/.local/share/mpd";
        extraConfig = ''
          audio_output {
              type "pipewire"
              name "PipeWire Sound Server"
            }
            audio_output {
                type	"fifo"
                name	"my_fifo"
                path	"/tmp/mpd.fifo"
                format	"44100:16:2"
            }
        '';
      };

      programs = {
        beets = {
          enable = true;
          mpdIntegration.enableStats = true;
          mpdIntegration.host = config.services.mpd.network.listenAddress;
          mpdIntegration.port = config.services.mpd.network.port;
          settings = {
            directory = "${config.home.homeDirectory}/Music/Albums";
            library = "${config.home.homeDirectory}/.local/share/beets/musiclibrary.db";
          };
        };
      };
    };
}
