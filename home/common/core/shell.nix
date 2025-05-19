{
  pkgs,
  ...
}: let
  tide = pkgs.fishPlugins.tide.src;
in {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = tide;
      }
    ];
    shellInit = ''
      set fish_greeting

      function fish_user_key_bindings
        fish_vi_key_bindings
        bind -M insert '`' accept-autosuggestion
        bind f accept-autosuggestion
      end

      set fish_cursor_insert block

      string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/icons.fish | source
      string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/configs/lean.fish | source
      string replace -r '^' 'set -g ' < ${tide}/functions/tide/configure/configs/lean_16color.fish | source
      set -g tide_prompt_add_newline_before false

      fish_config theme choose fish\ default
      set fish_color_autosuggestion white
    '';
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
      e = "emacsclient -c";
      z = "zathura-sandbox";
      sct = "systemctl";
    };
    shellAbbrs = {
      update = "nixos-rebuild --use-remote-sudo -v -L switch --flake ~/.local/dotfiles";
    };
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
    enableFishIntegration = true;
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
    enableFishIntegration = true;
    defaultOptions = [
      "--layout=reverse"
      "--height 40%"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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
