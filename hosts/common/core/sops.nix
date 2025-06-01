{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../secrets.yaml;
    secrets = {
      passwd.neededForUsers = true;
      "wireless/home" = {};
    };
    age = {
      keyFile = "/persist/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];
  };

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/sops-nix";
      user = "root";
      group = "keys";
      mode = "u=rwx,g=,o=";
    }
  ];
}
