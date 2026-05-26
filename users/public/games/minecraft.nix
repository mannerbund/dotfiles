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
          ".minecraft"
          ".java"
        ];
      };

      home.packages = with pkgs; [
        glfw
        (prismlauncher.override {
          # Add binary required by some mod
          # additionalPrograms = [ ffmpeg ];

          # Change Java runtimes available to Prism Launcher
          jdks = [
            # temurin-bin-21
            # temurin-bin-17
            temurin-bin-8
            # openjdk21
            # openjdk17
            openjdk8
            # graalvmPackages.graalvm-ce
            # zulu
          ];
        })
      ];
    };
}
