{
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../../../terminals/foot.nix
    ../../../public/media/imv.nix
  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      twemoji-color-font
    ];
  };

  users.users.${username}.extraGroups = [ "seat" ];

  home-manager.users.${username} =
    { lib, pkgs, ... }:
    {

      home.packages = with pkgs; [
        libnotify
        wl-clipboard
        wayland-utils
        wdisplays
        xsel
        creek
        wineWowPackages.waylandFull
        scrot
        bemenu
      ];

      programs = {
        bemenu.enable = true;
      };
      services = {
        gpg-agent = {
          pinentry.package = lib.mkForce pkgs.wayprompt;
          pinentry.program = lib.mkForce "pinentry-wayprompt";
        };
        gammastep = {
          enable = true;
          provider = "manual";
          latitude = 55.7;
          longitude = 37.6;
        };
        mako = {
          enable = true;
          settings = {
            default-timeout = 7000;
            ignore-timeout = true;
          };
        };
      };

      gtk = {
        gtk4 = {
          extraConfig = ''
            [Settings]
            gtk-dialogs-use-header=false
          '';
        };
        gtk3 = {
          extraConfig = ''
            [Settings]
            gtk-dialogs-use-header=false
          '';
          extraCss = ''
              /* No (default) title bar on wayland */
            headerbar.default-decoration {
              /* You may need to tweak these values depending on your GTK theme */
              margin-bottom: 50px;
              margin-top: -100px;
            }

            /* rm -rf window shadows */
            window.csd,             /* gtk4? */
            window.csd decoration { /* gtk3 */
              box-shadow: none;
            }
          '';
        };
      };

      wayland.windowManager.river = {
        enable = true;
        systemd.enable = true;
        settings = {
          border-width = 2;
          declare-mode = [
            "locked"
            "normal"
            "passthrough"
          ];
          input = {
            "pointer-1133-50504-Logitech_USB_Receiver_Mouse" = {
              accel-profile = "flat";
              pointer-accel = -0.2;
            };
            "pointer-1739-0-Synaptics_TM3276-022" = {
              tap = true;
              events = true;
              accel-profile = "adaptive";
            };
          };

          map = {
            normal = {
              "Mod4 Q" = "close";
              "Mod4 Space" = "toggle-float";
              "Mod4 1" = "set-focused-tags 1";
              "Mod4 2" = "set-focused-tags 2";
              "Mod4 3" = "set-focused-tags 4";
              "Mod4 4" = "set-focused-tags 8";
              "Mod4 K" = "focus-view previous";
              "Mod4 J" = "focus-view next";
              "Mod4+Shift K" = "swap previous";
              "Mod4+Shift J" = "swap next";
              "Mod4 Z" = "zoom";
              "Mod4 F" = "toggle-fullscreen";

              "Mod4+Shift Return" = "spawn 'foot'";
              "Mod4+Shift D" = "spawn 'bemenu-run'";
              "Mod4+Shift E" = "spawn 'emacsclient -c'";
              "Mod4+Shift W" = "spawn 'librewolf'";

              "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_SINK@ toggle'";
              "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%-'";
              "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%+'";

              "None XF86MonBrightnessUp" = "spawn 'light -A 5'";
              "None XF86MonBrightnessDown" = "spawn 'light -U 5'";

              # Xwayland clipboard fix from https://github.com/YaLTeR/niri/wiki/Xwayland
              "Mod4 W" = "spawn 'env DISPLAY=:0 xsel -ob | wl-copy'";
              "Mod4 Y" = "spawn 'wl-paste -n | env DISPLAY=:0 xsel -ib'";

              "Mod4 Backspace" = "exit";
            };
          };
          map-pointer = {
            normal = {
              "Mod4 BTN_RIGHT" = "resize-view";
              "Mod4 BTN_LEFT" = "move-view";
            };
          };

          keyboard-layout = "-options ctrl:nocaps,grp:toggle,compose:rctrl us,ru";

          set-cursor-warp = "on-output-change";
          set-repeat = "30 200";

          rule-add = {
            "-app-id" = {
              "creek" = "csd";
            };
          };

          spawn = [
            "'creek -fn Aporetic:size=16 -hg 22 -nf 0xffffff -nb 0x000000'"
          ];
        };

        extraConfig = ''
          riverctl default-layout rivertile &
          rivertile -view-padding 6 -outer-padding 6 &
        '';
        extraSessionVariables = {
          MOZ_ENABLE_WAYLAND = "1";
        };
      };

    };
}
