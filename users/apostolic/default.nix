{
  inputs,
  config,
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
    # user secrets including password
    (import ../public/sops.nix { inherit inputs config username; })
    ../public/core

    # desktop env
    (import ../public/desktop/xorg/exwm.nix { inherit username; })
    (import ../public/emacs { inherit username inputs; })

    # shell
    (import ../public/cli/zsh.nix { inherit username pkgs; })
    (import ../public/cli { inherit username pkgs; })

    # audio
    (import ../public/pipewire.nix { inherit username; })

    # network stuff
    (import ../public/net/ssh.nix { inherit username; })
    (import ../public/net/transmission.nix { inherit pkgs config username; })
    (import ../public/net/wireguard.nix { inherit lib; })
    ../public/net/dnscrypt-proxy2.nix
    ../public/net/zapret.nix

    # misc
    (import ../public/cli/git.nix { inherit username; })
    (import ../public/gpg.nix { inherit username; })
    (import ../public/texlive.nix { inherit username; })
    (import ../public/cli/pass.nix { inherit username; })
    (import ../public/xdg.nix { inherit username; })
    (import ../public/browsers/librewolf.nix { inherit username; })
    (import ../public/media/mpv.nix { inherit username; })
    (import ../public/media/music.nix { inherit username; })
    (import ../public/direnv.nix { inherit username; })
    (import ../public/zathura.nix { inherit username; })
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
