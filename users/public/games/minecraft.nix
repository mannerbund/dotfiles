{
  username,
  ...
}:
{

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.persistence."/persist" = {
        directories = [
          ".local/share/PrismLauncher"
        ];
      };

      home.packages = with pkgs; [
        glfw
        (prismlauncher.override {
          # Add binary required by some mod
          # additionalPrograms = [ ffmpeg ];

          # Change Java runtimes available to Prism Launcher
          jdks = [
            graalvmPackages.graalvm-ce
            zulu8
            zulu17
            zulu
          ];
        })
      ];
    };
}
