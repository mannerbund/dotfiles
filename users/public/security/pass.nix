{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.persistence."/persist" = {
        directories = [ ".password-store" ];
      };

      programs.password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
        settings = {
          PASSWORD_STORE_CLIP_TIME = "30";
          PASSWORD_STORE_DIR = "$HOME/.password-store";
          PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
          PASSWORD_STORE_EXTENSIONS_DIR = "${pkgs.passExtensions.pass-otp}/lib/password-store/extensions";
        };
      };
    };
}
