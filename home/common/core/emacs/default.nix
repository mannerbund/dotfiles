{
  pkgs,
  inputs,
  config,
  ...
}: {
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".emacs.d"];
  };

  home.sessionVariables = let
    emacs = "${pkgs.emacs-git-pgtk}";
  in {
    ALTERNATE_EDITOR = "";
    EDITOR = "${emacs}/bin/emacsclient -nw"; # $EDITOR opens in terminal
    VISUAL = "${emacs}/bin/emacsclient -c -a ${emacs}/bin/emacs"; # $VISUAL opens in GUI mode
  };

  home.packages = with pkgs; [
    (aspellWithDicts (
      dicts:
        with dicts; [
          en
          en-computers
          en-science
          ru
        ]
    ))
    clang
    graphviz
    emacs-lsp-booster
    nil
  ];

  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-git-pgtk;
        config = ./emacs.el;
        defaultInitFile = true;
        extraEmacsPackages = epkgs: [
          (epkgs.treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-python
            grammars.tree-sitter-go
            grammars.tree-sitter-heex
            grammars.tree-sitter-json
            grammars.tree-sitter-json5
            grammars.tree-sitter-nix
            grammars.tree-sitter-rust
            grammars.tree-sitter-yaml
          ]))
          epkgs.nix-ts-mode
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
