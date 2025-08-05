{
  config,
  pkgs,
  lib,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/zsh" # for .zcompdump
      ".local/share/zoxide"
    ];
  };

  home.sessionVariables = {
    HISTFILE = "${config.home.homeDirectory}/.cache/history";
    INPUTRC = "${config.home.homeDirectory}/.local/share/inputrc";
  };

  home.file.".local/share/inputrc".text = ''
    set editing-mode vi
    set show-all-if-ambiguous on

    $if mode=vi
      set show-mode-in-prompt on
      set vi-ins-mode-string \1\e[6 q\2
      set vi-cmd-mode-string \1\e[2 q\2

      set keymap vi-command
      Control-l: clear-screen
      Control-a: beginning-of-line

      set keymap vi-insert
      Control-l: clear-screen
      Control-a: beginning-of-line
    $endif

    $if profanity
      "\C-p": prof_win_prev
      "\C-n": prof_win_next
      "\C-k": prof_win_pageup
      "\C-j": prof_win_pagedown
    $endif
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.package = pkgs.zsh-fast-syntax-highlighting;
    defaultKeymap = "emacs";
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    history.path = "${config.home.homeDirectory}/.cache/zsh/history";
    history.size = 100000;
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
      update = "nixos-rebuild switch --sudo -v -L --flake ~/.local/dotfiles";
    };
    initContent = let
      zshConfig =
        lib.mkOrder 1000
        ''
          export KEYTIMEOUT=1
          
          bindkey '`' autosuggest-accept
        '';
      zshConfigLast = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh 2>/dev/null
      '';
    in
      lib.mkMerge [zshConfig zshConfigLast];
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
    theme = {
      colourful = true;

      filekinds = {
        normal = {foreground = "#ebdbb2";};
        directory = {foreground = "#83a598";};
        symlink = {foreground = "#8ec07c";};
        pipe = {foreground = "#928374";};
        block_device = {foreground = "#fb4934";};
        char_device = {foreground = "#fb4934";};
        socket = {foreground = "#665c54";};
        special = {foreground = "#d3869b";};
        executable = {foreground = "#b8bb26";};
        mount_point = {foreground = "#fe8019";};
      };

      perms = {
        user_read = {foreground = "#ebdbb2";};
        user_write = {foreground = "#fabd2f";};
        user_execute_file = {foreground = "#b8bb26";};
        user_execute_other = {foreground = "#b8bb26";};
        group_read = {foreground = "#ebdbb2";};
        group_write = {foreground = "#fabd2f";};
        group_execute = {foreground = "#b8bb26";};
        other_read = {foreground = "#bdae93";};
        other_write = {foreground = "#fabd2f";};
        other_execute = {foreground = "#b8bb26";};
        special_user_file = {foreground = "#d3869b";};
        special_other = {foreground = "#928374";};
        attribute = {foreground = "#bdae93";};
      };

      size = {
        major = {foreground = "#bdae93";};
        minor = {foreground = "#8ec07c";};
        number_byte = {foreground = "#ebdbb2";};
        number_kilo = {foreground = "#ebdbb2";};
        number_mega = {foreground = "#83a598";};
        number_giga = {foreground = "#d3869b";};
        number_huge = {foreground = "#d3869b";};
        unit_byte = {foreground = "#bdae93";};
        unit_kilo = {foreground = "#83a598";};
        unit_mega = {foreground = "#d3869b";};
        unit_giga = {foreground = "#d3869b";};
        unit_huge = {foreground = "#fe8019";};
      };

      users = {
        user_you = {foreground = "#ebdbb2";};
        user_root = {foreground = "#fb4934";};
        user_other = {foreground = "#d3869b";};
        group_yours = {foreground = "#ebdbb2";};
        group_other = {foreground = "#928374";};
        group_root = {foreground = "#fb4934";};
      };

      links = {
        normal = {foreground = "#8ec07c";};
        multi_link_file = {foreground = "#fe8019";};
      };

      git = {
        new = {foreground = "#b8bb26";};
        modified = {foreground = "#fabd2f";};
        deleted = {foreground = "#fb4934";};
        renamed = {foreground = "#8ec07c";};
        typechange = {foreground = "#d3869b";};
        ignored = {foreground = "#928374";};
        conflicted = {foreground = "#cc241d";};
      };

      git_repo = {
        branch_main = {foreground = "#ebdbb2";};
        branch_other = {foreground = "#d3869b";};
        git_clean = {foreground = "#b8bb26";};
        git_dirty = {foreground = "#fb4934";};
      };

      security_context = {
        colon = {foreground = "#928374";};
        user = {foreground = "#ebdbb2";};
        role = {foreground = "#d3869b";};
        typ = {foreground = "#665c54";};
        range = {foreground = "#d3869b";};
      };

      file_type = {
        image = {foreground = "#fabd2f";};
        video = {foreground = "#fb4934";};
        music = {foreground = "#b8bb26";};
        lossless = {foreground = "#8ec07c";};
        crypto = {foreground = "#928374";};
        document = {foreground = "#ebdbb2";};
        compressed = {foreground = "#d3869b";};
        temp = {foreground = "#cc241d";};
        compiled = {foreground = "#83a598";};
        build = {foreground = "#928374";};
        source = {foreground = "#83a598";};
      };

      punctuation = {foreground = "#928374";};
      date = {foreground = "#fabd2f";};
      inode = {foreground = "#bdae93";};
      blocks = {foreground = "#a89984";};
      header = {foreground = "#ebdbb2";};
      octal = {foreground = "#8ec07c";};
      flags = {foreground = "#d3869b";};

      symlink_path = {foreground = "#8ec07c";};
      control_char = {foreground = "#83a598";};
      broken_symlink = {foreground = "#fb4934";};
      broken_path_overlay = {foreground = "#928374";};
    };
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
