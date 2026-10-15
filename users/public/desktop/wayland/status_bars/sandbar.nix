{
  username,
  ...
}:
{
  home-manager.users.${username} =
    { pkgs, ... }:
    {

      home.packages = [ pkgs.sandbar ];
      home.file.".config/river/status" = {
        executable = true;
        text = ''
          FIFO="$XDG_RUNTIME_DIR/sandbar"
          [ -e "$FIFO" ] && rm -f "$FIFO"
          mkfifo "$FIFO"

          while cat "$FIFO"; do :; done | sandbar \
          	-font "Aporetic:size=16" \
          	-active-fg-color "#000000" \
          	-active-bg-color "#98971a" \
          	-inactive-fg-color "#ebdbb2" \
          	-inactive-bg-color "#000000" \
          	-urgent-fg-color "#000000" \
          	-urgent-bg-color "#cc241d" \
          	-title-fg-color "#000000" \
          	-title-bg-color "#98971a"
        '';
      };
      home.file.".config/river/bar" = {
        executable = true;
        text = ''
          datetime() {
          	datetime="$(date "+%a %d %b %I:%M %P")"
          }

          printf "%s" "$$" > "$XDG_RUNTIME_DIR/status_pid"
          FIFO="$XDG_RUNTIME_DIR/sandbar"
          [ -e "$FIFO" ] || mkfifo "$FIFO"
          sec=0

          while true; do
          	sleep 1 &
          	wait && {
          		[ $((sec % 5)) -eq 0 ] && datetime

          		sec=$((sec + 1))
          	}
          done
        '';
      };
    };
}
