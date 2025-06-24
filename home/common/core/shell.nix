{
  config,
  pkgs,
  lib,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/zsh" # for .zcompdump
    ];
    files = [
      ".local/share/zoxide/db.zo"
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
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
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
      update = "nixos-rebuild switch --use-remote-sudo -v -L --flake ~/.local/dotfiles";
    };
    initContent = let
      zshConfig =
        lib.mkOrder 1000
        ''
          export KEYTIMEOUT=1

          bindkey -v '^?' backward-delete-char
          bindkey '`' autosuggest-accept

          # Change cursor shape for different vi modes.
          function zle-keymap-select () {
              case $KEYMAP in
                  vicmd) echo -ne '\e[1 q';;      # block
                  viins|main) echo -ne '\e[5 q';; # beam
              esac
                                          }
          zle -N zle-keymap-select
          zle-line-init() {
              zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
              echo -ne "\e[5 q"
                          }
          zle -N zle-line-init
          echo -ne '\e[5 q' # Use beam shape cursor on startup.
          preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
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
