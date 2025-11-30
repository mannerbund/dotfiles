{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/lf"
        ];
      };

      home.packages = with pkgs; [
        mediainfo
        file
        unzip
        unrar
        gnome-epub-thumbnailer
        p7zip
        xz
        odt2txt
        catdoc
        exiftool
        ueberzugpp
        ffmpegthumbnailer
        poppler-utils
        imagemagick
      ];

      home.file = {
        ".config/lf/cleaner" = {
          executable = true;
          text = ''
            #!/bin/sh

            ueberzugpp cmd -s $UB_SOCKET -a remove -i PREVIEW
          '';
        };
        ".local/bin/lfub" = {
          executable = true;
          text = ''
            #!/bin/sh

            # This is a wrapper script for lf that allows it to create image previews with
            # ueberzug. This works in concert with the lf configuration file and the
            # lf-cleaner script.

            set -e

            UB_PID=0
            UB_SOCKET=""

            case "$(uname -a)" in
                *Darwin*) UEBERZUG_TMP_DIR="$TMPDIR" ;;
                *) UEBERZUG_TMP_DIR="/tmp" ;;
            esac

            cleanup() {
                exec 3>&-
                ueberzugpp cmd -s "$UB_SOCKET" -a exit
            }

            if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
                lf "$@"
            else
                [ ! -d "$HOME/.cache/lf" ] && mkdir -p "$HOME/.cache/lf"
                UB_PID_FILE="$UEBERZUG_TMP_DIR/.$(uuidgen)"
                ueberzugpp layer --silent --no-stdin --use-escape-codes --pid-file "$UB_PID_FILE"
                UB_PID=$(cat "$UB_PID_FILE")
                rm "$UB_PID_FILE"
                UB_SOCKET="$UEBERZUG_TMP_DIR/ueberzugpp-''${UB_PID}.socket"
                export UB_PID UB_SOCKET
                trap cleanup HUP INT QUIT TERM EXIT
                lf "$@" 3>&-
            fi

          '';
        };
      };

      programs.lf = {
        enable = true;
        settings = {
          drawbox = true;
          ignorecase = true;
          sixel = true;
          tabstop = 4;
          cleaner = "~/.config/lf/cleaner";
        };
        keybindings = {
          "." = "set hidden!";
          U = "glob-unselect";
          gL = "follow-link";
          gd = "cd ~/Desktop";
          go = "cd ~/Documents";
          gw = "cd ~/Downloads";
          gl = "cd ~/Library";
          gm = "cd ~/Music";
          gp = "cd ~/Pictures";
          gv = "cd ~/Videos";
          gr = "cd /";
          e = "emacsclient -nw $f";
        };
        extraConfig = ''
            # Make sure cache folder exists
          %mkdir -p ${config.home.homeDirectory}/.cache/lf

          # Follow symbolic links
          cmd follow-link %{{
            lf -remote "send $id select \"$(readlink -- "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
          }}

          # Editor
          map e !emacsclient -nw "$f"

          # Eza
          cmd on-select &{{
              lf -remote "send $id set statfmt \"$(${lib.getExe pkgs.eza} -ld --color=always "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
          }}
        '';
        previewer = {
          keybinding = "i";
          source = pkgs.writeShellScript "pv.sh" ''
              #!/bin/sh

            image() {
                FILE_PATH="$1"
                X=$4
                Y=$5
                MW=$(($2 - 1))
                MH=$3
                ueberzugpp cmd -s "$UB_SOCKET" -a add -i PREVIEW -x "$X" -y "$Y" --max-width "$MW" --max-height "$MH" -f "$FILE_PATH"
                exit 1
            }

            batorcat() {
                file="$1"
                shift
                if command -v bat >/dev/null 2>&1; then
                    bat --color=always --style=plain --pager=never "$file" "$@"
                else
                    cat "$file"
                fi
            }

            CACHE="$HOME/.cache/lf/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}')"

            case "$(printf "%s\n" "$(readlink -f "$1")" | tr '[:upper:]' '[:lower:]')" in
                *.tgz | *.tar.gz) tar tzf "$1" ;;
                *.tar.bz2 | *.tbz2) tar tjf "$1" ;;
                *.tar.txz | *.txz) xz --list "$1" ;;
                *.tar) tar tf "$1" ;;
                *.zip | *.jar | *.war | *.ear | *.oxt) unzip -l "$1" ;;
                *.rar) unrar l "$1" ;;
                *.7z) 7z l "$1" ;;
                *.[1-8]) man "$1" | col -b ;;
                *.o) nm "$1" ;;
                *.torrent) transmission-show "$1" ;;
                *.iso) iso-info --no-header -l "$1" ;;
                *.odt | *.ods | *.odp | *.sxw) odt2txt "$1" ;;
                *.doc) catdoc "$1" ;;
                *.docx) docx2txt "$1" - ;;
                *.xls | *.xlsx)
                    ssconvert --export-type=Gnumeric_stf:stf_csv "$1" "fd://1" | batorcat --language=csv
                    ;;
                *.wav | *.mp3 | *.flac | *.m4a | *.wma | *.ape | *.ac3 | *.og[agx] | *.spx | *.opus | *.as[fx] | *.mka)
                    exiftool "$1"
                    ;;
                *.pdf)
                    [ ! -f "''${CACHE}.jpg" ] && pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
                    image "''${CACHE}.jpg" "$2" "$3" "$4" "$5"
                    ;;
                *.epub)
                    [ ! -f "''${CACHE}.png" ] && gnome-epub-thumbnailer "$1" "''${CACHE}.png"
                    image "''${CACHE}.png" "$2" "$3" "$4" "$5"
                    ;;

                *.avi | *.mp4 | *.wmv | *.dat | *.3gp | *.ogv | *.mkv | *.mpg | *.mpeg | *.vob | *.fl[icv] | *.m2v | *.mov | *.webm | *.ts | *.mts | *.m4v | *.r[am] | *.qt | *.divx)
                    [ ! -f "''${CACHE}.jpg" ] && ffmpegthumbnailer -i "$1" -o "''${CACHE}.jpg" -s 0 -q 5
                    image "''${CACHE}.jpg" "$2" "$3" "$4" "$5"
                    ;;
                *.bmp | *.jpg | *.jpeg | *.png | *.xpm | *.webp | *.gif | *.jfif)
                    image "$1" "$2" "$3" "$4" "$5"
                    ;;
                *.svg)
                    [ ! -f "''${CACHE}.jpg" ] && convert "$1" "''${CACHE}.jpg"
                    image "''${CACHE}.jpg" "$2" "$3" "$4" "$5"
                    ;;

                *)
                    batorcat "$1"
                    ;;
            esac
            exit 0
          '';
        };
      };

    };
}
