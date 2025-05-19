{
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --ignore-errors
      -o ~/Music/yt-dlp/%(title)s.%(ext)s
    '';
  };
}
