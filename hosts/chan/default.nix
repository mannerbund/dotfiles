{ pkgs, ... }:
{
  imports = [
    ./network.nix
    ./hardware-configuration.nix

    # user(s)
    ../../users/apostolic

    # display manager
    ../public/ly.nix

    # brightness control
    ../public/light.nix
  ];

  system.stateVersion = "24.11";
}
