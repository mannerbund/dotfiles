{
  inputs,
  self,
  lib,
  system,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./nix.nix
    ./journald.nix
    ./locale.nix
    ./ntpd-rs.nix
    ./openssh.nix
    ./pipewire.nix
    ./systemd-boot.nix
    ./fish.nix
    ./sops.nix
    ./sudo.nix
    ./persistence.nix
    ./zram-generator.nix
  ];

  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
    inputs.niri.overlays.niri
    self.overlays.default
  ];
  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs self;
  };

  services.speechd.enable = lib.mkForce false;
  documentation.nixos.enable = lib.mkForce false;
}
