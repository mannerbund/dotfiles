{
  description = "ICE";

  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";
    niri.url = "github:sodiboo/niri-flake";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #zen-browser = {
    #  url = "github:0xc000022070/zen-browser-flake";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    home-manager,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = let
        lib = nixpkgs.lib // home-manager.lib;
      in {
        nixosConfigurations = {
          chan = lib.nixosSystem {
            modules = [./hosts/chan];
            specialArgs = {
              inherit inputs;
            };
          };
        };
      };
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              sops
              age
            ];
          };
      };
    };
}
