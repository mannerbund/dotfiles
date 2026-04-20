{
  username,
  ...
}:
{
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xdg-utils ];
      xdg = {
        enable = true;
        mimeApps.enable = true;
        userDirs = {
          enable = true;
          setSessionVariables = false;
          createDirectories = false;
        };
      };
    };
}
