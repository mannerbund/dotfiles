{ username, ... }:
{
  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".local/share/direnv"
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
