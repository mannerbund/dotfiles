{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = false;
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    targets = {
      firefox.enable = true;
      vim.enable = true;
      gnome.enable = true;
      qt.enable = true;
      gtk.enable = true;
    };
  };
}
