{
  inputs,
  pkgs,
  config,
  ...
}: {
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
    image = config.lib.stylix.pixel "base00";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
