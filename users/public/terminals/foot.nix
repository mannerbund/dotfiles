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
          clipboard-copy = "Control+w XF86Copy";
          clipboard-paste = "Control+y XF86Paste";
          scrollback-up-half-page = "Control+k";
          scrollback-down-half-page = "Control+j";
          show-urls-copy = "Control+Shift+y";
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
