{ username, ... }:
{
  programs.steam.enable = true;

  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".steam"
        ".local/share/Steam"
        # ".local/share/Paradox Interactive"
      ];
    };
  };
}
