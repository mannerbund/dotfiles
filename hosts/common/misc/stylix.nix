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
    noto-fonts-cjk-sans
    twemoji-color-font
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    image = ../../../dorohedoro.jpg;
    targets = {
      console.enable = true;
      nixos-icons.enable = true;
    };
  };
}
