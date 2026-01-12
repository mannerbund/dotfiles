{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.persistence."/persist" = {
        directories = [ ".tmux" ];
      };

      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "screen-256color";
        baseIndex = 1;
        keyMode = "vi";
        escapeTime = 10;
        mouse = true;
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '20' # minutes
            '';
          }
        ];

        extraConfig = ''
          set -g status-right ""
          set -g status-position top
        '';
      };
    };
}
