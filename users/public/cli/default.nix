{
  username,
  pkgs,
  ...
}:
{

  environment.systemPackages = [ pkgs.tree ];

  home-manager.users.${username} =
    { lib, config, ... }:
    {
      programs = {
        fzf = {
          enable = true;
          enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
          enableFishIntegration = lib.mkIf config.programs.fish.enable true;
          tmux.enableShellIntegration = lib.mkIf config.programs.tmux.enable true;
          defaultOptions = [
            "--layout=reverse"
            "--height 40%"
          ];
        };
        yt-dlp = {
          enable = true;
          extraConfig = ''
            --ignore-errors
            -o ~/Music/yt-dlp/%(title)s.%(ext)s
          '';
        };

        htop = {
          enable = true;
          package = pkgs.htop;
          settings = {
            color_scheme = 6;
            cpu_count_from_one = 0;
            delay = 15;
            fields = with config.lib.htop.fields; [
              PID
              USER
              PRIORITY
              NICE
              PERCENT_CPU
              PERCENT_MEM
              COMM
            ];
            highlight_base_name = 1;
            highlight_megabytes = 1;
            highlight_threads = 1;
            tree_view = 1;
            show_program_path = 0;
          }
          // (
            with config.lib.htop;
            leftMeters [
              (bar "AllCPUs2")
              (bar "Memory")
              (bar "Swap")
              (text "Zram")
            ]
          )
          // (
            with config.lib.htop;
            rightMeters [
              (text "Tasks")
              (text "LoadAverage")
              (text "Uptime")
              (text "Systemd")
            ]
          );
        };
        zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
          yta = "yt-dlp -xf bestaudio/best";
          tree = "tree -L 2";
        };
        fish.shellAliases = lib.mkIf config.programs.fish.enable {
          yta = "yt-dlp -xf bestaudio/best";
          tree = "tree -L 2";
        };
      };
    };
}
