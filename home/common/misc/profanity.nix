{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/profanity"
    ];
  };

  home.file.".config/profanity/inputrc".text = ''
    $if profanity
    "\M-p": prof_win_pageup
    "\M-n": prof_win_pagedown
    $endif
  '';

  home.packages = with pkgs; [
    profanity
  ];
}
