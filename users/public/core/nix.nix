{ inputs, lib, ... }:
{
  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = [
      inputs.self.overlays.default
    ];
    config.allowUnfree = true;
  };

  documentation.nixos.enable = lib.mkForce false;
}
