{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];

  home.sessionVariables = {
    ALTERNATE_EDITOR = "";
    EDITOR = "emacsclient -c"; # $EDITOR opens in terminal
    VISUAL = "emacsclient -c -a emacs"; # $VISUAL opens in GUI mode
  };

  home.packages = with pkgs; [
    graphviz
    emacs-lsp-booster
    nil
  ];

  stylix.targets.emacs.enable = false;

  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-git-pgtk;
        config = ./emacs.el;
        defaultInitFile = true;
        extraEmacsPackages = epkgs: [
          epkgs.manualPackages.treesit-grammars.with-all-grammars
          epkgs.eglot-booster
        ];
        override = epkgs:
          epkgs
          // {
            eglot-booster = pkgs.callPackage ./eglot-booster.nix {
              inherit (pkgs) fetchFromGitHub;
              inherit (epkgs) trivialBuild;
            };
          };
      }
    );
  };
}
