{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    files = [
      ".local/share/zoxide/db.zo"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      mkd = "mkdir -pv";
      yta = "yt-dlp -xf bestaudio/best";
      ip = "ip -c=auto";
      enru = "trans -t ru -e google --shell";
      ruen = "trans -t en -e google --shell";
      ls = "eza";
      l = "eza --git-ignore $eza_params";
      ll = "eza --all --header --long";
      llm = "eza --all --header --long --sort=modified $eza_params";
      la = "eza -lbhHigUmuSa";
      lx = "eza -lbhHigUmuSa@";
      tree = "eza --tree --level=2";
      e = "emacsclient -nw -c";
      z = "zathura-sandbox";
      sct = "systemctl";
      newsboat = "newsboat -u /run/secrets/rss";
      update = "nixos-rebuild --use-remote-sudo -v -L switch --flake ~/.local/dotfiles";
    };
    history.size = 100000;
  };

  stylix.targets = {
    fzf.enable = true;
    bat.enable = true;
  };

  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    enableZshIntegration = true;
    extraOptions = [
      "--git"
      "--group"
      "--color-scale=all"
      "--group-directories-first"
      "--time-style=long-iso"
      "-1"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--layout=reverse"
      "--height 40%"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.translate-shell = {
    enable = true;
    settings = {
      translation = false;
      language = false;
      original = false;
      original-phonetic = false;
      translation-phonetic = false;
      dictionary = true;
      alternatives = true;
    };
  };
}
