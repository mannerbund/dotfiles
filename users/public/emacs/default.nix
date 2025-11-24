{
  username,
  inputs,
}:
{
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlays.default
    ];
  };

  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {

      home = {
        persistence."/persist/${config.home.homeDirectory}" = {
          directories = [ ".emacs.d" ];
        };
        sessionVariables = {
          ALTERNATE_EDITOR = "";
          EDITOR = "emacsclient -nw"; # $EDITOR opens in terminal
          VISUAL = "emacsclient -c -a emacs"; # $VISUAL opens in GUI mode
        };
        packages = with pkgs; [
          (aspellWithDicts (
            dicts: with dicts; [
              en
              en-computers
              en-science
              ru
            ]
          ))
          graphviz
          emacs-lsp-booster
          nixd
        ];
      };

      # TODO: also for fish
      programs.zsh.shellAliases = {
        e = "emacsclient -nw -c";
      };

      services.gpg-agent.extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';

      programs = {
        info.enable = true;
        emacs = {
          enable = true;
          package = (
            pkgs.emacsWithPackagesFromUsePackage {
              package = pkgs.emacs-git;
              config = ./emacs.el;
              defaultInitFile = true;
              extraEmacsPackages = epkgs: [
                (epkgs.treesit-grammars.with-grammars (grammars: [
                  grammars.tree-sitter-python
                  grammars.tree-sitter-javascript
                  grammars.tree-sitter-json
                  grammars.tree-sitter-nix
                ]))
                epkgs.eglot-booster
              ];
            }
          );
        };
      };
    };
}
