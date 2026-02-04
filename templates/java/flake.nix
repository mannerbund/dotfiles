{
  description = "Java";

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
            programs = with pkgs; [
              jdk
              jdt-language-server
            ];
          };
        };
    };
}
