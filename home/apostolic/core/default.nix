{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  tide = pkgs.fishPlugins.tide.src;
in {
  imports = [
    ./niri.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
    inputs.niri.overlays.niri
  ];

  home = {
    username = lib.mkDefault "apostolic";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };

  home.packages = with pkgs; [
    (aspellWithDicts (
      dicts:
        with dicts; [
          en
          en-computers
          en-science
          ru
        ]
    ))
    lutris
    libreoffice-qt
    qbittorrent-enhanced
    p7zip
    unrar
    unzip
    xz
    python3
    lm_sensors
    ffmpeg
    anki-bin
    clang
    xdg-utils
    wine-wayland
    winetricks
    nicotine-plus
    telegram-desktop
    jq
    mediainfo
    pwvucontrol
    syncthing
    inputs.zen-browser.packages."${system}".default # beta
    ffmpegthumbnailer
    chafa
    file
    poppler_utils
    epub-thumbnailer
  ];

  home.sessionVariables = {
    ALTERNATE_EDITOR = "";
    EDITOR = "emacsclient -c"; # $EDITOR opens in terminal
    VISUAL = "emacsclient -c -a emacs"; # $VISUAL opens in GUI mode
    BROWSER = "zen";
    LESS = "-R --mouse";
    HISTFILE = "${config.xdg.dataHome}/history";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    NPM_CONFIG_USERCONFIG = "${config.xdg.dataHome}/npm";
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/*" = "imv.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      pinentryPackage = pkgs.pinentry-qt;
      defaultCacheTtl = 86400;
    };
    mpd = {
      enable = true;
      package = pkgs.mpd;
      musicDirectory = "${config.home.homeDirectory}/Music";
      dataDir = "${config.home.homeDirectory}/.local/share/mpd";
      dbFile = "${config.home.homeDirectory}/.local/share/mpd/database";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
        audio_output {
            type	"fifo"
            name	"my_fifo"
            path	"/tmp/mpd.fifo"
            format	"44100:16:2"
        }
      '';
    };
  };

  programs = {
    gpg.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    bat.enable = true;
    imv = {
      enable = true;
      settings = {
        binds = {
          "<Shift+J>" = "zoom -2";
          "<Shift+K>" = "zoom 2";
          "<Ctrl+p>" = "prev";
          "<Ctrl+n>" = "next";
        };
      };
    };
    aria2 = {
      enable = true;
      settings = {
        continue = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
    emacs = {
      enable = true;
      package = (
        pkgs.emacsWithPackagesFromUsePackage {
          package = pkgs.emacs30-pgtk;
          config = ./emacs.el;
          defaultInitFile = true;
          extraEmacsPackages = epkgs: [
            pkgs.graphviz
            epkgs.manualPackages.treesit-grammars.with-all-grammars
          ];
        }
      );
    };
    foot.enable = true;
    lf = {
      enable = true;
      settings = {
        drawbox = true;
        ignorecase = true;
        sixel = true;
        tabstop = 4;
      };
      extraConfig = ''
        # make sure cache folder exists
        %mkdir -p ${config.home.homeDirectory}/.cache/lf
        # make sure trash folder exists
        %mkdir -p ${config.home.homeDirectory}/.local/share/Trash
        # move current file or selected files to trash folder
        # (also see 'man mv' for backup/overwrite options)
        cmd trash %set -f; mv -t ~/.local/share/Trash $fx

        # define a custom 'delete' command
        cmd delete ''${{
            set -f
            printf "$fx\n"
            printf "delete?[y/n]"
            read ans
            [ "$ans" = "y" ] && rm -rf $fx
        }}

        # Follow symbolic links
        cmd follow-link %{{
          lf -remote "send $id select \"$(readlink -- "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
        }}

        # eza
        cmd on-select &{{
            lf -remote "send $id set statfmt \"$(eza -ld --color=always "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
        }}
      '';
      keybindings = {
        "." = "set hidden!";
        U = "glob-unselect";
        x = "trash";
        X = "delete";
        gL = "follow-link";
        gl = "cd ~/Library";
      };
      previewer = {
        keybinding = "i";
        source = pkgs.writeShellScript "pv.sh" ''
          #!/bin/sh
          CACHE="${config.home.homeDirectory}/.cache/lf/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' \
          	-- "$(readlink -f "$1")" | sha256sum | awk '{print $1}'))"

          image() {
            chafa -f sixel -s "$2x$3" --animate off --polite on "$1"
          }

          case "$(readlink -f "$1" | awk '{print tolower($0)}')" in
            *.tgz|*.tar.gz) tar tzf "$1" ;;
            *.tar.bz2|*.tbz2) tar tjf "$1" ;;
            *.tar.xz|*.txz) tar tf "$1" ;;
            *.tar) tar tf "$1" ;;
            *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "$1" ;;
            *.gz) gzip -l "$1" ;;
            *.rar) unrar l "$1" ;;
            *.7z) 7z l "$1" ;;
           *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.mka)
           	mediainfo "$1"
           	;;
           *.pdf)
           	[ ! -f "''${CACHE}.jpg" ] && pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
              image "''${CACHE}.jpg" "$2" "$3"
           	;;
           *.epub)
           	[ ! -f "$CACHE" ] && epub-thumbnailer "$1" "$CACHE" 1024
              image "$CACHE" "$2" "$3"
           	;;
           *.cbz|*.cbr|*.cbt)
           	[ ! -f "$CACHE" ] && comicthumb "$1" "$CACHE" 1024
              image "$CACHE" "$2" "$3"
           	;;
           *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.ts|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
           	[ ! -f "''${CACHE}.jpg" ] && \
           		ffmpegthumbnailer -i "$1" -o "''${CACHE}.jpg" -s 0 -q 5
                image "''${CACHE}.jpg" "$2" "$3"
           	;;

            *)
              case "$(file -Lb --mime-type -- "$1")" in
                image/*)
                  image "$1" "$2" "$3"
                  exit 0
                  ;;
                text/*)
                  bat --color=always --style=plain --pager=never "$1"
                  exit 0
                  ;;
              esac
              ;;
          esac
        '';
      };
    };
    texlive = {
      enable = true;
      extraPackages = texlive: {
        inherit
          (texlive)
          scheme-basic
          dvisvgm
          dvipng
          wrapfig
          amsmath
          amsfonts
          ulem
          hyperref
          capt-of
          minted
          upquote
          polynom
          pgf
          collection-fontsrecommended
          ;
      };
    };
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {visualizerSupport = true;};
      bindings = [
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "ctrl-u";
          command = "page_up";
        }
        {
          key = "ctrl-d";
          command = "page_down";
        }
        {
          key = "g";
          command = "move_home";
        }
        {
          key = "G";
          command = "move_end";
        }
        {
          key = "l";
          command = "enter_directory";
        }
        {
          key = "l";
          command = "run_action";
        }
        {
          key = "l";
          command = "play_item";
        }
        {
          key = "l";
          command = "next_column";
        }
        {
          key = "l";
          command = "slave_screen";
        }
        {
          key = "0";
          command = "volume_up";
        }
        {
          key = "9";
          command = "volume_down";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "h";
          command = "master_screen";
        }
        {
          key = "v";
          command = "show_visualizer";
        }
        {
          key = "c";
          command = "show_clock";
        }
        {
          key = "h";
          command = "jump_to_parent_directory";
        }
        {
          key = "n";
          command = "next_found_item";
        }
        {
          key = "N";
          command = "previous_found_item";
        }
        {
          key = ".";
          command = "show_lyrics";
        }
        {
          key = "F";
          command = "toggle_crossfade";
        }
        {
          key = "X";
          command = "clear_main_playlist";
        }
        {
          key = "x";
          command = "delete_playlist_items";
        }
      ];
      settings = {
        song_columns_list_format = "(6f)[default]{l} (30)[default]{t|f} (25)[default]{a} (40)[default]{b}";
        now_playing_prefix = "$b";
        now_playing_suffix = "$/b";
        playlist_display_mode = "classic";
        autocenter_mode = "yes";
        centered_cursor = "yes";
        # Others;
        song_window_title_format = "{%a - }{%t}{ - %b{ Disc %d}}|{%f}";
        follow_now_playing_lyrics = "yes";
        clock_display_seconds = "yes";
        # Bars;
        song_status_format = "$7%t » %a » %b";
        #progressbar_look = "|] ";
        progressbar_look = "━■";
        titles_visibility = "yes";
        # Colors;
        #discard_colors_if_item_is_selected = "yes";
        #header_window_color = "default";
        #volume_color = "default";
        #state_line_color = "default";
        #state_flags_color = "default";
        #main_window_color = "default";
        #color1 = "default";
        #color2 = "default";
        #progressbar_color = "default";
        #statusbar_color = "default";
        #visualizer_color = "default";
      };
    };
    fish = {
      enable = true;
      plugins = [
        {
          name = "tide";
          src = tide;
        }
      ];
      shellInit = ''
        set fish_greeting

        function fish_user_key_bindings
          fish_vi_key_bindings
          bind f accept-autosuggestion
        end

        set fish_cursor_insert block

        string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/icons.fish | source
        string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/configs/lean.fish | source
        string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/configs/lean_16color.fish | source
        set -g tide_prompt_add_newline_before false

        fish_config theme choose fish\ default
        set fish_color_autosuggestion white
      '';
      shellAliases = {
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        mkd = "mkdir -pv";
        yta = "yt-dlp -xf bestaudio/best";
        ip = "ip -c=auto";
        enru = "trans -t ru --shell";
        ruen = "trans -t en --shell";
        ls = "eza";
        l = "eza --git-ignore $eza_params";
        ll = "eza --all --header --long";
        llm = "eza --all --header --long --sort=modified $eza_params";
        la = "eza -lbhHigUmuSa";
        lx = "eza -lbhHigUmuSa@";
        tree = "eza --tree --level=2";
        e = "emacsclient -c";
        z = "zathura";
        sct = "systemctl";
      };
      shellAbbrs = {
        update = "nixos-rebuild --use-remote-sudo -v -L switch --flake ~/.local/dotfiles";
      };
    };
    eza = {
      enable = true;
      icons = "auto";
      enableFishIntegration = true;
      extraOptions = [
        "--git"
        "--group"
        "--color-scale=all"
        "--group-directories-first"
        "--time-style=long-iso"
        "-1"
      ];
    };
    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        statusbar-h-padding = 0;
        statusbar-v-padding = 0;
        page-padding = 1;
        font = "Alegreya 16";
      };
      mappings = {
        u = "scroll half-up";
        d = "scroll half-down";
        D = "toggle_page_mode";
        K = "zoom in";
        J = "zoom out";
        i = "recolor";
        g = "goto top";
        f = "toggle_fullscreen";
        "[fullscreen] f" = "toggle_fullscreen";
        "[fullscreen] u" = "scroll half-up";
        "[fullscreen] d" = "scroll half-down";
        "[fullscreen] D" = "toggle_page_mode";
        "[fullscreen] K" = "zoom in";
        "[fullscreen] J" = "zoom out";
        "[fullscreen] i" = "recolor";
        "[fullscreen] g" = "goto top";
      };
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--layout=reverse"
        "--height 40%"
      ];
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };
    yt-dlp = {
      enable = true;
      package = pkgs.yt-dlp;
      extraConfig = ''
        --ignore-errors
        -o ~/Music/yt-dlp/%(title)s.%(ext)s
      '';
    };
    git = {
      enable = true;
      userName = "apostolic";
      userEmail = "sedativechan@gmail.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
      settings = {
        PASSWORD_STORE_CLIP_TIME = "30";
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };
    translate-shell = {
      enable = true;
      settings = {
        translation = false;
        language = false;
        original = false;
        original-phonetic = false;
        translation-phonetic = false;
        dictionary = true;
        alternatives = true;
      };
    };
    mpv = {
      enable = true;
      config = {
        sub-scale = 3;
        sub-auto = "fuzzy";
        sub-bold = true;
        volume = 50;
        ytdl-format = "bestvideo+bestaudio";
        keep-open = true;
        save-position-on-quit = true;
      };
    };
    htop = {
      enable = true;
      package = pkgs.htop;
      settings =
        {
          color_scheme = 6;
          cpu_count_from_one = 0;
          delay = 15;
          fields = with config.lib.htop.fields; [
            PID
            USER
            PRIORITY
            NICE
            PERCENT_CPU
            PERCENT_MEM
            COMM
          ];
          highlight_base_name = 1;
          highlight_megabytes = 1;
          highlight_threads = 1;
          tree_view = 1;
          show_program_path = 0;
        }
        // (
          with config.lib.htop;
            leftMeters [
              (bar "AllCPUs2")
              (bar "Memory")
              (bar "Swap")
              (text "Zram")
            ]
        )
        // (
          with config.lib.htop;
            rightMeters [
              (text "Tasks")
              (text "LoadAverage")
              (text "Uptime")
              (text "Systemd")
            ]
        );
    };
  };

  stylix.targets.emacs.enable = false;

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
