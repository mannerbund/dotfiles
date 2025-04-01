{pkgs, config, ... }:
let
  mkSpan = abbr: "<span color='#${abbr}'><b>{}</b></span>";
  mkSpanWorkspace = abbr: "<span color='#${abbr}'><b>{icon}</b></span>";
in
{
  stylix.targets.waybar.enable = true;

  programs.waybar = {
    enable = true;
  	systemd.target = "niri-session";
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        fixed-center = true;
        gtk-layer-shell = true;
        spacing = 0;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [
          "niri/workspaces"
          "idle_inhibitor"
          "niri/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "niri/language"
          "mpd"
          "wireplumber"
          "battery"
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
          format = "{:%I:%M %p}";
          tooltip-format = "{calendar}";
        };

        tray = {
          spacing = 10;
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
            warning= 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}";
          format-plugged = "{time} {icon}";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
      };
    };
    style = ''
      #language {
        margin-left: 15px;
        margin-right: 15px;
      }
    '';
  };
}
