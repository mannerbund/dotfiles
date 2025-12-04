{
  username,
  pkgs,
  ...
}:
{
  imports = [ ./default.nix ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.symbols-only
      iosevka
      aporetic
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      twemoji-color-font
    ];
  };

  home-manager.users.${username} =
    { pkgs, ... }:
    {

      home = {
        sessionVariables = {
          _JAVA_AWT_WM_NONREPARENTING = "1";
          MOZ_USE_XINPUT2 = 1; # Mozilla smooth scrolling/touchpads.
        };
        packages = with pkgs; [
          libnotify
          xclip
          nsxiv
        ];
      };

      xsession = {
        enable = true;
        windowManager.command = ''exec dbus-launch --exit-with-session emacsclient -a "" -c'';
      };

      services = {
        gammastep = {
          enable = true;
          provider = "manual";
          latitude = 55.7;
          longitude = 37.6;
        };
        dunst.enable = true;
      };
    };
}
