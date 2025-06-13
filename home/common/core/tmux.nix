{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".tmux"];
  };

  stylix.targets.tmux.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "foot";
    shell = "${pkgs.zsh}/bin/zsh";
    #shell = "${pkgs.fish}/bin/fish";
    clock24 = false;
    baseIndex = 1;
    keyMode = "vi";
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
  };
}
