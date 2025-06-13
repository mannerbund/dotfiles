{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".gnupg"];
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
    pinentry.program = "pinentry-gnome3";
    defaultCacheTtl = 86400;
  };

  programs.gpg.enable = true;
}
