{
  config,
  pkgs,
  ...
}:
{
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/weechat"
      ".local/share/weechat"
    ];
  };

  home.packages = [ pkgs.weechat ];
}
