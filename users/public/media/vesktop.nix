{ username, ... }:
{
  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".config/vesktop"
      ];
    };
    programs.vesktop = {
      enable = true;
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        disableMinSize = true;
        notifyAboutUpdates = false;
        plugins = {
          FakeNitro = {
            enabled = true;
          };
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
        };
        useQuickCss = true;
      };
    };
  };
}
