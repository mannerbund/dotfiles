{ username, ... }:
{
  home-manager.users.${username} =
    { config, ... }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/state/syncthing"
        ];
      };

      services.syncthing = {
        enable = true;
        settings = {
          devices = {
            phone = {
              name = "Pixel";
              id = "SB5OW4W-6LJXBFW-6CYZ7WG-RO643HZ-44UAZ67-DB4AELP-TAGLOUU-OS3G7QM";
            };
          };
          folders = {
            documents = {
              path = "~/Documents";
              devices = [ "phone" ];
            };
            library = {
              path = "~/Library";
              devices = [ "phone" ];
            };
            music = {
              path = "~/Music";
              devices = [ "phone" ];
            };
          };
          options = {
            localAnnounceEnabled = true;
            progressUpdateIntervalS = false;
            globalAnnounceEnabled = false;
            relaysEnabled = false;
            natEnabled = false;
          };
        };
      };
    };
}
