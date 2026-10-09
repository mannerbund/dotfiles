{ username, ... }:
{
  home-manager.users.${username} = {
    programs.bemenu = {
      enable = true;
      settings = {
        ignorecase = true;
        prompt = "open";
        border = 2;
        line-height = 40;
        # cw = 2;
        # hp = 10;
      };
    };
  };
}
