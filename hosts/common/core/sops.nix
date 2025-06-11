{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/sops-nix";
      user = "root";
      group = "keys";
      mode = "0700";
    }
  ];

  sops = {
    defaultSopsFile = ../secrets/default.yaml;
    secrets = {
      apostolic_passwd = {
        neededForUsers = true;
      };
      rss = {
        sopsFile = ../secrets/rss.yaml;
        group = "users";
        mode = "0440";
      };
    };
    age = {
      keyFile = "/persist/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];
  };
}
