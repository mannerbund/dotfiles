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
