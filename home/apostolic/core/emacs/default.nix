{
  pkgs,
  confg,
  lib,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs30-pgtk;
        config = ./init.el;
        defaultInitFile = true;
        extraEmacsPackages = epkgs: [
          epkgs.manualPackages.treesit-grammars.with-all-grammars
          epkgs.org-inline-image-fix
          pkgs.graphviz
        ];
        override = epkgs:
          epkgs
          // {
            org-inline-image-fix = pkgs.callPackage ./org-inline-image-fix.nix {
              inherit (pkgs) fetchFromGitHub;
              inherit (epkgs) trivialBuild;
            };
          };
      }
    );
  };
}
