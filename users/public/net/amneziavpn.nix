{ username, ... }:
{
  services.resolved.enable = true;
  programs.amnezia-vpn.enable = true;

  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".config/AmneziaVPN.ORG"
      ];
    };
  };
}
