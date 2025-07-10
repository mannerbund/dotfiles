{inputs}: {
  default = final: prev: {
    weechat = prev.weechat.override {
      configure = {availablePlugins, ...}: {
        scripts = with prev.pkgs.weechatScripts; [
          autosort
          colorize_nicks
        ];
      };
    };

    #vim = prev.vim.overrideAttrs (old: rec {
    #  version = "9.1.1525";
    #  src = prev.fetchFromGitHub {
    #    owner = "vim";
    #    repo = "vim";
    #    rev = "v${version}";
    #    hash = "sha256-ux1fpuZoM3TJbo0fYC7AnQu+Thetc5HK8KRlgmFyE6c=";
    #  };

    #  configureFlags =
    #    old.configureFlags
    #    ++ [
    #      "--enable-python3interp"
    #      "--without-x"
    #    ];
    #});
  };
}
