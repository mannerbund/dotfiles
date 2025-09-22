{
  description = "Coq";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];
    perSystem = { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rocq-core
          rocqPackages.stdlib
        ];
          # shellHook = ''
          #   export ROCQLIB=${pkgs.rocq-core}/bin
          #   export ROCQBIN=${pkgs.rocq-core}/lib
          # '';
      };
    };
  };
}
