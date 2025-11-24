{
  username,
  ...
}:
{
  imports = [ ./default.nix ];

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
        ];
      };

      xsession = {
        enable = true;
        windowManager.command = "exec dbus-launch --exit-with-session emacs -mm";
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
