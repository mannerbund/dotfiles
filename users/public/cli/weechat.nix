{
  username,
  ...
}:
{

  home-manager.users.${username} =
    { pkgs, ... }:
    {

      home.persistence."/persist" = {
        directories = [
          ".config/weechat"
          ".local/share/weechat"
        ];
      };

      home.packages = with pkgs; [
        (weechat.override {
          configure =
            { ... }:
            {
              scripts = with pkgs.weechatScripts; [
                autosort
                colorize_nicks
              ];
            };
        })
      ];
    };
}
