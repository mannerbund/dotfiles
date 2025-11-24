{
  config,
  pkgs,
  lib,
  ...
}:
let
  swaylock_conf = "swaylock --daemonize --font 'SansSerif' --font-size 14 --screenshots --clock --line-uses-inside --indicator-radius 100 --indicator-thickness 7 --indicator-idle-visible --indicator-caps-lock --disable-caps-lock-text --effect-blur 20x3 --fade-in 0.2";
in
{
  programs.fish.loginShellInit = ''
    if test (tty) = "/dev/tty1"
      exec dbus-run-session sway -d 2>${config.xdg.cacheHome}/sway.log
    end
  '';

  home.sessionVariables = {
    TERMINAL = "footclient";
    MOZ_USE_XINPUT2 = 1; # Mozilla smooth scrolling/touchpads.
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.sway = {
      default = [
        "wlr"
        "gtk"
      ];
    };
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    adwaita-qt
    adwaita-qt6
    dmenu-wayland
    wl-clipboard
    wl-mirror
    wdisplays
    sway-contrib.grimshot
    swaylock-effects
    font-awesome
  ];

  services = {
    mako = {
      enable = true;
      font = "SansSerif 12";
      defaultTimeout = 7000;
      ignoreTimeout = true;
    };
  };

  programs = {
    i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          icons = "awesome6";
          settings.theme = {
            theme = "srcery";
            overrides = {
              separator = "     ";
            };
          };
          blocks = [
            {
              block = "keyboard_layout";
              driver = "sway";
              mappings = {
                "English (US)" = "En";
                "Russian (N/A)" = "Ru";
              };
              format = " $layout  ";
            }
            {
              block = "sound";
              format = " {$volume.eng(w:2) |} $icon";
            }
            {
              block = "battery";
              driver = "upower";
              device = "DisplayDevice";
              format = " $percentage $icon ";
              full_format = " $percentage $icon ";
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
              interval = 30;
            }
          ];
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = false;
    checkConfig = false;
    extraConfig = ''
      bindswitch --reload --locked lid:on exec "${swaylock_conf}"
      #bindswitch --reload --locked lid:off exec swaymsg "output * power on"
    '';
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      menu = "dmenu-wl_run";
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ "SansSerif" ];
        size = 12.0;
      };
      bars = [
        {
          position = "bottom";
          fonts = {
            names = [ "SansSerif" ];
            size = 14.0;
          };
          statusCommand = "i3status-rs config-bottom.toml";
          trayPadding = 3;
          colors = {
            separator = "#666666";
            background = "#222222";
            statusline = "#dddddd";
            focusedWorkspace = {
              background = "#0088CC";
              border = "#0088CC";
              text = "#ffffff";
            };
            activeWorkspace = {
              background = "#333333";
              border = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              background = "#333333";
              border = "#333333";
              text = "#888888";
            };
            urgentWorkspace = {
              background = "#2f343a";
              border = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];
      startup = [
        {
          command = "foot --server";
          always = true;
        }
        {
          command = "mako";
          always = true;
        }
      ];
      assigns = {
        "9" = [ { app_id = "zen"; } ];
        "8" = [ { app_id = "org.telegram.desktop"; } ];
        "7" = [ { app_id = "net.lutris.Lutris"; } ];
      };
      window.commands = [
        {
          criteria = {
            app_id = "zenity";
          };
          command = "floating enable";
        }
        {
          criteria = {
            app_id = "pwvucontrol";
          };
          command = "floating enable";
        }
        {
          criteria = {
            app_id = "net.lutris.Lutris";
          };
          command = "floating enable";
        }
        {
          criteria = {
            class = "Wine";
          };
          command = "floating enable";
        }
      ];
      output = {
        eDP-1 = {
          # Scale problem with emacs-pgtk, keep it at 1
          scale = "1";
          bg = "${config.home.homeDirectory}/Pictures/Wallpapers/0281.jpg fill";
        };
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "ctrl:nocaps,grp:ctrl_space_toggle";
          repeat_delay = "200";
          repeat_rate = "30";
        };
        "type:touchpad" = {
          dwt = "enabled";
          dwtp = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };
      bindkeysToCode = true;
      keybindings =
        let
          inherit modifier;
          inherit terminal;
          inherit menu;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec footclient";
          "${modifier}+d" = "exec ${menu} -i";
          "${modifier}+m" = "exec ${terminal} lf";
          "${modifier}+p" = "exec pwvucontrol";
          "${modifier}+Shift+d" = "exec passmenu -i";
          "${modifier}+w" = "exec zen-beta";
          "${modifier}+a" = "exec foot htop";
          "${modifier}+e" = "exec element-desktop";
          "${modifier}+q" = "kill";
          "${modifier}+t" = "exec telegram-desktop";
          "${modifier}+s" = "exec emacsclient -c";
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";
          "${modifier}+Tab" = "workspace back_and_forth";

          "${modifier}+Shift+f" = "floating toggle";

          "${modifier}+Ctrl+Shift+h" = "resize shrink width 40px";
          "${modifier}+Ctrl+Shift+j" = "resize grow height 40px";
          "${modifier}+Ctrl+Shift+k" = "resize shrink height 40px";
          "${modifier}+Ctrl+Shift+l" = "resize grow width 40px";

          "Print" = "exec grimshot copy area";
          "Shift+Print" = "exec grimshot savecopy area";
          "Ctrl+Print" = "exec grimshot savecopy screen";

          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 0.1-";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 0.1+";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec light -U 20";
          "XF86MonBrightnessUP" = "exec light -A 20";

          "${modifier}+Shift+BackSpace" = "exit";
          "${modifier}+F12" = "exec ${swaylock_conf}";
        };
    };
  };
}
