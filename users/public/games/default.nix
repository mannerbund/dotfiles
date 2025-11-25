{
  username,
}:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.${username}.extraGroups = [ "gamemode" ];

  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/lutris"
          ".local/share/Games"
        ];
      };

      home.packages = with pkgs; [
        lutris
        wineWowPackages.waylandFull
        winetricks
      ];
    };
}
