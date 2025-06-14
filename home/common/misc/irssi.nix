{config, ...}: let
  gothicTheme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/phracker/irssi-themes/refs/heads/master/gothic.theme";
    sha256 = "10whibwj077f6yx89x7mslx1dkrk6fq24m0mwrq5i954acwxg7bw";
  };
  nick = "${config.home.username}";
in {
  home.file.".irssi/gothic.theme".source = gothicTheme;

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
    '';
  };
}
