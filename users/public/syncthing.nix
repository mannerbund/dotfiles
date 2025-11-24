{ config, ... }:
let
  user = "${config.home.username}";
in
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
        "/home/${user}/Documents" = {
          label = "Documents";
          devices = [ "phone" ];
        };
        "/home/${user}/Library" = {
          label = "Library";
          devices = [ "phone" ];
        };
        "/home/${user}/Music" = {
          label = "Music";
          devices = [ "phone" ];
        };
      };
      gui = {
        theme = "black";
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
}
