{
  username,
  ...
}:
{
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.users.${username}.extraGroups = [ "gamemode" ];

  home-manager.users.${username} =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    let
      home = config.home.homeDirectory;
      jail = inputs.jail-nix.lib.extend {
        inherit pkgs;
        additionalCombinators =
          builtinCombinators: with builtinCombinators; {
            lutris-permissions = compose [
              gui
              gpu
              pipewire
              pulse
              wayland
              xwayland
              network
              (dbus {
                own = [ "net.lutris.Lutris" ];
                talk = [
                  "org.freedesktop.DBus"
                  "com.feralinteractive.GameMode"
                ];
              })
              (ro-bind "/sys/class/drm" "/sys/class/drm")
              (rw-bind "${home}/.local/share/Games" "${home}/.local/share/Games")
              (rw-bind "${home}/.local/share/lutris" "${home}/.local/share/lutris")
              (rw-bind "${home}/.cache/lutris" "${home}/.cache/lutris")
              (add-pkg-deps [
                pkgs.gamemode
                pkgs.gamescope
                pkgs.winetricks
                pkgs.wineWow64Packages.stable
                pkgs.procps
              ])
            ];
          };
      };
    in
    {
      home.persistence."/persist" = {
        directories = [
          ".local/share/lutris"
          ".cache/lutris"
          ".local/share/Games"
        ];
      };

      home.packages = [
        (jail "jailed-lutris" pkgs.lutris [
          jail.combinators.lutris-permissions
        ])
      ];
    };
}
