{
  pkgs,
  config,
  ...
}:
{
  home.persistence."/persist" = {
    directories = [
      ".local/share/newsraft"
    ];
  };

  home.packages = [ pkgs.newsraft ];
}
