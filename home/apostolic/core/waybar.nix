{
  pkgs,
  config,
  ...
}: let
  mkSpan = abbr: "<span color='#${abbr}'><b>{}</b></span>";
  mkSpanWorkspace = abbr: "<span color='#${abbr}'><b>{icon}</b></span>";
in {
  stylix.targets.waybar.enable = true;
  stylix.targets.waybar.font = "sansSerif";

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
          "idle_inhibitor"
          "niri/workspaces"
          "niri/window"
        ];
        modules-right = [
          "tray"
          "niri/language"
          "mpd"
          "wireplumber"
          "battery"
          "clock"
        ];

        "niri/workspaces" = {
          format = mkSpanWorkspace "${config.lib.stylix.colors.base07}";
          on-click = "activate";
          all-outputs = true;
          format-icons = {
            default = "";
            active = "";
          };
        };

        idle_inhibitor = {
          "format" = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "niri/window" = {
          separate-outputs = true;
          icon = true;
          icon-size = 20;
        };

        clock = {
          calendar = {
            format = {
              days = mkSpan "${config.lib.stylix.colors.base0A}";
              months = mkSpan "${config.lib.stylix.colors.base0D}";
              today = mkSpan "${config.lib.stylix.colors.base0D}";
              weekdays = mkSpan "${config.lib.stylix.colors.base05}";
            };
            mode = "month";
            on-scroll = 1;
          };
          format = "{:%H:%M}";
          tooltip-format = "{calendar}";
        };

        tray = {
          spacing = 10;
        };

        mpd = {
          format = "{stateIcon} {randomIcon}{repeatIcon}{singleIcon}{artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          unknown-tag = "";
        };

        "niri/language" = {
          format = "{shortDescription} ";
        };

        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "helvum";
          format-icons = ["" "" ""];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-alt = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
      };
    };
    style = ''
      #waybar {
          font-weight: bold;
      }
      #idle_inhibitor {
        padding: 0 10px;
      }
      .modules-right {
        padding: 0 10px;
      }
    '';
  };
}

