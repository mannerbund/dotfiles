{
  xdg.mimeApps.defaultApplications = {
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/*" = "imv.desktop";
  };

  programs.imv = {
    enable = true;
    settings = {
      binds = {
        "<Shift+J>" = "zoom -2";
        "<Shift+K>" = "zoom 2";
        "<Ctrl+p>" = "prev";
        "<Ctrl+n>" = "next";
      };
    };
  };
}
