{
  stylix.targets.mpv.enable = true;

  programs.mpv = {
    enable = true;
    config = {
      sub-scale = 1.5;
      sub-auto = "fuzzy";
      sub-bold = true;
      volume = 50;
      ytdl-format = "bestvideo+bestaudio";
      keep-open = true;
      save-position-on-quit = true;
    };
  };
}
