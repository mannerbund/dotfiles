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
    base16Scheme = theme;
    image = wallpaper;
    polarity = "dark";
    fonts.sizes = {
      terminal = 16;
      desktop = 12;
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
