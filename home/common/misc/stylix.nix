{pkgs, ...}: {
  home.packages = [pkgs.dconf];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
    };
    fonts = {
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 16;
      };
      serif = {
        name = "Dejavu Serif";
      };
      sansSerif = {
        name = "Dejavu Sans";
      };
      monospace = {
        name = "Aporetic Sans Mono";
      };
      emoji = {
        name = "Noto Color Emoji";
      };
    };
    targets = {
      firefox.enable = true;
      vim.enable = true;
      gnome.enable = true;
      qt.enable = true;
      gtk.enable = true;
      tmux.enable = true;
      waybar.enable = true;
      mpv.enable = true;
      bemenu.enable = true;
      emacs.enable = false;
      fzf.enable = true;
      bat.enable = true;
      zathura.enable = true;
      foot.enable = true;
      mako.enable = true;
      swaylock = {
        enable = true;
        useWallpaper = true;
      };
    };
  };
}
