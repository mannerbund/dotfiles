{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [ ".gnupg" ];
      };

      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        pinentry.package = pkgs.pinentry-gtk2;
        pinentry.program = "pinentry-gtk2";
        defaultCacheTtl = 86400;
      };

      programs.gpg.enable = true;
    };
}
