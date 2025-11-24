{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/stardict"
    ];
  };

  home.sessionVariables = {
    STARDICT_DATA_DIR = "${config.home.homeDirectory}/.local/share/stardict";
    SDCV_HIST = "${config.home.homeDirectory}/.local/share/stardict/sdcv_hist";
  };

  home.packages = [
    pkgs.sdcv
    pkgs.html2text
  ];

  programs.zsh = {
    shellAliases = {
      sd = "sdcv -c";
    };
    initContent = lib.mkOrder 1100 ''
      oed() {
        sdcv -0 -1 -n -c -u oed2 "$@" 2>&1 \
        | html2text -utf8 -width 50
      }

      soed() {
        sdcv -0 -1 -n -c -u soed6 "$@" 2>&1 \
        | html2text -utf8 -width 50
      }

      sdr() {
        sdcv -0 -1 -n -c -u ru-en "$@" 2>&1 \
        | html2text -utf8 -width 50
      }
    '';
  };
}
