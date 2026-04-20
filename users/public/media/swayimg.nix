{ username, ... }:
{
  home-manager.users.${username} = {

    xdg.mimeApps.defaultApplications = {
      "image/jpeg" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/*" = "swayimg.desktop";
    };

    programs.swayimg = {
      enable = true;
    };
  };
}
