{
  services.zapret = {
    enable = true;
    httpSupport = false;
    whitelist = [
      "10tv.app"
      "7tv.app"
      "7tv.io"
      "audiobookbay.lu"
      "cloudflare-ech.com"
      "dis.gd"
      "discord-attachments-uploads-prd.storage.googleapis.com"
      "discord.app"
      "discord.co"
      "discord.com"
      "discord.design"
      "discord.dev"
      "discord.gift"
      "discord.gifts"
      "discord.gg"
      "discord.media"
      "discord.new"
      "discord.store"
      "discord.status"
      "discord-activities.com"
      "discordactivities.com"
      "discordapp.com"
      "discordapp.net"
      "discordcdn.com"
      "discordmerch.com"
      "discordpartygames.com"
      "discordsays.com"
      "discordsez.com"
      "ggpht.com"
      "goodreads.com"
      "googlevideo.com"
      "jnn-pa.googleapis.com"
      "stable.dl2.discordapp.net"
      "wide-youtube.l.google.com"
      "youtube-nocookie.com"
      "youtube-ui.l.google.com"
      "youtube.com"
      "youtubeembeddedplayer.googleapis.com"
      "youtubekids.com"
      "youtubei.googleapis.com"
      "youtu.be"
      "yt-video-upload.l.google.com"
      "ytimg.com"
      "ytimg.l.google.com"
    ];
    params = [
      "--dpi-desync=fake,disorder"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=3"
      "--dpi-desync-repeats=6"
    ];
  };
}
