{
  config,
  pkgs,
  ...
}: let
  HOME = "${config.home.homeDirectory}/.local/share/vim";
in {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/vim"
    ];
  };

  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim;
    defaultEditor = false;
    settings = {
      expandtab = true;
      history = 10000;
      directory = ["${HOME}/swap"];
      backupdir = ["${HOME}/backups"];
    };
    plugins = [
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-airline
    ];
    extraConfig = ''
      let mapleader = ","

      set viminfo+=n${HOME}/.viminfo
      let g:netrw_home = '${HOME}/netrw'

      set hlsearch
      set noshowcmd
      set mouse=a
      set ttymouse=sgr

      " Replace ex mode with gq
      map Q gq
    '';
  };
}
