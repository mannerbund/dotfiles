{
  inputs,
  lib,
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
    ./zsh.nix
    ./sops.nix
    ./sudo.nix
    ./persistence.nix
    ./zram-generator.nix
  ];

  users = {
    mutableUsers = false;
  };

  nixpkgs = {
    overlays = [
      inputs.self.overlays.default
      inputs.niri.overlays.niri
      inputs.emacs-overlay.overlays.default
    ];
    config.allowUnfree = true;
  };

  documentation.nixos.enable = lib.mkForce false;
}
