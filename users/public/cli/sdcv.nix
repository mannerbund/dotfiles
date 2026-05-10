{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {

      home.persistence."/persist" = {
        directories = [
          ".local/share/stardict"
        ];
      };

      home = {
        packages = [
          pkgs.sdcv
          pkgs.html2text
        ];
        sessionVariables = {
          STARDICT_DATA_DIR = "${config.home.homeDirectory}/.local/share/stardict";
          SDCV_HIST = "${config.home.homeDirectory}/.local/share/stardict/sdcv_hist";
        };
      };

      programs.zsh = {
        shellAliases = {
          sd = "sdcv -c";
        };
        initContent = lib.mkOrder 1100 ''
          oed() {
            sdcv -0 -1 -n -c -u oed2 "$@" 2>&1 \
            | html2text -utf8 -width 75
          }

          soed() {
            sdcv -0 -1 -n -c -u soed6 "$@" 2>&1 \
            | html2text -utf8 -width 75
          }

          sdeu() {
            sdcv -0 -1 -n -c -u duden "$@" 2>&1 \
            | html2text -utf8 -width 75
          }

          sdal() {
            sdcv -0 -1 -n -c -u dal "$@" 2>&1
          }

          sdalabbrev() {
            sdcv -0 -1 -n -c -u dalabbrev "$@" 2>&1
          }
        '';
      };
    };
}
