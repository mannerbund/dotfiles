{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/nix"
      ".local/share/iwctl"
    ];
  };

  imports = [
    ./emacs
    ./persistence.nix
    ./tmux.nix
    ./ssh.nix
    ./newsboat.nix
    ./xdg.nix
    ./git.nix
    ./pass.nix
    ./shell.nix
    ./htop.nix
    ./lf.nix
    ./gpg.nix
    ./profanity.nix
    ./irssi.nix
  ];
}
