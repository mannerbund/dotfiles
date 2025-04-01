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
}
