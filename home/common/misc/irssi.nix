{
  programs.irssi = {
    enable = true;
    networks = {
      liberachat = {
        nick = "apostolic";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          ssl.enable = true;
          ssl.verify = true;
          autoConnect = true;
        };
      };
    };
  };
}
