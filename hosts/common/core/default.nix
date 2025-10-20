{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nix.nix
    ./journald.nix
    ./locale.nix
    ./ntpd-rs.nix
    ./openssh.nix
    ./pipewire.nix
    ./systemd-boot.nix
    ./zsh.nix
    ./sops.nix
    ./sudo.nix
    ./persistence.nix
    ./zram-generator.nix
  ];

  users = {
    mutableUsers = false;
  };

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs = {
    overlays = [
      inputs.self.overlays.default
      inputs.niri.overlays.niri
      inputs.emacs-overlay.overlays.default
      inputs.nixpkgs-wayland.overlay
    ];
    config.allowUnfree = true;
  };

  documentation.nixos.enable = lib.mkForce false;
}
