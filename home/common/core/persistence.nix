{
  inputs,
  config,
  ...
}: {
  imports = [inputs.impermanence.homeManagerModules.impermanence];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".cache"
      ".local/dotfiles"
      ".local/share/keyrings"
      ".local/share/nix"
      ".local/share/iwctl"
      ".ssh"
      "Desktop"
      "Documents"
      "Downloads"
      "Library"
      "Music"
      "Pictures"
      "Videos"
    ];
    allowOther = true;
  };
}
