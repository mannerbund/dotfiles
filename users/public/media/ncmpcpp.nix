{ username, ... }:
{
  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.ncmpcpp = {
        enable = true;
        package = pkgs.ncmpcpp.override { visualizerSupport = true; };
        bindings = [
          {
            key = "k";
            command = "scroll_up";
          }
          {
            key = "j";
            command = "scroll_down";
          }
          {
            key = "ctrl-u";
            command = "page_up";
          }
          {
            key = "ctrl-d";
            command = "page_down";
          }
          {
            key = "g";
            command = "move_home";
          }
          {
            key = "G";
            command = "move_end";
          }
          {
            key = "l";
            command = "enter_directory";
          }
          {
            key = "l";
            command = "run_action";
          }
          {
            key = "l";
            command = "play_item";
          }
          {
            key = "l";
            command = "next_column";
          }
          {
            key = "l";
            command = "slave_screen";
          }
          {
            key = "0";
            command = "volume_up";
          }
          {
            key = "9";
            command = "volume_down";
          }
          {
            key = "h";
            command = "previous_column";
          }
          {
            key = "h";
            command = "master_screen";
          }
          {
            key = "v";
            command = "show_visualizer";
          }
          {
            key = "c";
            command = "show_clock";
          }
          {
            key = "h";
            command = "jump_to_parent_directory";
          }
          {
            key = "n";
            command = "next_found_item";
          }
          {
            key = "N";
            command = "previous_found_item";
          }
          {
            key = ".";
            command = "show_lyrics";
          }
          {
            key = "F";
            command = "toggle_crossfade";
          }
          {
            key = "X";
            command = "clear_main_playlist";
          }
          {
            key = "x";
            command = "delete_playlist_items";
          }
        ];
        settings = {
          mpd_host = config.services.mpd.network.listenAddress;
          mpd_port = config.services.mpd.network.port;
          song_columns_list_format = "(6f)[default]{l} (30)[default]{t|f} (25)[default]{a} (40)[default]{b}";
          now_playing_prefix = "$b";
          now_playing_suffix = "$/b";
          playlist_display_mode = "classic";
          autocenter_mode = "yes";
          centered_cursor = "yes";
          # Others;
          song_window_title_format = "{%a - }{%t}{ - %b{ Disc %d}}|{%f}";
          follow_now_playing_lyrics = "yes";
          clock_display_seconds = "yes";
          # Bars;
          song_status_format = "$7%t » %a » %b";
          progressbar_look = "━■";
          titles_visibility = "yes";
        };
      };
    };
}
