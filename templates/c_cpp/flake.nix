{
  description = "C/C++";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            tinycc
            gcc
            gdb
            ccls
          ];

          buildInputs = with pkgs; [
            sdl3
          ];
        };
      };
    };
}
