{
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../../../terminals/foot.nix
    ../../../media/imv.nix
    ../sandbar.nix
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
        wineWow64Packages.waylandFull
        grim
        slurp
        brightnessctl
        pwvucontrol
      ];

      programs = {
        bemenu = {
          enable = true;
          settings = {
            line-height = 28;
          };
        };
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

      gtk.gtk3 = {
        extraCss = ''
          headerbar.titlebar.default-decoration {
            background: transparent;
            padding: 0;
            margin: 0 0 -17px 0;
            border: 0;
            min-height: 0;
            font-size: 0;
            box-shadow: none;
          }

          /* rm -rf window shadows */
          window.csd,             /* gtk4? */
          window.csd decoration { /* gtk3 */
            box-shadow: none;
          }
        '';
      };

      home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        dotIcons.enable = false;
        gtk.enable = true;
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
              "Mod4 P" = "focus-view previous";
              "Mod4 N" = "focus-view next";
              "Mod4+Shift P" = "swap previous";
              "Mod4+Shift N" = "swap next";
              "Mod4 H" = "resize horizontal -100";
              "Mod4 J" = "resize vertical 100";
              "Mod4 K" = "resize vertical -100";
              "Mod4 L" = "resize horizontal 100";
              "Mod4 Z" = "zoom";
              "Mod4 F" = "toggle-fullscreen";

              "Mod4 G" = "toggle-focused-tags $((1 << 10))";
              "Mod4+Shift G" = "set-view-tags $((1 << 10))";
              "Mod4 Return" = "spawn 'footclient'";
              "Mod4 D" = "spawn 'bemenu-run'";
              "Mod4 E" = "spawn 'emacsclient -c'";
              "Mod4 W" = "spawn 'librewolf'";

              "None Print" = ''
                spawn 'grim -g "$(slurp)" - | wl-copy'
              '';
              "Shift Print" = ''
                spawn 'grim -g "$(slurp)" - | tee "$(xdg-user-dir SCREENSHOTS)/$(date "+%Y-%m-%d_%H-%M-%S_screenshot.png")" | wl-copy'
              '';

              "Mod4 1" = "set-focused-tags $((1 << 0))";
              "Mod4 2" = "set-focused-tags $((1 << 1))";
              "Mod4 3" = "set-focused-tags $((1 << 2))";
              "Mod4 4" = "set-focused-tags $((1 << 3))";
              "Mod4 5" = "set-focused-tags $((1 << 4))";
              "Mod4 6" = "set-focused-tags $((1 << 5))";
              "Mod4 7" = "set-focused-tags $((1 << 6))";
              "Mod4 8" = "set-focused-tags $((1 << 7))";
              "Mod4 9" = "set-focused-tags $((1 << 8))";
              "Mod4 0" = "set-focused-tags $((1 << 9))";
              "Mod4+Shift 1" = "set-view-tags 1";
              "Mod4+Shift 2" = "set-view-tags 2";
              "Mod4+Shift 3" = "set-view-tags 4";
              "Mod4+Shift 4" = "set-view-tags 8";
              "Mod4+Shift 5" = "set-view-tags 16";
              "Mod4+Shift 6" = "set-view-tags 32";
              "Mod4+Shift 7" = "set-view-tags 64";
              "Mod4+Shift 8" = "set-view-tags 128";
              "Mod4+Shift 9" = "set-view-tags 256";
              "Mod4+Shift 0" = "set-view-tags 512";

              "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_SINK@ toggle'";
              "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%-'";
              "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_SINK@ 5%+'";

              "None XF86MonBrightnessUp" = "spawn 'brightnessctl s +10%'";
              "None XF86MonBrightnessDown" = "spawn 'brightnessctl s 10%-'";

              # Xwayland clipboard fix from https://github.com/YaLTeR/niri/wiki/Xwayland
              "Mod4+Shift W" = "spawn 'env DISPLAY=:0 xsel -ob | wl-copy'";
              "Mod4+Shift Y" = "spawn 'wl-paste -n | env DISPLAY=:0 xsel -ib'";

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

          spawn = [
            "$HOME/.config/river/status"
            "$HOME/.config/river/bar"
            "footclient -N -a scratch-term"
          ];
        };

        extraConfig = ''
          riverctl default-layout rivertile 
          rivertile -view-padding 6 -outer-padding 6 &
          # riverctl rule-add -app-id scratch-term csd 
          riverctl rule-add -app-id scratch-term float 
          riverctl rule-add -app-id scratch-term position 360 140
          riverctl rule-add -app-id scratch-term dimensions 1200 800 
          riverctl rule-add -app-id scratch-term tags $((1 << 10))
        '';
        extraSessionVariables = {
          MOZ_ENABLE_WAYLAND = "1";
        };
      };

    };
}
