{ pkgs, ... }:
{
  security = {
    pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
    # polkit.enable = true;
    # pam.services.swaylock = { };
  };
}
