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

    # user secrets including password
    ../public/sops.nix
    ../public/cli/pass.nix
    ../public/core

    # desktop env
    ../public/desktop/xorg/exwm.nix
    ../public/emacs

    # shell
    ../public/cli/zsh.nix
    ../public/cli

    # audio
    ../public/pipewire.nix

    # network stuff
    ../public/net/ssh.nix
    ../public/net/transmission.nix
    ../public/net/wireguard.nix
    ../public/net/dnscrypt-proxy2.nix
    ../public/net/zapret.nix

    # misc
    ../public/cli/git.nix
    ../public/gpg.nix
    ../public/texlive.nix
    ../public/xdg.nix
    ../public/browsers/librewolf.nix
    ../public/media/mpv.nix
    ../public/media/music.nix
    ../public/direnv.nix
    ../public/zathura.nix
  ];

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
    # extraGroups = ifTheyExist [
    #   "gamemode"
    #   "wireshark"
    # ];
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs username;
    };
    users.${username} =
      { config, ... }:
      {
        imports = [
          inputs.impermanence.homeManagerModules.impermanence
        ];
        home = {
          username = lib.mkDefault "apostolic";
          homeDirectory = lib.mkDefault "/home/${config.home.username}";
        };
        home.packages = with pkgs; [
          visidata
        ];

        home.sessionVariables = {
          LESS = "-R --mouse";
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm";
          XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
        };

        home.persistence."/persist/${config.home.homeDirectory}" = {
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
          allowOther = true;
        };

        programs.home-manager.enable = true;

        home.stateVersion = "24.11";
      };
  };
}
