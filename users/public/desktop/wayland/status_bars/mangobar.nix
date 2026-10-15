{ username, ... }:
{
  home-manager.users.${username} =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.mangobar.homeManagerModules.mangobar
      ];

      services.mangobar = {
        enable = true;
        settings = {
          modules-left = [
            "workspaces"
            "layout"
            "window"
          ];
          modules-right = [
            "tray"
            "keyboardlayout"
            "cpu"
            "memory"
            "battery#BAT0"
            "battery#BAT1"
            "clock#date"
            "clock#time"
          ];
          tray = {
            icon-size= 25;
            spacing= 10;
          };
          network = {
            format = "{icon} {ifname}";
            format-wifi = "{signal} {ssid}";
            format-disconnected = "{icon}";
            icon-wifi = "󰖩";
            icon-ethernet = "󰈀";
            icon-disconnected = "󰖪";
            signal-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-alt = "↓{down} ↑{up}";
          };
          cpu = {
            format = " {load}%";
          };
          memory = {
            format = " {}%";
          };
          "battery#BAT0" = {
            format = "{icon} {percent}%";
          };
          "battery#BAT1" = {
            format = "{icon} {percent}%";
          };
          "clock#date" = {
            format = " {:L %b%d·%A}";
          };

        };
      };
    };
}
