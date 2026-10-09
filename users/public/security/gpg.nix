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
        pinentry.package = pkgs.pinentry-qt;
        pinentry.program = "pinentry-qt";
        defaultCacheTtl = 86400;
      };

      programs.gpg.enable = true;
    };
}
