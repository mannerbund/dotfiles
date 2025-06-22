{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  fonts.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.symbols-only
    iosevka
    aporetic
    noto-fonts-emoji
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    image = ../gruvbox_city.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
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
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    targets = {
      console.enable = true;
      nixos-icons.enable = true;
    };
  };
}
