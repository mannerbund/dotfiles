{
  username,
  pkgs,
  ...
}:
{
  imports = [
    ../../../terminals/foot.nix
    ../../../media/imv.nix
    ../../dark-theme.nix
    ../waybar.nix
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

  home-manager.users.${username} =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.mangowm.hmModules.mango
      ];

      home.packages = with pkgs; [
        libnotify
        wl-clipboard
        grim
        slurp
        brightnessctl
        pwvucontrol
        (writeShellScriptBin "screenshot-to-clip" ''
          if geometry=$(slurp); then
            if grim -g "$geometry" - | wl-copy; then
              notify-send -u low "Screenshot saved"
            else
              notify-send -u normal "Screenshot failed"
            fi
          else
            notify-send -u critical "Screenshot cancelled"
          fi
        '')
        (writeShellScriptBin "screenshot-save" ''
          if geometry=$(slurp); then
            if grim -g "$(slurp)" - | tee "$(xdg-user-dir SCREENSHOTS)/$(date "+%Y-%m-%d_%H-%M-%S_screenshot.png")" | wl-copy; then
              notify-send -u low "Screenshot saved"
            else
              notify-send -u normal "Screenshot failed"
            fi
          else
            notify-send -u critical "Screenshot cancelled"
          fi
        '')
      ];

      home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        dotIcons.enable = false;
        gtk.enable = true;
      };

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
            border-size = 4;
          };
          extraConfig = ''
            [urgency=low]
            background-color=#1e1e2e
            text-color=#6c7086

            [urgency=normal]
            background-color=#313244
            text-color=#cdd6f4

            [urgency=critical]
            background-color=#f38ba8
            text-color=#1e1e2e
            border-color=#fab387
          '';
        };
      };

      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        settings = {
          repeat_rate = 30;
          repeat_delay = 200;
          xkb_rules_layout = "us,ru";
          xkb_rules_options = "ctrl:nocaps,grp:toggle";
          windowrule = "isnamedscratchpad:1,width:1280,height:800,appid:scratch-foot";
          sloppyfocus = 0;
          hotarea_corner = 0;
          exec-once = [
            "waybar"
            "gammastep"
          ];
          mousebind = [
            "SUPER,btn_left,moveresize,curmove"
            "SUPER,btn_right,moveresize,curresize"
            "SUPER+CTRL,btn_right,killclient"
          ];
          bind = [
            "SUPER,Return,spawn,foot"
            "SUPER,d,spawn,bemenu-run"
            "SUPER,w,spawn,librewolf"
            "SUPER,e,spawn,emacsclient -c"

            "SUPER,q,killclient"
            "SUPER,r,reload_config"

            "SUPER,z,zoom"

            "SUPER,1,view,1"
            "SUPER,2,view,2"
            "SUPER,3,view,3"
            "SUPER,4,view,4"
            "SUPER,5,view,5"
            "SUPER,6,view,6"
            "SUPER,7,view,7"
            "SUPER,8,view,8"
            "SUPER,9,view,9"

            "SUPER+SHIFT,1,tagsilent,1"
            "SUPER+SHIFT,2,tagsilent,2"
            "SUPER+SHIFT,3,tagsilent,3"
            "SUPER+SHIFT,4,tagsilent,4"
            "SUPER+SHIFT,5,tagsilent,5"
            "SUPER+SHIFT,6,tagsilent,6"
            "SUPER+SHIFT,7,tagsilent,7"
            "SUPER+SHIFT,8,tagsilent,8"
            "SUPER+SHIFT,9,tagsilent,9"

            "SUPER,space,togglefloating"
            "SUPER,f,togglefullscreen"

            "SUPER,s,toggle_named_scratchpad,scratch-foot,none,foot -a scratch-foot"
            "SUPER,a,toggle_scratchpad"
            "SUPER+SHIFT,a,minimized"
            "SUPER+CTRL,a,restore_minimized"

            "SUPER,h,focusdir,left"
            "SUPER,j,focusdir,down"
            "SUPER,k,focusdir,up"
            "SUPER,l,focusdir,right"

            "SUPER+CTRL+SHIFT,h,resizewin,-10,0"
            "SUPER+CTRL+SHIFT,l,resizewin,+10,0"

            "SUPER+SHIFT,h,exchange_client,left"
            "SUPER+SHIFT,j,exchange_client,down"
            "SUPER+SHIFT,k,exchange_client,up"
            "SUPER+SHIFT,l,exchange_client,right"

            "NONE,Print,spawn,screenshot-to-clip"
            "SHIFT,Print,spawn,screenshot-save"

            "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
            "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
            "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
            "NONE,XF86MonBrightnessUp,spawn,brightnessctl s +10%"
            "NONE,XF86MonBrightnessDown,spawn,brightnessctl s 10%-"

            "SUPER+SHIFT,BackSpace,quit"
          ];
        };
      };
    };
}
