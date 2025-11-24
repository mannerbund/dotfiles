{
  inputs,
  config,
  username,
  ...
}:
let
  key_location = "/persist/var/lib/sops-nix/key.txt";
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets."${username}-pass" = {
      neededForUsers = true;
      key = "${username}-pass";
      group = "users";
      mode = "0440";
    };

    age = {
      # key must be in persisted directory
      keyFile = key_location;
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = key_location;
  };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets."${username}-pass".path;
  };
}
