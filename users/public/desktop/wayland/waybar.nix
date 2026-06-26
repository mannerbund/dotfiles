{
  username,
  ...
}:
{

  home-manager.users.${username} =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      mkSpan = abbr: "<span color='#${abbr}'><b>{}</b></span>";
      mkSpanWorkspace = abbr: "<span color='#${abbr}'><b>{icon}</b></span>";
      server = "127.0.0.1";
      port = 6601;
    in
    {
      home.packages = [ pkgs.mpc ];
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            exclusive = true;
            fixed-center = true;
            gtk-layer-shell = true;
            spacing = 10;
            margin-top = 0;
            margin-bottom = 0;
            margin-left = 0;
            margin-right = 0;

            modules-left = [
              "ext/workspaces"
              "dwl/window"
            ];
            "ext/workspaces" = {
              format = "{icon}";
              ignore-hidden = true;
              on-click = "activate";
              on-click-right = "deactivate";
              sort-by-id = true;
            };
            "dwl/window" = {
              format = "[{layout}] {title}";
            };

            # modules-left = [
            #   "idle_inhibitor"
            #   "niri/workspaces"
            #   "niri/window"
            # ];
            modules-right = [
              "tray"
              "mpd"
              # "wireplumber"
              "battery"
              "clock"
            ];

            # "niri/workspaces" = {
            #   format = mkSpanWorkspace "${config.lib.stylix.colors.base07}";
            #   on-click = "activate";
            #   all-outputs = true;
            #   format-icons = {
            #     default = "";
            #     active = "";
            #   };
            # };

            # idle_inhibitor = {
            #   "format" = "{icon}";
            #   format-icons = {
            #     activated = "";
            #     deactivated = "";
            #   };
            # };

            # "niri/window" = {
            #   separate-outputs = true;
            #   icon = true;
            #   icon-size = 20;
            # };

            clock = {
              format = "{:%H:%M}";
              tooltip-format = "{calendar}";
            };

            tray = {
              spacing = 10;
            };

            mpd = {
              inherit server port;
              format = "{stateIcon} {randomIcon}{repeatIcon}{singleIcon}{artist} - {title} ({elapsedTime:%H:%M}/{totalTime:%H:%M})";
              on-click = "${lib.getExe pkgs.mpc} --host ${server} -p ${toString port} toggle";
              unknown-tag = "";
              random-icons = {
                on = " ";
              };
              repeat-icons = {
                on = " ";
              };
              single-icons = {
                on = "1 ";
              };
              state-icons = {
                paused = "";
                playing = "";
              };
            };

            # "niri/language" = {
            #   format = "{shortDescription} ";
            #   on-click = "niri msg action switch-layout next";
            # };

            # wireplumber = {
            #   format = "{volume}% {icon}";
            #   format-muted = "";
            #   on-click = "${lib.getExe pkgs.pwvucontrol}";
            #   format-icons = [
            #     ""
            #     ""
            #     ""
            #   ];
            # };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}";
              format-alt = "{capacity}% {icon}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              max-length = 25;
            };
          };
        };
        # style = ''
        #   #waybar {
        #       font-weight: bold;
        #   }
        #   #idle_inhibitor {
        #     padding: 0 10px;
        #   }
        #   .modules-right {
        #     padding: 0 10px;
        #   }
        # '';
      };
    };
}
