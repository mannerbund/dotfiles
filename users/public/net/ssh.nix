{ username, ... }:
{
  home-manager.users.${username} = {
    programs.ssh = {
      enable = true;
      settings = {
        "github.com" = {
          hostname = "ssh.github.com";
          port = 443;
        };
      };
    };
  };
}
