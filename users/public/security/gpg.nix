{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      pkgs,
      ...
    }:
    {
      home.persistence."/persist" = {
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
