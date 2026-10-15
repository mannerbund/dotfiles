{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      lib,
      pkgs,
      ...
    }:
    let
      server = "127.0.0.1";
      port = 6601;
    in
    {
      home.packages = [ pkgs.mpc ];
      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          version = "0.15.0-unstable-2026-08-04";
          src = pkgs.fetchFromGitHub {
            owner = "Alexays";
            repo = "Waybar";
            rev = "084d87401d0a91182c16aa7e5f674a7dde767185";
            hash = "sha256-POvwObPOp6O14n6KYWNLp2Y3paunA5f8U1NCaodNFcc=";
          };
          buildInputs = oldAttrs.buildInputs ++ [
            pkgs.modemmanager
            pkgs.catch2_3
          ];
          mesonFlags = oldAttrs.mesonFlags ++ [
            "-Dcava=disabled"
            "-Dmango=true"
          ];
          doInstallCheck = false;
        });
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            height = 42;
            spacing = 4;
            "modules-left" = [
              "mango/workspaces"
              "mango/layout"
              "wlr/taskbar"
              "mango/window"
            ];
            "modules-center" = [

            ];
            "modules-right" = [
              "tray"
              "mango/language"
              "network"
              "cpu"
              "memory"
              "temperature"
              "battery"
              "clock"
            ];
            "mango/workspaces" = {
              format = "{icon}";
              "hide-empty" = true;
              "on-click" = "activate";
              "on-click-right" = "toggle";
              "overview-label" = "OVERVIEW";
            };
            "mango/window" = {
              format = "{}";
              icon = false;
              icon-size = 20;
            };
            "mango/layout" = {
              format = "{}";
            };
            "mango/language" = {
              format = "{short}";
              format-en = "󰌌 US";
              format-ru = "󰌌 RU";
            };

            "wlr/taskbar" = {
              format = "{icon}";
              icon-size = 20;
              all-outputs = false;
              tooltip-format = "{title}";
              markup = true;
              on-click = "activate";
              on-click-middle = "minimize";
              on-click-right = "close";
            };
            network = {
              interval = 2;
              "format-wifi" = " {essid} ({signalStrength}%)";
              "format-ethernet" = "󰈀 {ifname}";
              "format-linked" = " No IP ({ifname})";
              "format-disconnected" = " Disconnected";
              "tooltip-format" = "{ipaddr}/{cidr} via {gwaddr}";
              "format-alt" = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
            };
            tray = {
              "icon-size" = 21;
              spacing = 10;
            };
            "keyboard-state" = {
              numlock = true;
              capslock = true;
              format = {
                numlock = "N {icon}";
                capslock = "C {icon}";
              };
              "format-icons" = {
                locked = "";
                unlocked = "";
              };
            };
            clock = {
              format = " {:%H:%M}";
              "format-alt" = " {:L%A, %b %d}";
              "tooltip-format" = "{:%Y}";
            };
            cpu = {
              interval = 2;
              format = " {load}%";
            };
            memory = {
              format = " {}%";
            };
            temperature = {
              "critical-threshold" = 90;
              format = "{icon} {temperatureC}°C";
              tooltip = true;
              "tooltip-format" = "{temperatureF}°F";
              "format-icons" = [
                ""
                ""
                ""
              ];
            };
          };
        };
      };
    };
}
