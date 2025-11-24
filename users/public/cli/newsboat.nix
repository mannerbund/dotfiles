{
  config,
  pkgs,
  ...
}:
{
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [ ".local/share/newsboat" ];
  };

  programs.newsboat = {
    enable = true;
    reloadThreads = 5;
    reloadTime = 120;
    extraConfig = ''
      unbind-key ,
      unbind-key j
      unbind-key k
      unbind-key G
      unbind-key g
      unbind-key d
      unbind-key u
      unbind-key o
      unbind-key O

      bind-key j down
      bind-key k up
      bind-key G end
      bind-key g home
      bind-key d pagedown
      bind-key u pageup
      bind-key o open
      bind-key O open-in-browser

      color background          color223   color0
      color listnormal          color223   color0
      color listnormal_unread   color2     color0
      color listfocus           color223   color237
      color listfocus_unread    color223   color237
      color info                color8     color0
      color article             color223   color0

      highlight all "---.*---" color11 color237 bold
      highlight article "^(Feed|Link):.*$" color11 default bold
      highlight article "^(Title|Date|Author):.*$" color11 default bold
      highlight article "https?://[^ ]+" color2 default underline
      highlight article "\\[[0-9]+\\]" color2 default bold
      highlight article "\\[image\\ [0-9]+\\]" color2 default bold
      highlight feedlist ".*(0/0))" color0 color0

      browser "\${pkgs.xdg-utils}/bin/xdg-open"

      #bind-key J next-feed articlelist
      #bind-key K prev-feed articlelist
      #bind-key h quit
      #bind-key a toggle-article-read
      #bind-key n next-unread
      #bind-key N prev-unread
      #bind-key D pb-download
      #bind-key U show-urls
      #bind-key x pb-delete
    '';
  };
}
