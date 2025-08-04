{
  description = "Python";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        (pkgs.python313.withPackages (python-pkgs:
          with python-pkgs; [
            ipython
            black
            mypy
            ruff
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
          ]))
      ];
    };
  };
}
