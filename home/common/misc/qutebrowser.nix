{
  stylix.targets.qutebrowser.enable = true;

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
    settings = {
      auto_save.session = true;
      session.lazy_restore = false;
    };
  };
}
