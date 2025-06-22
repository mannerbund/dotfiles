{
  pkgs,
  lib,
  config,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/lf"
    ];
  };

  home.packages = with pkgs; [
    mediainfo
    file
    unzip
    gzip
    unrar
    bat
    epub-thumbnailer
    p7zip
    xz
    libcdio
    odt2txt
    catdoc
    gnumeric
    exiftool
    man-db
    groff
  ];

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
          lf -remote "send $id set statfmt \"$(${lib.getExe pkgs.eza} -ld --color=always "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
      }}
    '';
    previewer = {
      keybinding = "i";
      source = pkgs.writeShellScript "pv.sh" ''
        #!/bin/sh

        batorcat() {
            file="$1"
            shift
            if command -v bat >/dev/null 2>&1; then
                bat --color=always --style=plain --pager=never "$file" "$@"
            else
                cat "$file"
            fi
        }

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
            *.xls | *.xlsx)
                ssconvert --export-type=Gnumeric_stf:stf_csv "$1" "fd://1" | batorcat --language=csv
                ;;
            *.wav | *.mp3 | *.flac | *.m4a | *.wma | *.ape | *.ac3 | *.og[agx] | *.spx | *.opus | *.as[fx] | *.mka)
                exiftool "$1"
                ;;
            *)
                batorcat "$1"
                ;;
        esac
        exit 0
      '';
    };
  };
}
