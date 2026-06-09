{
  username,
  pkgs,
  ...
}:
{
  users.users.${username}.extraGroups = [ "pipewire" ];
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
          bluetooth.autoswitch-to-headset-profile = false
        '')
      ];
    };
  };

  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
