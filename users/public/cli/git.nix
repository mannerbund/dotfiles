{
  username,
  ...
}:
{
  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "mannerbund";
          email = "apostalimus@gmail.com";
        };
        init.defaultBranch = "main";
      };
      signing.format = "openpgp";
      ignores = [
        ".direnv"
      ];
    };
  };
}
