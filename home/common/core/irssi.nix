{config, ...}: let
  nick = "${config.home.username}";
  gothicTheme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/phracker/irssi-themes/refs/heads/master/gothic.theme";
    sha256 = "10whibwj077f6yx89x7mslx1dkrk6fq24m0mwrq5i954acwxg7bw";
  };
  trackbar = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/irssi/scripts.irssi.org/refs/heads/master/scripts/trackbar.pl";
    sha256 = "1hhhs2vxmsml4dfng2iq3723fz86b0l6s91l78zg8chmay89ca4l";
  };
  nickcolor = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/irssi/scripts.irssi.org/refs/heads/master/scripts/nickcolor.pl";
    sha256 = "1imn2ryxq8j7d2iy8cyjnzri83flkz7f34xx8cfj0hlijgqbbir1";
  };
in {
  home.file.".irssi/gothic.theme".source = gothicTheme;
  home.file.".irssi/scripts/autorun/trackbar.pl".source = trackbar;
  home.file.".irssi/scripts/autorun/nickcolor.pl".source = nickcolor;

  programs.irssi = {
    enable = true;
    networks = {
      liberachat = {
        nick = "${nick}";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          ssl.enable = true;
          ssl.verify = true;
        };
      };
      lainchan = {
        nick = "${nick}";
        server = {
          address = "irc.lainchan.org";
          port = 6697;
          ssl.enable = true;
          ssl.verify = true;
        };
      };
    };
    extraConfig = ''
      settings = {
        "fe-common/core" = { theme = "gothic"; };
        "fe-text" = { window_default_hidelevel = "hidden joins parts quits"; };
      };
      keyboard = (
        { key = "^K"; id = "scroll_backward"; data = ""; },
        { key = "^J"; id = "scroll_forward"; data = ""; }
      );

    '';
  };
}
