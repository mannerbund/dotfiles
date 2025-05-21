{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  environment.persistence."/persist" = {
    directories = [
      "/var"
      {
        directory = "/var/lib/sops-nix";
        user = "root";
        group = "keys";
        mode = "u=rwx,g=,o=";
      }
      {
        directory = "/var/lib/wireguard";
        user = "root";
        group = "keys";
        mode = "u=rwx,g=,o=";
      }
    ];
    files = ["/etc/machine-id"];
    users.apostolic = {
      directories = [
        ".cache"
        ".emacs.d"
        ".local"
        ".zen"
        ".password-store"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        "Desktop"
        "Documents"
        "Downloads"
        "Library"
        "Music"
        "Pictures"
        "Videos"
      ];
    };
  };
  programs.fuse.userAllowOther = true;
}
