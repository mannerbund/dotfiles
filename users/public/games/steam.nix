{ username, ... }:
{
  programs.steam.enable = true;

  home-manager.users.${username} =
    # {lib, ...}:
    # let
    #   jail = input
    # in
    {
      home.persistence."/persist" = {
        directories = [
          ".steam"
          ".local/share/Steam"
          # ".local/share/Paradox Interactive"
        ];
      };
    };
}
