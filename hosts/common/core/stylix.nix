{
  inputs,
  pkgs,
  ...
}: let
  theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  wallpaper = pkgs.runCommand "image.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .palette.base00 ${theme})
    ${pkgs.imagemagick}/bin/magick -size 1920x1080 xc:$COLOR $out
  '';
in {
  imports = [inputs.stylix.nixosModules.stylix];

  environment.systemPackages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts
    iosevka
    font-awesome
  ];

  stylix = {
    enable = true;
    homeManagerIntegration.followSystem = true;
    image = wallpaper;
    base16Scheme = theme;
    polarity = "dark";
    fonts.sizes = {
      applications = 14;
      desktop = 14;
      popups = 14;
      terminal = 16;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
      };

      monospace = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };

      emoji = {
        package = pkgs.nerd-fonts.symbols-only;
        name = "Noto Sans Symbols";
      };
    };
  };
}
