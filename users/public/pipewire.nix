{
  username,
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
    wireplumber.enable = true;
  };

  home-manager.users.${username} = {
    home.persistence."/persist" = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
