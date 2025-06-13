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
    ./stylix.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  documentation.nixos.enable = lib.mkForce false;
}
