{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mannerbund";
        email = "apostalimus@gmail.com";
      };
      init.defaultBranch = "main";
    };
    ignores = [
      ".direnv"
    ];
  };
}
