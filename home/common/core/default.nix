{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/nix"
      ".local/share/iwctl"
    ];
  };

  imports = [
    ./emacs
    ./vim.nix
    ./persistence.nix
    ./tmux.nix
    ./ssh.nix
    ./xdg.nix
    ./git.nix
    ./pass.nix
    ./shell.nix
    ./htop.nix
    ./gpg.nix
  ];
}
