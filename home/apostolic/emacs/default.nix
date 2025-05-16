{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];

  home.packages = with pkgs; [
    graphviz
    emacs-lsp-booster
    nil
  ];

  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs30-pgtk;
        config = ./emacs.el;
        defaultInitFile = true;
        extraEmacsPackages = epkgs: [
          epkgs.manualPackages.treesit-grammars.with-all-grammars
          epkgs.org-inline-image-fix
          epkgs.eglot-booster
        ];
        override = epkgs:
          epkgs
          // {
            org-inline-image-fix = pkgs.callPackage ./org-inline-image-fix.nix {
              inherit (pkgs) fetchFromGitHub;
              inherit (epkgs) trivialBuild;
            };
            eglot-booster = pkgs.callPackage ./eglot-booster.nix {
              inherit (pkgs) fetchFromGitHub;
              inherit (epkgs) trivialBuild;
            };
          };
      }
    );
  };
}
