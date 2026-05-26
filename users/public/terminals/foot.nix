{
  username,
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    aporetic
  ];

  home-manager.users.${username} = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Aporetic Sans Mono:size=14";
        };
        key-bindings = {
          clipboard-copy = "Alt+c XF86Copy";
          clipboard-paste = "Alt+v XF86Paste";
          scrollback-up-half-page = "Alt+k";
          scrollback-down-half-page = "Alt+j";
          show-urls-copy = "Alt+y";
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
