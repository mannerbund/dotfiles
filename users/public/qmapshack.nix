{ username, ... }:
{

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.persistence."/persist" = {
        directories = [
          ".QMapShack"
        ];
      };

      home.packages = [ pkgs.qmapshack ];
    };
}
