{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/direnv"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
