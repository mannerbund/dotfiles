{
  pkgs,
  config,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".emacs.d"];
  };

  home.sessionVariables = {
    ALTERNATE_EDITOR = "";
    EDITOR = "emacsclient -nw"; # $EDITOR opens in terminal
    VISUAL = "emacsclient -c -a emacs"; # $VISUAL opens in GUI mode
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
    graphviz
    emacs-lsp-booster
    nil
    alejandra
  ];

  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-pgtk;
        config = ./emacs.el;
        defaultInitFile = true;
        extraEmacsPackages = epkgs: [
          (epkgs.treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-python
            grammars.tree-sitter-go
            grammars.tree-sitter-javascript
            grammars.tree-sitter-heex
            grammars.tree-sitter-json
            grammars.tree-sitter-json5
            grammars.tree-sitter-nix
            grammars.tree-sitter-rust
            grammars.tree-sitter-yaml
          ]))
          epkgs.eglot-booster
        ];
      }
    );
  };
}
