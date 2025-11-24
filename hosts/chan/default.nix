{ pkgs, ... }:
{
  imports = [
    ./network.nix
    ./hardware-configuration.nix

    # user(s)
    ../../users/apostolic

    # display manager
    ../public/ly.nix

    # brightness control
    ../public/light.nix
  ];

  # TODO: move it somewhere
  security = {
    pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  system.stateVersion = "24.11";
}
