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

  home.file.".config/profanity/profrc".text = ''
    [ui]
    theme=gruvbox
    history=true

    [logging]
    chlog=true

    [omemo]
    policy=always

    [connection]
    carbons=true
  '';

  home.packages = with pkgs; [
    profanity
  ];
}
