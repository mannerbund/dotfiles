{
  username,
  ...
}:
{
  home-manager.users.${username} =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.xdg-utils ];
      xdg = {
        enable = true;
        mimeApps.enable = true;
        userDirs = {
          enable = true;
          createDirectories = false;
          desktop = "${config.home.homeDirectory}/Desktop";
          documents = "${config.home.homeDirectory}/Documents";
          download = "${config.home.homeDirectory}/Downloads";
          music = "${config.home.homeDirectory}/Music";
          pictures = "${config.home.homeDirectory}/Pictures";
          videos = "${config.home.homeDirectory}/Videos";
        };
      };
    };
}
