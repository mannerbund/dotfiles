{
  description = "ICE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    niri.url = "github:sodiboo/niri-flake";
    stylix.url = "github:danth/stylix";
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
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  }: let
    lib = nixpkgs.lib // home-manager.lib;
  in
    flake-utils.lib.eachSystem
    [
      "x86_64-linux"
    ]
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };
      in {
        formatter = pkgs.alejandra;
        legacyPackages = pkgs;
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              sops
              age
            ];
          };
      }
    )
    // {
      #nixosModules = import ./modules/nixos;
      #homeModules = import ./modules/home;
      overlays.default = final: prev:
        prev.lib.packagesFromDirectoryRecursive {
          inherit (prev) callPackage;
          directory = ./pkgs;
        };
      nixosConfigurations = {
        chan = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [./hosts/chan];
          specialArgs = {
            inherit inputs self;
          };
        };
      };
    };
}
