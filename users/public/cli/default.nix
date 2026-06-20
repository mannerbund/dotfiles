{
  username,
  pkgs,
  ...
}:
{

  environment.systemPackages = [ pkgs.tree ];

  home-manager.users.${username} =
    {
      programs = {
        fzf = {
          enable = true;
          enableZshIntegration = true;
          tmux.enableShellIntegration = true;
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

        zsh.shellAliases = {
          yta = "yt-dlp -xf bestaudio/best";
          tree = "tree -L 2";
        };
      };
    };
}
