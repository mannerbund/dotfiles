{
  config,
  pkgs,
  ...
}:
{
  home.persistence."/persist" = {
    directories = [
      ".config/weechat"
      ".local/share/weechat"
    ];
  };

  home.packages = [ pkgs.weechat ];
}
