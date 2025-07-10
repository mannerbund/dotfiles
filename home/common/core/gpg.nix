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
    pinentry.package = pkgs.wayprompt;
    pinentry.program = "pinentry-wayprompt";
    defaultCacheTtl = 86400;
  };

  programs.gpg.enable = true;
}
