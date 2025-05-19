{
  programs.git = {
    enable = true;
    userName = "mannerbund";
    userEmail = "apostalimus@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [
      ".direnv"
    ];
  };
}
