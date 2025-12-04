{
  username,
  pkgs,
  ...
}:
{
  users.users.${username} = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.${username} =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home = {
        persistence."/persist/${config.home.homeDirectory}" = {
          directories = [
            ".config/zsh" # for .zcompdump
          ];
        };
        sessionVariables = {
          HISTFILE = "${config.home.homeDirectory}/.cache/history";
        };
      };

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
          ip = "ip -c=auto";
          ls = "ls --color --group-directories-first -v";
          ll = "ls --color -al --group-directories-first -v";
          sct = "systemctl";
          update = "nixos-rebuild switch --sudo -v -L --flake ~/.local/dotfiles";
        };
        initContent =
          let
            zshConfig = lib.mkOrder 1000 ''
              export KEYTIMEOUT=1

              bindkey '`' autosuggest-accept
            '';
            zshConfigLast = lib.mkOrder 1500 ''
              source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
            '';
          in
          lib.mkMerge [
            zshConfig
            zshConfigLast
          ];
      };
    };
}
