{
  description = "Python";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    devShells.x86_64-linux.default = with pkgs;
      mkShell {
        packages = [
          (pkgs.python313.withPackages (python-pkgs:
            with python-pkgs; [
              ruff
              python-lsp-server
              python-lsp-ruff
              numpy
              tkinter
              matplotlib
              ipython
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
