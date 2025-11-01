{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/zathura"
    ];
  };

  home.packages = [pkgs.papers];

  xdg.mimeApps.defaultApplications = {
    "application/epub+zip" = "org.pwmt.zathura.desktop";
    "application/pdf" = "org.gnome.Papers.desktop";
    "application/vnd.comicbook+zip" = "org.gnome.Papers.desktop";
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
      font = "DejaVu Sans 16";
    };
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      g = "goto top";
      f = "toggle_fullscreen";
      "[fullscreen] f" = "toggle_fullscreen";
      "[fullscreen] u" = "scroll half-up";
      "[fullscreen] d" = "scroll half-down";
      "[fullscreen] D" = "toggle_page_mode";
      "[fullscreen] K" = "zoom in";
      "[fullscreen] J" = "zoom out";
      "[fullscreen] i" = "recolor";
      "[fullscreen] g" = "goto top";
    };
  };
}
