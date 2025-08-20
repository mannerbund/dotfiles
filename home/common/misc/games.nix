{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/lutris"
      ".local/share/Games"
    ];
  };

  home.packages = with pkgs; [
    lutris
    wineWowPackages.waylandFull
    winetricks
  ];
}
