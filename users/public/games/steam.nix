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
      steam = pkgs.steam.override {
        extraPkgs = p: [
          p.gamemode
        ];
      };
      jail = inputs.jail-nix.lib.extend {
        inherit pkgs;
        additionalCombinators =
          builtinCombinators: with builtinCombinators; {
            steam-permissions = compose [
              gui
              gpu
              pipewire
              pulse
              wayland
              xwayland
              network
              (dbus {
                talk = [
                  "com.steampowered"
                  "org.freedesktop.DBus"
                  "com.feralinteractive.GameMode"
                ];
              })
              (rw-bind "${home}/.local/share/Steam" "${home}/.local/share/Steam")
              (rw-bind "${home}/.steam" "${home}/.steam")
            ];
          };
      };
    in
    {
      home.persistence."/persist" = {
        directories = [
          ".local/share/Steam"
          ".steam"
        ];
      };

      home.packages = [
        (jail "jailed-steam" steam [
          jail.combinators.steam-permissions
        ])
      ];
    };
}
