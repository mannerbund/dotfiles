{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".local/share/qutebrowser"];
  };

  home.sessionVariables = {
    BROWSER = "qutebrowser";
  };

  programs.qutebrowser = {
    enable = true;
    quickmarks = {
      github = "https://github.com";
      chatgpt = "https://chatgpt.com";
      nixos-search = "https://search.nixos.org";
      home-manager = "https://home-manager-options.extranix.com/?query=&release=master";
      libgen = "https://libgen.rs";
      annas-archive = "https://annas-archive.org";
      audiobookbay = "https://audiobookbay.lu";
      z-lib = "https://1lib.sk";
      flibusta = "https://flibusta.is";
      rutracker = "https://rutracker.org";
      thepiratebay = "https://thepiratebay.org";
    };
    keyBindings = {
      normal = {
        "td" = "config-cycle colors.webpage.darkmode.enabled true false";
      };
    };
    settings = {
      zoom.default = "125%";
      fonts.default_size = "15pt";
      colors.webpage.darkmode.enabled = true;
      auto_save.session = true;
      session.lazy_restore = false;
      spellcheck.languages = ["en-US" "ru-RU"];
      content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0";
      content.headers.accept_language = "en-US,en;q=0.5";
      content.blocking.method = "both";
    };
  };
}
