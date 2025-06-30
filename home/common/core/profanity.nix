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

    [notifications]
    message=true
    message.text=true
    invite=true

    [connection]
    carbons=true
    receipts.send=true
    receipts.request=true
  '';

  home.packages = with pkgs; [
    profanity
  ];
}
