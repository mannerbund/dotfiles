{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.sessionVariables = {
    TERMINAL = "footclient";
    MOZ_USE_XINPUT2 = 1; # Mozilla smooth scrolling/touchpads.
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    dmenu-wayland
    wl-clipboard
    wl-mirror
    wayland-utils
    wdisplays
    font-awesome
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.niri-unstable ];
  };

  services = {
    mako = {
      enable = true;
      defaultTimeout = 7000;
      ignoreTimeout = true;
    };
  };
  
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
   settings = {
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 60.0;
        };
      };
      hotkey-overlay.skip-at-startup = true;
      input = {
        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          click-method = "clickfinger";
        };
      };
      input.keyboard = {
        xkb.layout = "us,ru";
        xkb.options = "ctrl:nocaps,grp:ctrl_space_toggle";
        repeat-delay = 200;
        repeat-rate = 30;
      };
      prefer-no-csd = true;
      clipboard.disable-primary = true;
      layout = {
        gaps = 8;
        default-column-width = { proportion = 1.0; };
      };
      binds = with config.lib.niri.actions; let
        sh = spawn "sh" "-c";
      in
        lib.attrsets.mergeAttrsList [
          {
            "Mod+Return".action = spawn "foot";
            "Mod+D".action = spawn "dmenu-wl_run";     
            "Mod+Shift+D".action = spawn "passmenu" "-i";
            "Mod+S".action = spawn "emacsclient" "-c";
            "Mod+T".action = spawn "telegram-desktop";
            "Mod+W".action = spawn "zen-beta";
            "Mod+A".action = spawn "foot" "htop";
            "Mod+P".action = spawn "pwvucontrol";
            "Mod+Q".action = close-window;
            "Mod+Shift+Slash".action = show-hotkey-overlay;

            "Mod+V".action = switch-focus-between-floating-and-tiling;
            "Mod+Shift+V".action = toggle-window-floating;

            "Mod+R".action = switch-preset-column-width;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+C".action = center-column;

            "Mod+L".action = focus-column-right;
            "Mod+H".action = focus-column-left;
            "Mod+Ctrl+L".action = move-column-right;
            "Mod+Ctrl+H".action = move-column-left;

            "Mod+J".action = focus-workspace-down;
            "Mod+K".action = focus-workspace-up;
            "Mod+Ctrl+J".action = move-column-to-workspace-down;
            "Mod+Ctrl+K".action = move-column-to-workspace-up;

            "Mod+Shift+H".action = set-column-width "-10%";
            "Mod+Shift+L".action = set-column-width "+10%";
            "Mod+Shift+J".action = set-window-height "-10%";
            "Mod+Shift+K".action = set-window-height "+10%";

            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+Ctrl+1".action.move-column-to-workspace = 1;
            "Mod+Ctrl+2".action.move-column-to-workspace = 2;
            "Mod+Ctrl+3".action.move-column-to-workspace = 3;
            "Mod+Ctrl+4".action.move-column-to-workspace = 4;
            "Mod+Ctrl+5".action.move-column-to-workspace = 5;
            "Mod+Ctrl+6".action.move-column-to-workspace = 6;
            "Mod+Ctrl+7".action.move-column-to-workspace = 7;
            "Mod+Ctrl+8".action.move-column-to-workspace = 8;
            "Mod+Ctrl+9".action.move-column-to-workspace = 9;

            "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_SINK@ toggle";
            "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_SINK@ 0.1-";
            "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_SINK@ 0.1+";
            "XF86AudioMicMute".action = sh "wpctl set-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessUp".action = sh "light -A 20";
            "XF86MonBrightnessDown".action = sh "light -U 20";

            "Mod+Shift+Backspace".action = quit;
          }
        ];
    };
  };
}
