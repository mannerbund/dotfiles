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
        ];
      };

      home.packages = with pkgs; [
        lutris
        wineWowPackages.stable
        winetricks
        gamescope
        # wineWowPackages.waylandFull
      ];
    };
}
