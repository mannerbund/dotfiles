{
  description = "Python";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              (pkgs.python313.withPackages (
                python-pkgs: with python-pkgs; [
                  ipython
                  python-lsp-server
                  python-lsp-black
                  flake8
                  black
                  pytest
                  numpy
                  matplotlib
                  pandas
                  requests
                  scipy
                  statsmodels
                  sympy
                  seaborn
                  scikit-image
                  scikit-learn
                ]
              ))
            ];
          };
        };
    };
}
