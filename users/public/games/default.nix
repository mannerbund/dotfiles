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
              unsafe-dbus
              network
              (rw-bind "${config.home.homeDirectory}/.local/share/Games" "${config.home.homeDirectory}/.local/share/Games")
              (rw-bind "${config.home.homeDirectory}/.local/share/lutris" "${config.home.homeDirectory}/.local/share/lutris")
              (rw-bind "/run" "/run")
              (add-pkg-deps [
                pkgs.gamemode
                pkgs.gamescope
                pkgs.winetricks
                pkgs.wineWow64Packages.stable
              ])
            ];
          };
      };
    in
    {
      home.persistence."/persist" = {
        directories = [
          ".local/share/lutris"
          ".local/share/Games"
          ".config/StardewValley"
        ];
      };

      home.packages = [
        pkgs.wineWow64Packages.stable
        pkgs.winetricks
        (jail "jailed-lutris" pkgs.lutris [
          jail.combinators.lutris-permissions
        ])
      ];
    };
}
