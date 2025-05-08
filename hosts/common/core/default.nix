{
  inputs,
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
    ./stylix.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  services.speechd.enable = lib.mkForce false;
  documentation.nixos.enable = lib.mkForce false;
}
