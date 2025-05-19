{
  pkgs,
  config,
  ...
}: {
  programs.htop = {
    enable = true;
    package = pkgs.htop;
    settings =
      {
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
}
