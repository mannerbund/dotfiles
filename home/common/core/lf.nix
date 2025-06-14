{
  pkgs,
  lib,
  config,
  ...
}: let
  eza = lib.getExe pkgs.eza;
  chafa = lib.getExe pkgs.chafa;
  mediainfo = lib.getExe pkgs.mediainfo;
  ffmpegthumb = lib.getExe pkgs.ffmpegthumbnailer;
  file = lib.getExe pkgs.file;
  unzip = lib.getExe pkgs.unzip;
  gzip = lib.getExe pkgs.gzip;
  unrar = lib.getExe pkgs.unrar;
  bat = lib.getExe pkgs.bat;
  epub-thumbnailer = lib.getExe pkgs.epub-thumbnailer;
  pdftoppm = "${pkgs.poppler_utils}/bin/pdftoppm";
  z7 = "${pkgs.p7zip}/bin/7z";
in {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/lf"
    ];
  };

  programs.lf = {
    enable = true;
    settings = {
      drawbox = true;
      ignorecase = true;
      sixel = true;
      tabstop = 4;
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
          lf -remote "send $id set statfmt \"$(${eza} -ld --color=always "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
      }}
    '';
    previewer = {
      keybinding = "i";
      source = pkgs.writeShellScript "pv.sh" ''
        #!/bin/sh
        CACHE="${config.home.homeDirectory}/.cache/lf/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' \
        	-- "$(readlink -f "$1")" | sha256sum | awk '{print $1}'))"

        image() {
          ${chafa} -f sixel -s "$2x$3" --animate off --polite on "$1"
        }

        case "$(readlink -f "$1" | awk '{print tolower($0)}')" in
          *.tgz|*.tar.gz) tar tzf "$1" ;;
          *.tar.bz2|*.tbz2) tar tjf "$1" ;;
          *.tar.xz|*.txz) tar tf "$1" ;;
          *.tar) tar tf "$1" ;;
          *.zip|*.jar|*.war|*.ear|*.oxt) ${unzip} -l "$1" ;;
          *.gz) ${gzip} -l "$1" ;;
          *.rar) ${unrar} l "$1" ;;
          *.7z) ${z7} l "$1" ;;
         *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.mka)
         	${mediainfo} "$1"
         	;;
         *.pdf)
         	[ ! -f "''${CACHE}.jpg" ] && ${pdftoppm} -jpeg -f 1 -singlefile "$1" "$CACHE"
            image "''${CACHE}.jpg" "$2" "$3"
         	;;
         *.epub)
         	[ ! -f "$CACHE" ] && ${epub-thumbnailer} "$1" "$CACHE" 1024
            image "$CACHE" "$2" "$3"
         	;;
         *.cbz|*.cbr|*.cbt)
         	[ ! -f "$CACHE" ] && comicthumb "$1" "$CACHE" 1024
            image "$CACHE" "$2" "$3"
         	;;
         *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.ts|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
         	[ ! -f "''${CACHE}.jpg" ] && \
         		${ffmpegthumb} -i "$1" -o "''${CACHE}.jpg" -s 0 -q 5
              image "''${CACHE}.jpg" "$2" "$3"
         	;;

          *)
            case "$(${file} -Lb --mime-type -- "$1")" in
              image/*)
                image "$1" "$2" "$3"
                exit 0
                ;;
              text/*)
                ${bat} --color=always --style=plain --pager=never "$1"
                exit 0
                ;;
            esac
            ;;
        esac
      '';
    };
  };
}
