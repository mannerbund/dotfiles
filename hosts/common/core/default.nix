{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./console.nix
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
    ];
    config.allowUnfree = true;
  };

  documentation.nixos.enable = lib.mkForce false;
}
