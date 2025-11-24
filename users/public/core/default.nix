{
  imports = [
    ./console.nix
    ./journald.nix
    ./locale.nix
    ./nix.nix
    ./sudo.nix
    ./timesyncd.nix
  ];

  users = {
    mutableUsers = false;
  };
}
