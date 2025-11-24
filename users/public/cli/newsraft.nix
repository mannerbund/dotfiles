{
  pkgs,
  config,
  ...
}:
{
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/newsraft"
    ];
  };

  home.packages = [ pkgs.newsraft ];
}
