{
  imports = [
    ./network.nix
    ./hardware-configuration.nix

    ../public/core

    # user(s)
    ../../users/apostolic

  ];

  system.stateVersion = "24.11";
}
