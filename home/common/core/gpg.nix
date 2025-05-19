{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
    pinentry.program = "pinentry-gnome3";
    defaultCacheTtl = 86400;
  };

  programs.gpg.enable = true;
}
