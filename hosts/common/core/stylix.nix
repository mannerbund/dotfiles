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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    targets = {
      console.enable = true;
      nixos-icons.enable = true;
    };
  };
}
