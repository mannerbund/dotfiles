{
  username,
  ...
}:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.${username}.extraGroups = [ "gamemode" ];

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.persistence."/persist" = {
        directories = [
          ".local/share/lutris"
          ".local/share/Games"
          ".config/StardewValley"
        ];
      };

      home.packages = with pkgs; [
        wineWow64Packages.waylandFull
        winetricks
        lutris
      ];
    };
}
