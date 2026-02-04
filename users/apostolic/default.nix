{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  username = "apostolic";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (
      { ... }:
      {
        config._module.args = { inherit username; };
      }
    )

    # security/secrets/passwords
    ../public/security
    ../public/security/gpg.nix
    ../public/security/sops.nix
    ../public/security/pass.nix

    # desktop environment
    ../public/emacs
    ../public/desktop/wayland/river.nix

    # shell
    ../public/cli
    ../public/cli/zsh.nix
    ../public/cli/sdcv.nix
    ../public/cli/direnv.nix

    # audio
    ../public/pipewire.nix

    # network stuff
    ../public/net/ssh.nix
    ../public/net/warp.nix
    ../public/net/zapret.nix
    ../public/net/syncthing.nix
    ../public/net/wireguard.nix
    ../public/net/transmission.nix

    # misc
    ../public/xdg.nix
    ../public/cli/git.nix
    ../public/texlive.nix
    ../public/media/zathura.nix
    ../public/media/mpv.nix
    ../public/media/music.nix
    ../public/media/ncmpcpp.nix
    ../public/browsers/librewolf.nix

    # games
    ../public/games
  ];

  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    uid = 1001;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "systemd-journal"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} =
      { config, ... }:
      {
        home = {
          username = lib.mkDefault "${username}";
          homeDirectory = lib.mkDefault "/home/${username}";
          packages = with pkgs; [
            visidata
            gtypist
          ];
          sessionVariables = {
            LESS = "-R --mouse";
            CARGO_HOME = "${config.xdg.dataHome}/cargo";
            NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm";
            XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
          };
        };

        home.persistence."/persist" = {
          directories = [
            ".cache"
            ".local/dotfiles"
            ".local/share/keyrings"
            ".local/share/nix"
            ".local/share/iwctl"
            ".ssh"
            "Desktop"
            "Documents"
            "Downloads"
            "Library"
            "Music"
            "Pictures"
            "Videos"
          ];
        };

        programs.home-manager.enable = true;

        home.stateVersion = "24.11";
      };
  };
}
